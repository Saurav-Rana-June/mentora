import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:Mentora/apps/app_flavor.dart';
import 'package:Mentora/controllers/global.controller.dart';
import 'package:Mentora/infrastructure/navigation/navigation.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';

class MentoraCmsApp extends StatelessWidget {
  final String initialRoute;

  const MentoraCmsApp({
    super.key,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    AppFlavor.current = AppFlavor.cms;

    return ScreenUtilInit(
      designSize: const Size(1440, 900),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: "Mentora CMS",
          initialRoute: initialRoute,
          initialBinding: BindingsBuilder(() {
            Get.put(GlobalController(), permanent: true);
          }),
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.fadeIn,
          getPages: Nav.routes,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
        );
      },
    );
  }
}
