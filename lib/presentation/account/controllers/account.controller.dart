import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Mentora/controllers/global.controller.dart';

class AccountController extends GetxController {
  final dailyReminder = false.obs;
  final isDarkMode = false.obs;

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
}
