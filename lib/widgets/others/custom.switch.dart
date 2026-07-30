import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    final Color activeTrackColor = activeColor ?? primary;
    final Color inactiveTrackColor =
        inactiveColor ?? (isDark ? slate[700]! : slate[200]!);
    final Color finalThumbColor = thumbColor ?? white;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 44.w,
        height: 24.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: value ? activeTrackColor : inactiveTrackColor,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.all(3.r),
            child: Container(
              width: 18.h, // Use height/radius consistent spacing
              height: 18.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: finalThumbColor,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(0, 0, 0, 0.16),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
