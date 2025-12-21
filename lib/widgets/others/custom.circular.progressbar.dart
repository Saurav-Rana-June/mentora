import 'dart:math';
import 'package:flutter/material.dart';

class CustomCircularProgressBar extends StatefulWidget {
  final double percentage; // 0.0 → 1.0
  final double size;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;
  final Duration animationDuration;
  final TextStyle? textStyle;
  final bool showPercentageText;
  final double startAngle;
  final VoidCallback? onComplete;

  const CustomCircularProgressBar({
    super.key,
    required this.percentage,
    this.size = 140,
    this.strokeWidth = 12,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.progressColor = const Color(0xFF8BC34A),
    this.animationDuration = const Duration(milliseconds: 800),
    this.textStyle,
    this.showPercentageText = true,
    this.startAngle = -pi / 2,
    this.onComplete,
  });

  @override
  State<CustomCircularProgressBar> createState() =>
      _CustomCircularProgressBarState();
}

class _CustomCircularProgressBarState extends State<CustomCircularProgressBar> {
  bool _hasCompleted = false;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: widget.percentage.clamp(0.0, 1.0)),
      duration: widget.animationDuration,
      builder: (context, value, child) {
        if (value >= 1.0 && !_hasCompleted) {
          _hasCompleted = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onComplete?.call();
          });
        }

        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _CircularProgressPainter(
                  progress: value,
                  strokeWidth: widget.strokeWidth,
                  backgroundColor: widget.backgroundColor,
                  progressColor: widget.progressColor,
                  startAngle: widget.startAngle,
                ),
              ),
              if (widget.showPercentageText)
                Text(
                  "${(value * 100).round()}%",
                  style:
                      widget.textStyle ??
                      TextStyle(
                        fontSize: widget.size * 0.22,
                        fontWeight: FontWeight.bold,
                      ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;
  final double startAngle;

  _CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
    required this.startAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width / 2) - strokeWidth / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
