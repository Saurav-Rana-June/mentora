import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Mentora/data/methods/app_method.dart';
import 'package:Mentora/data/model/expert.model.dart';
import 'package:Mentora/infrastructure/dal/services/doctor_portal_service.dart';
import 'package:Mentora/infrastructure/navigation/routes.dart';

class DoctorMenuItem {
  final String title;
  final String icon;
  final int? badgeCount;

  const DoctorMenuItem({
    required this.title,
    required this.icon,
    this.badgeCount,
  });
}

class LandingDoctorController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final RxInt selectedMenuIndex = 0.obs;
  final RxBool isSidebarCollapsed = false.obs;
  final RxString doctorEmail = 'dr.sarah@mentora.com'.obs;
  final RxString doctorName = 'Dr. Sarah Jenkins, MD'.obs;
  final RxString doctorSpeciality = 'Clinical Psychologist'.obs;
  final Rx<Expert?> doctorProfile = Rx<Expert?>(null);

  final List<DoctorMenuItem> menuItems = const [
    DoctorMenuItem(title: 'Clinical Dashboard', icon: '\u{f0e4}'),
    DoctorMenuItem(title: 'Appointments', icon: '\u{f073}'),
    DoctorMenuItem(title: 'My Patients', icon: '\u{f0c0}'),
    DoctorMenuItem(title: 'Schedule & Availability', icon: '\u{f017}'),
    DoctorMenuItem(title: 'Profile & Settings', icon: '\u{f4fe}'),
  ];

  @override
  void onInit() {
    super.onInit();
    loadDoctorInfo();
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

  void changeMenuIndex(int index) {
    selectedMenuIndex.value = index;
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
      await AppMethod.clearDoctorSession();
      Get.offAllNamed(Routes.LOGIN_DOCTOR);
    }
  }
}
