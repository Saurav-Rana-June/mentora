import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';

class DoctorListLoading extends StatefulWidget {
  const DoctorListLoading({super.key});

  @override
  State<DoctorListLoading> createState() => _DoctorListLoadingState();
}

class _DoctorListLoadingState extends State<DoctorListLoading>
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
            children: List.generate(3, (index) {
              return Container(
                margin: EdgeInsets.only(bottom: Spacing.s12.symmetric.horizontal),
                padding: EdgeInsets.all(Spacing.s12.symmetric.horizontal),
                decoration: BoxDecoration(
                  color: isDark ? slate[800] : Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isDark ? slate[700]! : Colors.grey.shade100,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar Circle skeleton
                        Container(
                          width: 56.r,
                          height: 56.r,
                          decoration: BoxDecoration(
                            color: skeletonColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Spacing.s12.w,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name skeleton
                              Container(
                                height: 16.h,
                                width: 140.w,
                                decoration: BoxDecoration(
                                  color: skeletonColor,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              Spacing.s8.h,
                              // Specialty skeleton
                              Container(
                                height: 12.h,
                                width: 180.w,
                                decoration: BoxDecoration(
                                  color: skeletonColor,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              Spacing.s12.h,
                              // Chips row skeleton
                              Row(
                                children: [
                                  Container(
                                    height: 20.h,
                                    width: 50.w,
                                    decoration: BoxDecoration(
                                      color: skeletonColor,
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                  ),
                                  Spacing.s8.w,
                                  Container(
                                    height: 20.h,
                                    width: 80.w,
                                    decoration: BoxDecoration(
                                      color: skeletonColor,
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Spacing.s16.h,
                    // Button skeleton
                    Container(
                      height: 38.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: skeletonColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
