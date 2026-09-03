import 'package:flutter/material.dart';
import 'package:my_spacing/my_spacing.dart';

class CustomPrimaryBottomBar extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final double? height;
  final double? width;
  final bool useSafeArea;
  final BorderRadiusGeometry? borderRadius;

  const CustomPrimaryBottomBar({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.boxShadow,
    this.border,
    this.height,
    this.width,
    this.useSafeArea = true,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: height,
      width: width,
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: Spacing.s8.symmetric.horizontal,
            vertical: Spacing.s8.symmetric.horizontal,
          ),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.primaryColorLight,
        borderRadius: borderRadius,
        border: border,
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
      ),
      child: useSafeArea ? SafeArea(child: child) : child,
    );
  }
}
