import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Mentora/data/enums/snackbar_enum.dart';
import 'package:Mentora/data/methods/app_method.dart';
import 'package:Mentora/data/utils/app_utils.dart';
import 'package:Mentora/infrastructure/dal/services/auth_service.dart';
import 'package:Mentora/infrastructure/navigation/routes.dart';

class AdminMenuItem {
  final String title;
  final String icon;
  final String category;

  const AdminMenuItem({
    required this.title,
    required this.icon,
    required this.category,
  });
}

class LandingAdminController extends GetxController {
  final RxInt selectedMenuIndex = 0.obs;
  final RxBool isSidebarCollapsed = false.obs;
  final RxBool isLoggingOut = false.obs;
  final RxString adminEmail = ''.obs;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final List<AdminMenuItem> menuItems = const [
    AdminMenuItem(
      title: 'Dashboard Overview',
      icon: '\u{f0e4}', // tachometer-alt
      category: 'Overview',
    ),
    AdminMenuItem(
      title: 'Guided Meditations',
      icon: '\u{f4b8}', // spa
      category: 'Content',
    ),
    AdminMenuItem(
      title: 'Sleep & Ambient Sounds',
      icon: '\u{f186}', // moon
      category: 'Content',
    ),
    AdminMenuItem(
      title: 'Breathing Exercises',
      icon: '\u{f72e}', // wind
      category: 'Content',
    ),
    AdminMenuItem(
      title: 'Journaling Prompts',
      icon: '\u{f518}', // book-open
      category: 'Content',
    ),
    AdminMenuItem(
      title: 'Video Sessions',
      icon: '\u{f03d}', // video
      category: 'Content',
    ),
    AdminMenuItem(
      title: 'Doctors & Experts',
      icon: '\u{f0f0}', // user-md
      category: 'Management',
    ),
    AdminMenuItem(
      title: 'Activity Plans',
      icon: '\u{f0ae}', // tasks
      category: 'Management',
    ),
    AdminMenuItem(
      title: 'Platform Settings',
      icon: '\u{f013}', // cogs
      category: 'System',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    adminEmail.value = AppMethod.getUserEmail() ?? 'admin@mentora.com';
  }

  void changeMenuIndex(int index) {
    if (index >= 0 && index < menuItems.length) {
      selectedMenuIndex.value = index;
    }
  }

  void toggleSidebar() {
    isSidebarCollapsed.value = !isSidebarCollapsed.value;
  }

  Future<void> logout() async {
    try {
      isLoggingOut.value = true;
      await AuthService.adminLogout();
      await AppMethod.clearUserSession();

      AppUtils.snackbar(
        'Logged Out',
        'You have been logged out of Mentora CMS.',
        SnackBarType.INFO,
      );

      Get.offAllNamed(Routes.LOGIN_ADMIN);
    } catch (e) {
      Get.log('Admin logout error: $e');
      await AppMethod.clearUserSession();
      Get.offAllNamed(Routes.LOGIN_ADMIN);
    } finally {
      isLoggingOut.value = false;
    }
  }
}
