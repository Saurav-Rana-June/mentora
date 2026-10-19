import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:Mentora/data/enums/snackbar_enum.dart';
import 'package:Mentora/data/methods/app_method.dart';
import 'package:Mentora/data/model/expert.model.dart';
import 'package:Mentora/data/utils/app_utils.dart';
import 'package:Mentora/data/utils/storage_utils.dart';
import 'package:Mentora/infrastructure/dal/services/doctor_portal_service.dart';
import 'package:Mentora/infrastructure/navigation/routes.dart';

class DoctorMenuItem {
  final String title;
  final String icon;
  final String category;

  const DoctorMenuItem({
    required this.title,
    required this.icon,
    required this.category,
  });
}

class LandingDoctorController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final RxInt selectedMenuIndex = 0.obs;
  final RxBool isSidebarCollapsed = false.obs;
  final RxBool isLoggingOut = false.obs;
  final RxBool isDarkMode = false.obs;

  final RxString doctorEmail = ''.obs;
  final RxString doctorName = ''.obs;
  final RxString doctorSpeciality = ''.obs;
  final Rx<Expert?> doctorProfile = Rx<Expert?>(null);

  final List<DoctorMenuItem> menuItems = const [
    DoctorMenuItem(
      title: 'Clinical Dashboard',
      icon: '\u{f0e4}', // tachometer-alt
      category: 'Overview',
    ),
    DoctorMenuItem(
      title: 'Appointments',
      icon: '\u{f073}', // calendar-alt
      category: 'Clinical',
    ),
    DoctorMenuItem(
      title: 'My Patients',
      icon: '\u{f0c0}', // users
      category: 'Clinical',
    ),
    DoctorMenuItem(
      title: 'Schedule & Availability',
      icon: '\u{f017}', // clock
      category: 'Practice',
    ),
    DoctorMenuItem(
      title: 'Profile & Settings',
      icon: '\u{f4fe}', // user-shield
      category: 'Practice',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    loadDoctorInfo();
    final savedTheme = StorageUtils.read<String>(StorageKeys.THEME_MODE);
    if (savedTheme != null) {
      isDarkMode.value = savedTheme == 'dark';
    } else {
      isDarkMode.value = Get.isDarkMode;
    }
  }

  Future<void> loadDoctorInfo() async {
    final email = AppMethod.getDoctorEmail();
    if (email != null && email.isNotEmpty) {
      doctorEmail.value = email;
    }
    final name = AppMethod.getDoctorName();
    if (name != null && name.isNotEmpty) {
      doctorName.value = name;
    }

    final profile = await DoctorPortalService.getCurrentDoctorProfile();
    doctorProfile.value = profile;
    if (profile.name != null) doctorName.value = profile.name!;
    if (profile.speciality != null) doctorSpeciality.value = profile.speciality!;
  }

  void toggleThemeMode() {
    final bool newDark = !Get.isDarkMode;
    isDarkMode.value = newDark;
    Get.changeThemeMode(newDark ? ThemeMode.dark : ThemeMode.light);
    StorageUtils.write(StorageKeys.THEME_MODE, newDark ? 'dark' : 'light');
  }

  void changeMenuIndex(int index) {
    if (index >= 0 && index < menuItems.length) {
      selectedMenuIndex.value = index;
    }
  }

  void toggleSidebar() {
    isSidebarCollapsed.value = !isSidebarCollapsed.value;
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  Future<void> logout() async {
    final shouldLogout = await showDialog<bool>(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out of Mentora Doctors?'),
        content: const Text(
          'Are you sure you want to log out of your clinical practitioner session?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      try {
        isLoggingOut.value = true;
        await AppMethod.clearDoctorSession();
        AppUtils.snackbar(
          'Logged Out',
          'You have been logged out of Mentora Doctors.',
          SnackBarType.INFO,
        );
        Get.offAllNamed(Routes.LOGIN_DOCTOR);
      } finally {
        isLoggingOut.value = false;
      }
    }
  }
}
