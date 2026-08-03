import 'package:flutter/material.dart';
import '../../../infrastructure/theme/theme.dart';

class Loader extends StatelessWidget {
  final double strokeWidth;
  final Color? color;

  const Loader({
    super.key,
    this.strokeWidth = 2.5,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeWidth: strokeWidth,
      valueColor: AlwaysStoppedAnimation<Color>(color ?? primary),
    );
  }
}
