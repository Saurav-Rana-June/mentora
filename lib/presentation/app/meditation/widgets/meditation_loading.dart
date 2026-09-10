import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';

class MeditationLoading extends StatefulWidget {
  const MeditationLoading({super.key});

  @override
  State<MeditationLoading> createState() => _MeditationLoadingState();
}

class _MeditationLoadingState extends State<MeditationLoading>
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
    final skeletonColor = isDark ? slate[700]! : slate[200]!;

    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar Skeleton
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.s16.value.w,
                  vertical: Spacing.s8.value.h,
                ),
                child: Container(
                  height: 48.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: skeletonColor,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
              ),
              Spacing.s12.h,

              // Filter Chips Skeleton
              SizedBox(
                height: 36.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: Spacing.s16.value.w),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: Spacing.s8.value.w),
                      child: Container(
                        height: 36.h,
                        width: (70 + (index * 15)).w,
                        decoration: BoxDecoration(
                          color: skeletonColor,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Spacing.s24.h,

              // Section Title Skeleton
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Spacing.s16.value.w),
                child: Container(
                  height: 20.h,
                  width: 120.w,
                  decoration: BoxDecoration(
                    color: skeletonColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              Spacing.s12.h,

              // Featured Carousel Card Skeleton
              SizedBox(
                height: 180.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: Spacing.s16.value.w),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 280.w,
                      margin: EdgeInsets.only(right: Spacing.s16.value.w),
                      decoration: BoxDecoration(
                        color: skeletonColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    );
                  },
                ),
              ),
              Spacing.s24.h,

              // Section Title Skeleton 2
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Spacing.s16.value.w),
                child: Container(
                  height: 20.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                    color: skeletonColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              Spacing.s12.h,

              // Vertical List Cards Skeleton
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: Spacing.s16.value.w),
                  itemCount: 3,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: Spacing.s12.value.h),
                      child: Container(
                        height: 90.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: skeletonColor,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
