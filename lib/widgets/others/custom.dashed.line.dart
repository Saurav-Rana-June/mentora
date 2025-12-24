import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomDashedLine extends StatelessWidget {
  final double? height; // nullable
  final double dashHeight;
  final double dashSpace;
  final Color color;
  final double width;

  const CustomDashedLine({
    super.key,
    this.height, // optional
    this.dashHeight = 6,
    this.dashSpace = 4,
    this.color = Colors.grey,
    this.width = 1,
  });

  @override
  Widget build(BuildContext context) {
    final dashedLine = CustomPaint(
      painter: _DashedLinePainter(
        dashHeight: dashHeight,
        dashSpace: dashSpace,
        color: color,
        width: width,
      ),
    );

    // If height is provided → fixed height
    if (height != null) {
      return SizedBox(height: height, width: width, child: dashedLine);
    }

    // If height is NOT provided → take all available height
    return Expanded(
      child: SizedBox(width: width, child: dashedLine),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final double dashHeight;
  final double dashSpace;
  final Color color;
  final double width;

  _DashedLinePainter({
    required this.dashHeight,
    required this.dashSpace,
    required this.color,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width;

    double y = 0;
    while (y < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, y),
        Offset(size.width / 2, y + dashHeight),
        paint,
      );
      y += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
