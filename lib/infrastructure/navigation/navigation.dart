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
      page: () => SignUpScreen(),
      binding: SignUpControllerBinding(),
    ),
    GetPage(
      name: Routes.SIGN_IN,
      page: () => SignInScreen(),
      binding: SignInControllerBinding(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => OnboardingScreen(),
      binding: OnboardingControllerBinding(),
    ),
    GetPage(
      name: Routes.PREPARE_PLAN,
      page: () => PreparePlanScreen(),
      binding: PreparePlanControllerBinding(),
    ),
    GetPage(
      name: Routes.ALL_SET,
      page: () => const AllSetScreen(),
      binding: AllSetControllerBinding(),
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => ForgotPasswordScreen(),
      binding: ForgotPasswordControllerBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeScreen(),
      binding: HomeControllerBinding(),
    ),
    GetPage(
      name: Routes.LANDING,
      page: () => LandingScreen(),
      binding: LandingControllerBinding(),
    ),
    GetPage(
      name: Routes.MOOD_CHECKIN,
      page: () => const MoodCheckinScreen(),
      binding: MoodCheckinControllerBinding(),
    ),
    GetPage(
      name: Routes.CHAT_A_I,
      page: () => ChatAIScreen(),
      binding: ChatAIControllerBinding(),
    ),
    GetPage(
      name: Routes.CHAT_EXPERTS,
      page: () => ChatExpertsScreen(),
      binding: ChatExpertsControllerBinding(),
    ),
  ];
}
