import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLineChart extends StatelessWidget {
  final List<String> checkInMoods;
  final Color primaryColor;
  final Color textColor;
  final double strokeWidth;
  final double dotRadius;
  final double padding;
  final int maxPoints;
  final List<String> yAxisLabels;

  const CustomLineChart({
    super.key,
    required this.checkInMoods,
    required this.primaryColor,
    required this.textColor,
    this.strokeWidth = 3.5,
    this.dotRadius = 6.0,
    this.padding = 15.0,
    this.maxPoints = 7,
    this.yAxisLabels = const ["GREAT", "CALM", "LOW"],
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CustomLineChartPainter(
        checkInMoods: checkInMoods,
        primaryColor: primaryColor,
        textColor: textColor,
        strokeWidth: strokeWidth,
        dotRadius: dotRadius,
        padding: padding,
        maxPoints: maxPoints,
        yAxisLabels: yAxisLabels,
      ),
    );
  }
}

class CustomLineChartPainter extends CustomPainter {
  final List<String> checkInMoods;
  final Color primaryColor;
  final Color textColor;
  final double strokeWidth;
  final double dotRadius;
  final double padding;
  final int maxPoints;
  final List<String> yAxisLabels;

  CustomLineChartPainter({
    required this.checkInMoods,
    required this.primaryColor,
    required this.textColor,
    required this.strokeWidth,
    required this.dotRadius,
    required this.padding,
    required this.maxPoints,
    required this.yAxisLabels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (checkInMoods.isEmpty) return;

    final moods = checkInMoods.length > maxPoints
        ? checkInMoods.sublist(checkInMoods.length - maxPoints)
        : checkInMoods;

    final double stepX =
        size.width / (moods.length - 1 == 0 ? 1 : moods.length - 1);
    final double height = size.height;

    final gridPaint = Paint()
      ..color = textColor.withValues(alpha: 0.1)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final double maxScoreY = padding;
    final double midScoreY = padding + 2.0 * (height - 2 * padding) / 4.0;
    final double minScoreY = padding + 4.0 * (height - 2 * padding) / 4.0;

    void drawDashedLine(double y) {
      double startX = 0;
      const dashWidth = 5.0;
      const dashSpace = 4.0;
      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, y),
          Offset(startX + dashWidth, y),
          gridPaint,
        );
        startX += dashWidth + dashSpace;
      }
    }

    drawDashedLine(maxScoreY);
    drawDashedLine(midScoreY);
    drawDashedLine(minScoreY);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    void drawLabel(String text, double y) {
      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(
          color: textColor.withValues(alpha: 0.4),
          fontSize: 8.sp,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(4.w, y - 12.h));
    }

    if (yAxisLabels.length >= 3) {
      drawLabel(yAxisLabels[0], maxScoreY);
      drawLabel(yAxisLabels[1], midScoreY);
      drawLabel(yAxisLabels[2], minScoreY);
    }

    final points = <Offset>[];
    for (int i = 0; i < moods.length; i++) {
      double score = 3.0;
      switch (moods[i]) {
        case 'Very Good':
        case 'Very Happy':
          score = 5.0;
          break;
        case 'Good':
        case 'Happy':
          score = 4.0;
          break;
        case 'Normal':
          score = 3.0;
          break;
        case 'Not Good':
          score = 2.0;
          break;
        case 'Angry':
          score = 1.0;
          break;
      }

      final double y = padding + (5.0 - score) * (height - 2 * padding) / 4.0;
      final double x = i * stepX;
      points.add(Offset(x, y));
    }

    final path = Path();
    path.moveTo(points.first.dx, height);
    for (var point in points) {
      path.lineTo(point.dx, point.dy);
    }
    path.lineTo(points.last.dx, height);
    path.close();

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          primaryColor.withValues(alpha: 0.25),
          primaryColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTRB(0, 0, size.width, height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, gradientPaint);

    final linePaint = Paint()
      ..color = primaryColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      final p0 = points[i - 1];
      final p1 = points[i];
      final controlPoint1 = Offset(p0.dx + stepX / 2.0, p0.dy);
      final controlPoint2 = Offset(p1.dx - stepX / 2.0, p1.dy);
      linePath.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p1.dx,
        p1.dy,
      );
    }
    canvas.drawPath(linePath, linePaint);

    final dotPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    final dotBorderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (var point in points) {
      canvas.drawCircle(point, dotRadius, dotPaint);
      canvas.drawCircle(point, dotRadius, dotBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomLineChartPainter oldDelegate) {
    return oldDelegate.checkInMoods != checkInMoods ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.textColor != textColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dotRadius != dotRadius ||
        oldDelegate.padding != padding ||
        oldDelegate.maxPoints != maxPoints ||
        oldDelegate.yAxisLabels != yAxisLabels;
  }
}
