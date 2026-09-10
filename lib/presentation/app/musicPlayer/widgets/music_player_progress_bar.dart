import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';

class MusicPlayerProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final ValueChanged<double>? onChanged;
  final String totalDurationString; // e.g. "10 min" or "25 min"

  const MusicPlayerProgressBar({
    super.key,
    required this.progress,
    this.onChanged,
    required this.totalDurationString,
  });

  // Helper to parse duration string like "10 min" to total seconds
  int _getTotalSeconds() {
    final clean = totalDurationString.replaceAll(RegExp(r'[^0-9]'), '').trim();
    final minutes = int.tryParse(clean) ?? 10;
    return minutes * 60;
  }

  // Helper to format seconds to mm:ss
  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final totalSeconds = _getTotalSeconds();
    final elapsedSeconds = (progress * totalSeconds).round();
    final remainingSeconds = totalSeconds - elapsedSeconds;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.s24.value.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4.h,
              activeTrackColor: primary,
              inactiveTrackColor: Theme.of(context).sliderTheme.inactiveTrackColor,
              thumbColor: primary,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 6.r,
              ),
              overlayColor: primary.withValues(alpha: 0.12),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 18.r),
            ),
            child: Slider(
              value: progress,
              onChanged: onChanged,
            ),
          ),
          
          // Timestamps
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Spacing.s16.value.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(elapsedSeconds),
                  style: r12.copyWith(
                    color: Theme.of(context).textTheme.bodySmall!.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '-${_formatDuration(remainingSeconds)}',
                  style: r12.copyWith(
                    color: Theme.of(context).textTheme.bodySmall!.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
