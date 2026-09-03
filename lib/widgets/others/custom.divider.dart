import 'package:flutter/material.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';

class CustomDivider extends StatelessWidget {
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;

  const CustomDivider({
    super.key,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color effectiveColor = color ?? (isDark ? slate[600]! : slate[100]!);

    return Divider(
      height: height ?? 1,
      thickness: thickness ?? 1,
      indent: indent,
      endIndent: endIndent,
      color: effectiveColor,
    );
  }
}
