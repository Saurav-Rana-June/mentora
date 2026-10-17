import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:Mentora/data/enums/snackbar_enum.dart';
import 'package:Mentora/data/methods/app_method.dart';
import 'package:Mentora/data/utils/app_utils.dart';
import 'package:Mentora/infrastructure/dal/services/doctor_portal_service.dart';
import 'package:Mentora/infrastructure/navigation/routes.dart';

class DoctorDemoProfile {
  final int id;
  final String name;
  final String title;
  final String specialty;
  final String email;
  final String password;
  final String avatarUrl;
  final String badgeText;

  const DoctorDemoProfile({
    required this.id,
    required this.name,
    required this.title,
    required this.specialty,
    required this.email,
    required this.password,
    required this.avatarUrl,
    required this.badgeText,
  });
}

class LoginDoctorController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController =
      TextEditingController(text: 'dr.sarah@mentora.com');
  final TextEditingController passwordController =
      TextEditingController(text: 'DoctorPass#2026');

  final RxBool hidePassword = true.obs;
  final RxBool rememberMe = true.obs;
  final RxBool isLoading = false.obs;
  final RxInt selectedDemoIndex = 0.obs;

  final List<DoctorDemoProfile> demoDoctors = const [
    DoctorDemoProfile(
      id: 101,
      name: 'Dr. Sarah Jenkins, MD',
      title: 'Clinical Psychologist',
      specialty: 'CBT & Anxiety Specialist',
      email: 'dr.sarah@mentora.com',
      password: 'DoctorPass#2026',
      avatarUrl:
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=500&auto=format&fit=crop&q=80',
      badgeText: 'Verified Specialist',
    ),
    DoctorDemoProfile(
      id: 102,
      name: 'Dr. Marcus Vance, MD',
      title: 'Senior Neuropsychiatrist',
      specialty: 'Sleep & Mood Disorders',
      email: 'dr.marcus@mentora.com',
      password: 'DoctorPass#2026',
      avatarUrl:
          'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=500&auto=format&fit=crop&q=80',
      badgeText: 'Chief of Psychiatry',
    ),
    DoctorDemoProfile(
      id: 103,
      name: 'Dr. Elena Rostova, PsyD',
      title: 'Behavioral Therapist',
      specialty: 'Trauma & Mindfulness',
      email: 'dr.elena@mentora.com',
      password: 'DoctorPass#2026',
      avatarUrl:
          'https://images.unsplash.com/photo-1594824813689-f54999ab940a?w=500&auto=format&fit=crop&q=80',
      badgeText: 'Senior Clinician',
    ),
  ];

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    hidePassword.value = !hidePassword.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void selectDemoDoctor(int index) {
    if (index < 0 || index >= demoDoctors.length) return;
    selectedDemoIndex.value = index;
    final doc = demoDoctors[index];
    emailController.text = doc.email;
    passwordController.text = doc.password;
    AppUtils.snackbar(
      'Demo Doctor Selected',
      'Loaded credentials for ${doc.name}',
      SnackBarType.INFO,
    );
  }

  void fillDemoDoctorCredentials() {
    selectDemoDoctor(0);
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final response = await DoctorPortalService.doctorLogin(
        email: email,
        password: password,
      );

      if (response != null && response.data != null) {
        final token = response.data!.accessToken ?? '';
        if (token.isNotEmpty) {
          final activeDoc =
              demoDoctors.firstWhereOrNull(
                (d) => d.email.toLowerCase() == email.toLowerCase(),
              ) ??
              demoDoctors.first;

          await AppMethod.clearUserSession();
          await AppMethod.saveDoctorToken(token);
          await AppMethod.saveDoctorEmail(email);
          await AppMethod.saveDoctorInfo(
            id: activeDoc.id,
            name: activeDoc.name,
          );

          AppUtils.snackbar(
            'Success',
            'Welcome back, ${activeDoc.name}',
            SnackBarType.SUCCESS,
          );

          Get.offAllNamed(Routes.LANDING_DOCTOR);
        }
      } else {
        AppUtils.snackbar(
          'Login Failed',
          response?.message ?? 'Invalid doctor credentials.',
          SnackBarType.ERROR,
        );
      }
    } catch (e) {
      Get.log('Doctor login error: $e');
      AppUtils.snackbar(
        'Error',
        'An unexpected error occurred during doctor login.',
        SnackBarType.ERROR,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
