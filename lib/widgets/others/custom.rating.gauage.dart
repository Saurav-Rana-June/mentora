import 'dart:math';

import 'package:flutter/material.dart';

final segments = [
  GaugeSegment(Colors.red, Icons.sentiment_very_dissatisfied),
  GaugeSegment(Colors.deepOrange, Icons.sentiment_dissatisfied),
  GaugeSegment(Colors.orange, Icons.sentiment_neutral),
  GaugeSegment(Colors.lightGreen, Icons.sentiment_satisfied),
  GaugeSegment(Colors.green, Icons.sentiment_very_satisfied),
];

class RatingGauge extends StatefulWidget {
  const RatingGauge({super.key});

  @override
  State<RatingGauge> createState() => _RatingGaugeState();
}

class _RatingGaugeState extends State<RatingGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double needleAngle = -pi; // start left

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  void moveNeedle(double targetAngle) {
    final animation = Tween<double>(
      begin: needleAngle,
      end: targetAngle,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    animation.addListener(() {
      setState(() => needleAngle = animation.value);
    });

    _controller.forward(from: 0);
  }

  void onTap(TapDownDetails details, Size size) {
    final center = Offset(size.width / 2, size.height);
    final local = details.localPosition;

    final angle = atan2(local.dy - center.dy, local.dx - center.dx);

    // limit to semi-circle
    if (angle < -pi || angle > 0) return;

    final segmentAngle = pi / segments.length;
    final index = ((angle.abs()) ~/ segmentAngle).clamp(0, segments.length - 1);

    final targetAngle = -pi + segmentAngle * index + segmentAngle / 2;
    moveNeedle(targetAngle);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxWidth / 2);

        return GestureDetector(
          onTapDown: (d) => onTap(d, size),
          child: CustomPaint(
            size: size,
            painter: GaugePainter(segments: segments, needleAngle: needleAngle),
          ),
        );
      },
    );
  }
}

class GaugePainter extends CustomPainter {
  final List<GaugeSegment> segments;
  final double needleAngle;

  GaugePainter({required this.segments, required this.needleAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 60;

    final segmentAngle = pi / segments.length;
    double startAngle = -pi;

    // Draw segments
    for (final segment in segments) {
      paint.color = segment.color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 20),
        startAngle,
        segmentAngle,
        false,
        paint,
      );
      startAngle += segmentAngle;
    }

    // Draw needle
    // Draw needle as triangle
    final needlePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final needleLength = radius - 40;
    final needleWidth = 20;

    // Tip of the needle
    final tip = Offset(
      center.dx + cos(needleAngle) * needleLength,
      center.dy + sin(needleAngle) * needleLength,
    );

    // Base left & right (perpendicular to angle)
    final baseLeft = Offset(
      center.dx + cos(needleAngle + pi / 2) * needleWidth,
      center.dy + sin(needleAngle + pi / 2) * needleWidth,
    );

    final baseRight = Offset(
      center.dx + cos(needleAngle - pi / 2) * needleWidth,
      center.dy + sin(needleAngle - pi / 2) * needleWidth,
    );

    final needlePath = Path()
      ..moveTo(tip.dx, tip.dy) // sharp point
      ..lineTo(baseLeft.dx, baseLeft.dy)
      ..lineTo(baseRight.dx, baseRight.dy)
      ..close();

    canvas.drawPath(needlePath, needlePaint);

    // Center cap
    canvas.drawCircle(center, 20, Paint()..color = Colors.grey);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GaugeSegment {
  final Color color;
  final IconData icon;

  GaugeSegment(this.color, this.icon);
}
