import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBarChart extends StatelessWidget {
  final Map<String, int> data;
  final List<String> orderKeys;
  final Color primaryColor;
  final Color textColor;
  final double padding;
  final double borderRadius;

  const CustomBarChart({
    super.key,
    required this.data,
    required this.orderKeys,
    required this.primaryColor,
    required this.textColor,
    this.padding = 20.0,
    this.borderRadius = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CustomBarChartPainter(
        data: data,
        orderKeys: orderKeys,
        primaryColor: primaryColor,
        textColor: textColor,
        padding: padding,
        borderRadius: borderRadius,
      ),
    );
  }
}

class CustomBarChartPainter extends CustomPainter {
  final Map<String, int> data;
  final List<String> orderKeys;
  final Color primaryColor;
  final Color textColor;
  final double padding;
  final double borderRadius;

  CustomBarChartPainter({
    required this.data,
    required this.orderKeys,
    required this.primaryColor,
    required this.textColor,
    required this.padding,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || orderKeys.isEmpty) return;

    int maxVal = data.values.reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) maxVal = 1;

    final double width = size.width;
    final double height = size.height;

    final double chartWidth = width - 2 * padding;
    final double chartHeight = height - 2 * padding;

    final double barSpacing = chartWidth / (orderKeys.length * 2);
    final double barWidth = chartWidth / orderKeys.length - barSpacing;

    final paint = Paint()..style = PaintingStyle.fill;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < orderKeys.length; i++) {
      final key = orderKeys[i];
      final count = data[key] ?? 0;

      final double x = padding + i * (barWidth + barSpacing) + barSpacing / 2;
      final double barValHeight = (count / maxVal) * chartHeight;
      final double y = height - padding - barValHeight;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTRB(x, y, x + barWidth, height - padding),
        Radius.circular(borderRadius),
      );

      paint.shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [primaryColor, primaryColor.withValues(alpha: 0.4)],
      ).createShader(Rect.fromLTRB(x, y, x + barWidth, height - padding));

      canvas.drawRRect(rect, paint);

      if (count > 0) {
        textPainter.text = TextSpan(
          text: '$count',
          style: TextStyle(
            color: textColor,
            fontSize: 9.sp,
            fontWeight: FontWeight.bold,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x + (barWidth - textPainter.width) / 2, y - 12.h),
        );
      }

      textPainter.text = TextSpan(
        text: key,
        style: TextStyle(
          color: textColor.withValues(alpha: 0.6),
          fontSize: 9.sp,
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x + (barWidth - textPainter.width) / 2, height - padding + 4.h),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomBarChartPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.orderKeys != orderKeys ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.textColor != textColor ||
        oldDelegate.padding != padding ||
        oldDelegate.borderRadius != borderRadius;
  }
}
