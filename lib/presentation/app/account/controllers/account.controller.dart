import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Mentora/controllers/global.controller.dart';
import 'package:Mentora/infrastructure/dal/services/auth_service.dart';
import 'package:Mentora/data/methods/app_method.dart';
import 'package:Mentora/infrastructure/navigation/routes.dart';

class AccountController extends GetxController {
  final dailyReminder = false.obs;
  final isDarkMode = false.obs;
  final isLoggingOut = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = Get.isDarkMode;

    if (Get.isRegistered<GlobalController>()) {
      final globalController = Get.find<GlobalController>();
      if (globalController.userProfile.value == null &&
          !globalController.isLoadingProfile.value) {
        globalController.fetchUserProfile();
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> logout() async {
    isLoggingOut.value = true;
    try {
      await AuthService.logout();
    } catch (e) {
      Get.log("Logout API error: $e");
    } finally {
      await AppMethod.clearUserSession();
      isLoggingOut.value = false;
      Get.offAllNamed(Routes.SIGN_IN);
    }
  }
}
