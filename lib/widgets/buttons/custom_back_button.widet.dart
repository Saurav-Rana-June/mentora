import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_icons/icons.dart';

class CustomBackButton extends StatefulWidget {
  final String? icon;
  const CustomBackButton({super.key, this.icon});

  @override
  State<CustomBackButton> createState() => _CustomBackButtonState();
}

class _CustomBackButtonState extends State<CustomBackButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        splashColor: primary.withValues(alpha: 0.3),
        onTap: () {
          Get.back();
        },
        child: Container(
          height: 40.h,
          width: 40.h,
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.25),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              (widget.icon ?? MyIcons.chevronLeft).toString(),
              style: TextStyle(
                fontFamily: 'FontAwesomeLight',
                fontSize: 20,
                color: primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
