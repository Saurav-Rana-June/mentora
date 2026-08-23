import 'package:flutter/material.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:my_spacing/spacing.enum.dart';

class CustomPrimaryCard extends StatelessWidget {
  final Widget? child;
  final double? borderRadius;
  final BorderRadius? customBorderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final Color? color;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  final double? width;
  final double? height;

  final VoidCallback? onTap;

  const CustomPrimaryCard({
    super.key,
    this.child,
    this.borderRadius,
    this.customBorderRadius,
    this.padding,
    this.margin,
    this.color,
    this.border,
    this.boxShadow,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        customBorderRadius ?? BorderRadius.circular(borderRadius ?? 16);

    final effectiveColor =
        color ?? Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor;

    final effectiveBoxShadow = boxShadow ??
        [
          const BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            offset: Offset(0, 1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
          const BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            offset: Offset(0, 1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ];

    final effectivePadding =
        padding ??
        EdgeInsets.symmetric(
          horizontal: Spacing.s8.symmetric.horizontal,
          vertical: Spacing.s8.symmetric.vertical,
        );

    Widget card = Container(
      width: width,
      height: height,
      margin: margin,
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: effectiveBorderRadius,
        border: border,
        boxShadow: effectiveBoxShadow,
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: effectiveBorderRadius,
        child: InkWell(
          borderRadius: effectiveBorderRadius,
          onTap: onTap,
          child: card,
        ),
      );
    }

    return card;
  }
}
