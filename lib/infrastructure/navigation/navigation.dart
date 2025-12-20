import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:Mentora/infrastructure/navigation/bindings/controllers/splash.controller.binding.dart';

import '../../config.dart';
import '../../presentation/screens.dart';
import 'bindings/controllers/controllers_bindings.dart';
import 'bindings/controllers/home.controller.binding.dart';
import 'routes.dart';

class EnvironmentsBadge extends StatelessWidget {
  final Widget child;
  const EnvironmentsBadge({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    var env = ConfigEnvironments.getEnvironments()['env'];
    return env != Environments.PRODUCTION
        ? Banner(
            location: BannerLocation.topStart,
            message: env!,
            color: env == Environments.QAS ? Colors.blue : Colors.purple,
            child: child,
          )
        : SizedBox(child: child);
  }
}

class Nav {
  static List<GetPage> routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      binding: HomeControllerBinding(),
    ),
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashScreen(),
      binding: SplashControllerBinding(),
    ),
    GetPage(
      name: Routes.INTRODUCTION,
      page: () => IntroductionScreen(),
      binding: IntroductionControllerBinding(),
    ),
    GetPage(
      name: Routes.CONTINUE,
      page: () => const ContinueScreen(),
      binding: ContinueControllerBinding(),
    ),
    GetPage(
      name: Routes.SIGN_UP,
      page: () => const SignUpScreen(),
      binding: SignUpControllerBinding(),
    ),
    GetPage(
      name: Routes.SIGN_IN,
      page: () => const SignInScreen(),
      binding: SignInControllerBinding(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => OnboardingScreen(),
      binding: OnboardingControllerBinding(),
    ),
  ];
}
