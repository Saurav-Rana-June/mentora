import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final String hintText;

  const CustomSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.focusNode,
    this.hintText = "Search...",
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late final TextEditingController _controller;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _showClearButton = _controller.text.isNotEmpty;
    _controller.addListener(_textListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_textListener);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _textListener() {
    final showClear = _controller.text.isNotEmpty;
    if (_showClearButton != showClear) {
      setState(() {
        _showClearButton = showClear;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextField(
      controller: _controller,
      focusNode: widget.focusNode,
      onChanged: widget.onChanged,
      style: r16.copyWith(color: theme.textTheme.bodyLarge!.color),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: r14.copyWith(color: slate[400]),
        prefixIcon: Padding(
          padding: EdgeInsets.only(
            left: Spacing.s16.value.w,
            right: Spacing.s12.value.w,
          ),
          child: Icon(
            Icons.search,
            size: 22.sp,
            color: isDark ? slate[300] : slate[500],
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
        suffixIcon: _showClearButton
            ? Padding(
                padding: EdgeInsets.only(right: Spacing.s8.value.w),
                child: IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    size: 20.sp,
                    color: isDark ? slate[400] : slate[500],
                  ),
                  onPressed: () {
                    _controller.clear();
                    if (widget.onChanged != null) {
                      widget.onChanged!("");
                    }
                  },
                ),
              )
            : null,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
        filled: true,
        fillColor: isDark ? slate[800] : white,
        contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide(
            color: primary.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
