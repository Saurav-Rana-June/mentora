import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';

class SleepContentLoading extends StatefulWidget {
  final int selectedTabIndex;

  const SleepContentLoading({super.key, required this.selectedTabIndex});

  @override
  State<SleepContentLoading> createState() => _SleepContentLoadingState();
}

class _SleepContentLoadingState extends State<SleepContentLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.35, end: 0.75).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final skeletonColor = isDark ? slate[800]! : slate[100]!;

    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: widget.selectedTabIndex == 0
              ? _buildSoundsLoading(skeletonColor)
              : _buildMediaListLoading(skeletonColor),
        );
      },
    );
  }

  Widget _buildSoundsLoading(Color skeletonColor) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: Spacing.s12.value.w,
        mainAxisSpacing: Spacing.s16.value.h,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              height: 72.h,
              width: 72.h,
              decoration: BoxDecoration(
                color: skeletonColor,
                shape: BoxShape.circle,
              ),
            ),
            Spacing.s8.h,
            Container(
              height: 12.h,
              width: 60.w,
              decoration: BoxDecoration(
                color: skeletonColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMediaListLoading(Color skeletonColor) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s16.symmetric.horizontal,
        vertical: Spacing.s8.symmetric.horizontal,
      ),
      itemCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: Spacing.s12.value.h),
          child: Container(
            height: 94.h,
            decoration: BoxDecoration(
              color: skeletonColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Container(
                  height: 94.h,
                  width: 94.h,
                  decoration: BoxDecoration(
                    color: skeletonColor.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      bottomLeft: Radius.circular(16.r),
                    ),
                  ),
                ),
                Spacing.s12.w,
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 16.h,
                          width: 160.w,
                          decoration: BoxDecoration(
                            color: skeletonColor.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        Container(
                          height: 12.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: skeletonColor.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
