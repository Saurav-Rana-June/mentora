import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../infrastructure/theme/theme.dart';

class CustomToggle extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final List<Widget> children;
  final double? height;
  final double? width;
  final Color? unselectedColor;

  const CustomToggle({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    required this.children,
    this.height,
    this.width,
    this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final finalHeight = height ?? 34.h;
    final finalWidth = width ?? 130.w;
    // Subtract border width (0.8 on each side = 1.6) to get actual inner width
    final double innerWidth = finalWidth - 1.6;
    final double itemWidth = innerWidth / children.length;

    return Container(
      height: finalHeight,
      width: finalWidth,
      decoration: BoxDecoration(
        color: theme.primaryColorLight.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: theme.dividerTheme.color ?? primary.withValues(alpha: 0.08),
          width: 0.8,
        ),
      ),
      child: Stack(
        children: [
          // Sliding indicator
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            left: selectedIndex * itemWidth,
            top: 2.h,
            bottom: 2.h,
            child: Container(
              width: itemWidth,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Container(
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Interactive overlay
          Row(
            children: List.generate(children.length, (index) {
              final isSelected = selectedIndex == index;
              return GestureDetector(
                onTap: () => onChanged(index),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: itemWidth,
                  height: double.infinity,
                  child: Center(
                    child: DefaultTextStyle(
                      style: r12.copyWith(
                        color: isSelected
                            ? Colors.white
                            : (unselectedColor ?? theme.textTheme.bodyLarge!.color),
                        fontWeight: FontWeight.w600,
                      ),
                      child: IconTheme(
                        data: IconThemeData(
                          color: isSelected
                              ? Colors.white
                              : (unselectedColor ?? theme.textTheme.bodyLarge!.color),
                          size: 18,
                        ),
                        child: children[index],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
