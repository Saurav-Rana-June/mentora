import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';

class AdminSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String searchHint;
  final ValueChanged<String>? onSearchChanged;
  final String? buttonText;
  final VoidCallback? onAddPressed;
  final String? secondaryButtonText;
  final IconData? secondaryButtonIcon;
  final VoidCallback? onSecondaryPressed;
  final List<Widget>? extraActions;
  final Widget? filterWidget;
  final VoidCallback? onRefresh;

  const AdminSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.searchHint = 'Search...',
    this.onSearchChanged,
    this.buttonText,
    this.onAddPressed,
    this.secondaryButtonText,
    this.secondaryButtonIcon,
    this.onSecondaryPressed,
    this.extraActions,
    this.filterWidget,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 680;
        final hasButtons = (buttonText != null && onAddPressed != null) ||
            (secondaryButtonText != null && onSecondaryPressed != null) ||
            (extraActions != null && extraActions!.isNotEmpty) ||
            (onRefresh != null);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Title, Subtitle, and Action Buttons
            if (isCompact) ...[
              Text(
                title,
                style: h2.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.headlineLarge?.color,
                ),
              ),
              if (subtitle != null) ...[
                Spacing.s4.h,
                Text(
                  subtitle!,
                  style: r12.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
              if (hasButtons) ...[
                Spacing.s12.h,
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: _buildActionButtons(context, isDark, isCompact: true),
                ),
              ],
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: h2.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.textTheme.headlineLarge?.color,
                          ),
                        ),
                        if (subtitle != null) ...[
                          Spacing.s4.h,
                          Text(
                            subtitle!,
                            style: r14.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (hasButtons) ...[
                    Spacing.s16.w,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: _buildActionButtons(context, isDark, isCompact: false),
                    ),
                  ],
                ],
              ),
            ],
            Spacing.s16.h,
            // Search Bar & Filter Row
            if (onSearchChanged != null || filterWidget != null) ...[
              if (isCompact && filterWidget != null && onSearchChanged != null) ...[
                _buildSearchBar(context, isDark),
                Spacing.s8.h,
                filterWidget!,
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (onSearchChanged != null)
                      Expanded(
                        child: _buildSearchBar(context, isDark),
                      ),
                    if (filterWidget != null) ...[
                      Spacing.s12.w,
                      filterWidget!,
                    ],
                  ],
                ),
              ],
            ],
          ],
        );
      },
    );
  }

  List<Widget> _buildActionButtons(
    BuildContext context,
    bool isDark, {
    required bool isCompact,
  }) {
    final theme = Theme.of(context);
    final List<Widget> buttons = [];

    if (onRefresh != null) {
      buttons.add(
        IconButton(
          onPressed: onRefresh,
          icon: Icon(
            Icons.refresh_rounded,
            color: theme.textTheme.bodyMedium?.color,
            size: 20,
          ),
          tooltip: 'Refresh list',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        ),
      );
    }

    if (extraActions != null) {
      for (final action in extraActions!) {
        if (!isCompact && buttons.isNotEmpty) {
          buttons.add(Spacing.s8.w);
        }
        buttons.add(action);
      }
    }

    if (secondaryButtonText != null && onSecondaryPressed != null) {
      if (!isCompact && buttons.isNotEmpty) {
        buttons.add(Spacing.s12.w);
      }
      buttons.add(
        OutlinedButton.icon(
          onPressed: onSecondaryPressed,
          icon: Icon(
            secondaryButtonIcon ?? Icons.tune_rounded,
            size: 16,
            color: primary,
          ),
          label: Text(
            secondaryButtonText!,
            style: r14.copyWith(
              fontWeight: FontWeight.w600,
              color: primary,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: primary.withValues(alpha: 0.35),
              width: 1.2,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 12 : 16,
              vertical: isCompact ? 10 : 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        ),
      );
    }

    if (buttonText != null && onAddPressed != null) {
      if (!isCompact && buttons.isNotEmpty) {
        buttons.add(Spacing.s12.w);
      }
      buttons.add(
        ElevatedButton.icon(
          onPressed: onAddPressed,
          icon: Icon(Icons.add_rounded, size: 18, color: white),
          label: Text(
            buttonText!,
            style: r14.copyWith(
              fontWeight: FontWeight.w600,
              color: white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 14 : 18,
              vertical: isCompact ? 10 : 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            elevation: 0,
          ),
        ),
      );
    }

    return buttons;
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return Container(
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF242522) : white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : slate[200]!,
        ),
      ),
      child: TextField(
        onChanged: onSearchChanged,
        textAlignVertical: TextAlignVertical.center,
        style: r14.copyWith(
          color: theme.textTheme.bodyLarge?.color,
        ),
        decoration: InputDecoration(
          isDense: true,
          hintText: searchHint,
          hintStyle: r14.copyWith(color: slate[400]),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20,
            color: slate[400],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
        ),
      ),
    );
  }
}
