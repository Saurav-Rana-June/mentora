import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../infrastructure/theme/theme.dart';
import '../../widgets/others/custom.screen.wrapper.dart';
import 'controllers/splash.controller.dart';

class SplashScreen extends GetView<SplashController> {
  SplashScreen({super.key});

  @override
  final controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).scaffoldBackgroundColor,
        statusBarIconBrightness: Get.isDarkMode
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: black,
      ),
    );

    return CustomScreenWrapper(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60.spMin,
                width: 60.spMin,
                child: Image.asset('assets/logos/logo.png', fit: BoxFit.fill),
              ),
              Spacing.s8.w,
              IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mentora',
                      style: h1.copyWith(
                        height: 1,
                        color: Theme.of(context).textTheme.headlineLarge?.color,
                      ),
                    ),
                    Text(
                      'Your Wellness App',
                      style: r14.copyWith(
                        height: 1,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
