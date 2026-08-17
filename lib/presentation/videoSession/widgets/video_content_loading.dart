import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';

class VideoContentLoading extends StatefulWidget {
  const VideoContentLoading({super.key});

  @override
  State<VideoContentLoading> createState() => _VideoContentLoadingState();
}

class _VideoContentLoadingState extends State<VideoContentLoading>
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
    final secondarySkeletonColor = isDark ? slate[800]! : slate[100]!;

    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: Spacing.s8.symmetric.vertical),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.s16.value.w,
                  vertical: Spacing.s8.value.h,
                ),
                child: CustomPrimaryCard(
                  borderRadius: 16.r,
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail skeleton
                      Container(
                        height: 105.h,
                        width: 95.h,
                        decoration: BoxDecoration(
                          color: skeletonColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.r),
                            bottomLeft: Radius.circular(16.r),
                          ),
                        ),
                      ),
                      // Metadata skeleton
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: Spacing.s12.value.h,
                            horizontal: Spacing.s12.value.w,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title skeleton
                              Container(
                                height: 16.h,
                                width: 180.w,
                                decoration: BoxDecoration(
                                  color: skeletonColor,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              Spacing.s8.h,
                              // Subtitle row skeleton
                              Row(
                                children: [
                                  Container(
                                    height: 12.h,
                                    width: 60.w,
                                    decoration: BoxDecoration(
                                      color: secondarySkeletonColor,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                  ),
                                  Spacing.s8.w,
                                  Container(
                                    height: 12.h,
                                    width: 40.w,
                                    decoration: BoxDecoration(
                                      color: secondarySkeletonColor,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                  ),
                                ],
                              ),
                              Spacing.s12.h,
                              // Description skeleton lines
                              Container(
                                height: 12.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: secondarySkeletonColor,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              Spacing.s4.h,
                              Container(
                                height: 12.h,
                                width: 120.w,
                                decoration: BoxDecoration(
                                  color: secondarySkeletonColor,
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
          ),
        );
      },
    );
  }
}
