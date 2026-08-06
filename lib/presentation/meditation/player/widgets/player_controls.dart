import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';

class PlayerControls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback? onPlayPauseTap;
  final VoidCallback? onPreviousTap;
  final VoidCallback? onNextTap;

  const PlayerControls({
    super.key,
    required this.isPlaying,
    this.onPlayPauseTap,
    this.onPreviousTap,
    this.onNextTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.s24.value.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous Button
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPreviousTap,
              child: Container(
                height: 48.h,
                width: 48.h,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    '\u{f048}', // step-backward
                    style: TextStyle(
                      fontFamily: 'FontAwesomeSolid',
                      fontSize: 18.sp,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Spacing.s24.w,

          // Play / Pause Large Center Button
          GestureDetector(
            onTap: onPlayPauseTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 72.h,
              width: 72.h,
              decoration: BoxDecoration(
                color: primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                  child: Text(
                    isPlaying ? '\u{f04c}' : '\u{f04b}', // pause or play
                    key: ValueKey<bool>(isPlaying),
                    style: TextStyle(
                      fontFamily: 'FontAwesomeSolid',
                      fontSize: 24.sp,
                      color: white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Spacing.s24.w,

          // Next Button
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onNextTap,
              child: Container(
                height: 48.h,
                width: 48.h,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    '\u{f051}', // step-forward
                    style: TextStyle(
                      fontFamily: 'FontAwesomeSolid',
                      fontSize: 18.sp,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
