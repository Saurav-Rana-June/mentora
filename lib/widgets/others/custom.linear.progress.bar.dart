import 'package:flutter/material.dart';

class CustomLinearProgressBar extends StatelessWidget {
  /// Progress value between 0.0 and 1.0
  final double progress;

  /// Height of the progress bar
  final double height;

  /// Total width (defaults to full available width)
  final double? width;

  /// Background color of the bar
  final Color backgroundColor;

  /// Solid progress color (ignored if gradient is provided)
  final Color progressColor;

  /// Gradient for the progress bar
  final Gradient? gradient;

  /// Border radius of the bar
  final BorderRadiusGeometry borderRadius;

  /// Animation duration
  final Duration animationDuration;

  /// Whether animation is enabled
  final bool animate;

  /// Optional shadow
  final List<BoxShadow>? boxShadow;

  /// Show progress text (e.g. 30%)
  final bool showLabel;

  /// Custom label builder
  final String Function(double progress)? labelBuilder;

  /// Text style for label
  final TextStyle? labelStyle;

  const CustomLinearProgressBar({
    super.key,
    required this.progress,
    this.height = 8,
    this.width,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.progressColor = Colors.blue,
    this.gradient,
    this.borderRadius = const BorderRadius.all(Radius.circular(100)),
    this.animationDuration = const Duration(milliseconds: 300),
    this.animate = true,
    this.boxShadow,
    this.showLabel = false,
    this.labelBuilder,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: width ?? double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
            boxShadow: boxShadow,
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: clampedProgress),
              duration: animate ? animationDuration : Duration.zero,
              builder: (context, value, _) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: gradient == null ? progressColor : null,
                      gradient: gradient,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        if (showLabel) ...[
          const SizedBox(height: 6),
          Text(
            labelBuilder?.call(clampedProgress) ??
                '${(clampedProgress * 100).round()}%',
            style:
                labelStyle ??
                Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ],
    );
  }
}
