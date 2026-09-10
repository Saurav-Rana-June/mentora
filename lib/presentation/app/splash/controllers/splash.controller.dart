import 'dart:async';
import 'package:get/get.dart';
import 'package:Mentora/data/methods/app_method.dart';
import 'package:Mentora/infrastructure/dal/services/auth_service.dart';
import 'package:Mentora/infrastructure/navigation/routes.dart';
import 'package:Mentora/controllers/global.controller.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final stopwatch = Stopwatch()..start();
    final token = AppMethod.getUserToken();
    bool isAuthenticated = false;

    if (token != null && token.isNotEmpty) {
      try {
        final response = await AuthService.autoSignIn();
        if (response != null && response.data != null) {
          await AppMethod.saveUserEmail(response.data!.email ?? '');
          isAuthenticated = true;
        } else {
          await AppMethod.clearUserSession();
        }
      } catch (e) {
        Get.log('Auto Sign In Error: $e');
        await AppMethod.clearUserSession();
      }
    }

    // Keep splash visible for at least 3 seconds for visual brand consistency
    final elapsedMs = stopwatch.elapsedMilliseconds;
    const minimumSplashDurationMs = 3000;
    if (elapsedMs < minimumSplashDurationMs) {
      await Future.delayed(
        Duration(milliseconds: minimumSplashDurationMs - elapsedMs),
      );
    }

    if (isAuthenticated) {
      if (Get.isRegistered<GlobalController>()) {
        Get.find<GlobalController>().fetchUserProfile();
      }
      Get.offAllNamed(Routes.LANDING);
    } else {
      if (AppMethod.hasSeenIntroduction()) {
        Get.offAllNamed(Routes.SIGN_IN);
      } else {
        Get.offAllNamed(Routes.INTRODUCTION);
      }
    }
  }
}
