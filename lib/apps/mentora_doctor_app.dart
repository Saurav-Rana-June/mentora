import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:Mentora/apps/app_flavor.dart';
import 'package:Mentora/controllers/global.controller.dart';
import 'package:Mentora/data/utils/storage_utils.dart';
import 'package:Mentora/infrastructure/navigation/navigation.dart';
import 'package:Mentora/infrastructure/navigation/routes.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';

class MentoraDoctorApp extends StatelessWidget {
  final String? initialRoute;

  const MentoraDoctorApp({
    super.key,
    this.initialRoute,
  });

  ThemeMode _getInitialThemeMode() {
    final saved = StorageUtils.read<String>(StorageKeys.THEME_MODE);
    if (saved == 'dark') return ThemeMode.dark;
    if (saved == 'light') return ThemeMode.light;
    return ThemeMode.system;
  }

  @override
  Widget build(BuildContext context) {
    AppFlavor.current = AppFlavor.doctor;

    return ScreenUtilInit(
      designSize: const Size(1440, 900),
      minTextAdapt: true,
      splitScreenMode: true,
      rebuildFactor: RebuildFactors.change,
      builder: (context, child) {
        return GetMaterialApp(
          title: "Mentora Doctors",
          initialRoute: initialRoute ?? Routes.LOGIN_DOCTOR,
          initialBinding: BindingsBuilder(() {
            Get.put(GlobalController(), permanent: true);
          }),
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.fadeIn,
          getPages: Nav.routes,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _getInitialThemeMode(),
        );
      },
    );
  }
}
