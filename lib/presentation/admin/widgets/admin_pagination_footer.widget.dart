import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';

/// A modern, responsive pagination footer for Admin CMS pages and tables.
///
/// Provides numbered page navigation, first/last quick jumps, previous/next controls,
/// and responsive item summary display for desktop, tablet, and mobile screens.
class AdminPaginationFooter extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;
  final int? totalItems;
  final int? itemsPerPage;
  final int? currentItemCount;
  final String itemName;
  final bool showFirstLast;
  final bool hideIfSinglePage;
  final List<int>? rowsPerPageOptions;
  final ValueChanged<int>? onRowsPerPageChanged;

  const AdminPaginationFooter({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.totalItems,
    this.itemsPerPage,
    this.currentItemCount,
    this.itemName = 'items',
    this.showFirstLast = true,
    this.hideIfSinglePage = false,
    this.rowsPerPageOptions,
    this.onRowsPerPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (hideIfSinglePage && totalPages <= 1) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final isVeryNarrow = constraints.maxWidth < 380;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 16,
            vertical: isMobile ? 10 : 12,
          ),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1F1D) : white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : slate[200]!,
            ),
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: isMobile
              ? _buildMobileLayout(context, isDark, isVeryNarrow)
              : _buildDesktopLayout(context, isDark),
        );
      },
    );
  }

  /// Desktop / Tablet single-row layout
  Widget _buildDesktopLayout(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left side: summary info & optional page size dropdown
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSummaryText(context),
            if (rowsPerPageOptions != null && onRowsPerPageChanged != null) ...[
              Spacing.s16.w,
              _buildPageSizeSelector(context, isDark),
            ],
          ],
        ),

        // Right side: navigation buttons & numeric pills
        Row(
          mainAxisSize: MainAxisSize.min,
          children: _buildPaginationControls(context, isDark, isMobile: false),
        ),
      ],
    );
  }

  /// Mobile stacked layout
  Widget _buildMobileLayout(
    BuildContext context,
    bool isDark,
    bool isVeryNarrow,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildSummaryText(context, isMobile: true)),
            if (rowsPerPageOptions != null && onRowsPerPageChanged != null)
              _buildPageSizeSelector(context, isDark, isMobile: true),
          ],
        ),
        Spacing.s8.h,
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildPaginationControls(
              context,
              isDark,
              isMobile: true,
              isVeryNarrow: isVeryNarrow,
            ),
          ),
        ),
      ],
    );
  }

  /// Summary text indicating total items and current view range
  Widget _buildSummaryText(BuildContext context, {bool isMobile = false}) {
    final theme = Theme.of(context);
    String summary;

    if (totalItems != null && itemsPerPage != null) {
      if (totalItems == 0) {
        summary = '0 $itemName';
      } else {
        final from = ((currentPage - 1) * itemsPerPage!) + 1;
        final to = (currentPage * itemsPerPage!).clamp(0, totalItems!);
        summary = isMobile
            ? '$from–$to of $totalItems $itemName'
            : 'Showing $from to $to of $totalItems $itemName';
      }
    } else if (totalItems != null && currentItemCount != null) {
      summary = isMobile
          ? '$currentItemCount of $totalItems $itemName'
          : 'Showing $currentItemCount of $totalItems $itemName';
    } else if (totalItems != null) {
      summary = isMobile
          ? 'Page $currentPage of $totalPages ($totalItems)'
          : 'Page $currentPage of $totalPages ($totalItems $itemName)';
    } else {
      summary = 'Page $currentPage of $totalPages';
    }

    return Text(
      summary,
      style: (isMobile ? r12 : r14).copyWith(
        color: theme.textTheme.bodySmall?.color,
        fontWeight: FontWeight.w500,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Page size dropdown selector (optional)
  Widget _buildPageSizeSelector(
    BuildContext context,
    bool isDark, {
    bool isMobile = false,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF282926) : slate[100],
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : slate[200]!,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: itemsPerPage ?? rowsPerPageOptions!.first,
          isDense: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16,
            color: slate[400],
          ),
          dropdownColor: isDark ? const Color(0xFF282926) : white,
          borderRadius: BorderRadius.circular(8.r),
          style: (isMobile ? r10 : r12).copyWith(
            color: theme.textTheme.bodyMedium?.color,
            fontWeight: FontWeight.w600,
          ),
          items: rowsPerPageOptions!.map((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value / page'),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null && onRowsPerPageChanged != null) {
              onRowsPerPageChanged!(val);
            }
          },
        ),
      ),
    );
  }

  /// Pagination buttons, icons, and numbered pills
  List<Widget> _buildPaginationControls(
    BuildContext context,
    bool isDark, {
    required bool isMobile,
    bool isVeryNarrow = false,
  }) {
    final List<Widget> controls = [];
    final hasPrev = currentPage > 1;
    final hasNext = currentPage < totalPages;

    // First Page Jump Button
    if (showFirstLast && totalPages > 2) {
      controls.add(
        _buildNavButton(
          context: context,
          icon: Icons.first_page_rounded,
          tooltip: 'First Page',
          onTap: hasPrev ? () => onPageChanged(1) : null,
          isDark: isDark,
          isMobile: isMobile,
        ),
      );
      controls.add(SizedBox(width: isMobile ? 4 : 6));
    }

    // Previous Page Button
    controls.add(
      _buildNavButton(
        context: context,
        icon: Icons.chevron_left_rounded,
        label: isMobile ? null : 'Previous',
        tooltip: 'Previous Page',
        onTap: hasPrev ? () => onPageChanged(currentPage - 1) : null,
        isDark: isDark,
        isMobile: isMobile,
      ),
    );
    controls.add(SizedBox(width: isMobile ? 4 : 6));

    // Page Number Pills
    final pageNumbers = _calculatePageNumbers(
      maxVisible: isVeryNarrow ? 3 : (isMobile ? 4 : 5),
    );

    for (int i = 0; i < pageNumbers.length; i++) {
      final page = pageNumbers[i];
      if (page == -1) {
        // Ellipsis marker
        controls.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 2 : 4),
            child: Text(
              '...',
              style: r14.copyWith(
                color: isDark ? slate[500] : slate[400],
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      } else {
        final isSelected = page == currentPage;
        controls.add(
          _buildPagePill(
            context: context,
            page: page,
            isSelected: isSelected,
            isDark: isDark,
            isMobile: isMobile,
          ),
        );
      }
      if (i < pageNumbers.length - 1) {
        controls.add(SizedBox(width: isMobile ? 4 : 6));
      }
    }

    // Next Page Button
    controls.add(SizedBox(width: isMobile ? 4 : 6));
    controls.add(
      _buildNavButton(
        context: context,
        icon: Icons.chevron_right_rounded,
        label: isMobile ? null : 'Next',
        isTrailingIcon: true,
        tooltip: 'Next Page',
        onTap: hasNext ? () => onPageChanged(currentPage + 1) : null,
        isDark: isDark,
        isMobile: isMobile,
      ),
    );

    // Last Page Jump Button
    if (showFirstLast && totalPages > 2) {
      controls.add(SizedBox(width: isMobile ? 4 : 6));
      controls.add(
        _buildNavButton(
          context: context,
          icon: Icons.last_page_rounded,
          tooltip: 'Last Page',
          onTap: hasNext ? () => onPageChanged(totalPages) : null,
          isDark: isDark,
          isMobile: isMobile,
        ),
      );
    }

    return controls;
  }

  /// Individual numbered page pill
  Widget _buildPagePill({
    required BuildContext context,
    required int page,
    required bool isSelected,
    required bool isDark,
    required bool isMobile,
  }) {
    final theme = Theme.of(context);
    final size = isMobile ? 32.0 : 36.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isSelected ? null : () => onPageChanged(page),
        borderRadius: BorderRadius.circular(8.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? primary
                : (isDark ? const Color(0xFF282926) : slate[100]),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isSelected
                  ? primary
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : slate[200]!),
              width: 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Text(
            '$page',
            style: (isMobile ? r12 : r14).copyWith(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? white
                  : theme.textTheme.bodyLarge?.color,
            ),
          ),
        ),
      ),
    );
  }

  /// Navigation button (Prev, Next, First, Last)
  Widget _buildNavButton({
    required BuildContext context,
    required IconData icon,
    String? label,
    required String tooltip,
    required VoidCallback? onTap,
    required bool isDark,
    required bool isMobile,
    bool isTrailingIcon = false,
  }) {
    final isEnabled = onTap != null;
    final height = isMobile ? 32.0 : 36.0;

    final Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isTrailingIcon)
          Icon(
            icon,
            size: isMobile ? 18 : 20,
            color: isEnabled
                ? (isDark ? white : slate[800])
                : (isDark ? slate[600] : slate[300]),
          ),
        if (label != null) ...[
          SizedBox(width: isTrailingIcon ? 0 : 4),
          Text(
            label,
            style: r12.copyWith(
              fontWeight: FontWeight.w600,
              color: isEnabled
                  ? (isDark ? white : slate[800])
                  : (isDark ? slate[600] : slate[300]),
            ),
          ),
          SizedBox(width: isTrailingIcon ? 4 : 0),
        ],
        if (isTrailingIcon)
          Icon(
            icon,
            size: isMobile ? 18 : 20,
            color: isEnabled
                ? (isDark ? white : slate[800])
                : (isDark ? slate[600] : slate[300]),
          ),
      ],
    );

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            height: height,
            padding: EdgeInsets.symmetric(
              horizontal: label != null ? 10 : (isMobile ? 6 : 8),
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF282926) : slate[100],
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : slate[200]!,
              ),
            ),
            child: Opacity(
              opacity: isEnabled ? 1.0 : 0.45,
              child: buttonContent,
            ),
          ),
        ),
      ),
    );
  }

  /// Calculates the visible page numbers and ellipsis positions
  List<int> _calculatePageNumbers({int maxVisible = 5}) {
    if (totalPages <= maxVisible) {
      return List.generate(totalPages, (i) => i + 1);
    }

    final List<int> pages = [];
    final half = (maxVisible - 2) ~/ 2;

    int start = currentPage - half;
    int end = currentPage + half;

    if (start <= 2) {
      start = 2;
      end = maxVisible - 1;
    } else if (end >= totalPages - 1) {
      end = totalPages - 1;
      start = totalPages - (maxVisible - 2);
    }

    pages.add(1);

    if (start > 2) {
      pages.add(-1); // -1 represents ellipsis '...'
    }

    for (int i = start; i <= end; i++) {
      if (i > 1 && i < totalPages) {
        pages.add(i);
      }
    }

    if (end < totalPages - 1) {
      pages.add(-1); // -1 represents ellipsis '...'
    }

    if (totalPages > 1) {
      pages.add(totalPages);
    }

    return pages;
  }
}
