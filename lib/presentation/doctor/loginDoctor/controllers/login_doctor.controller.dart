import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:Mentora/data/enums/snackbar_enum.dart';
import 'package:Mentora/data/methods/app_method.dart';
import 'package:Mentora/data/utils/app_utils.dart';
import 'package:Mentora/infrastructure/dal/services/doctor_portal_service.dart';
import 'package:Mentora/infrastructure/navigation/routes.dart';

class LoginDoctorController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController =
      TextEditingController(text: 'dr.sarah@mentora.com');
  final TextEditingController passwordController =
      TextEditingController(text: 'DoctorPass#2026');

  final RxBool hidePassword = true.obs;
  final RxBool rememberMe = true.obs;
  final RxBool isLoading = false.obs;

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

  void fillDemoDoctorCredentials() {
    emailController.text = 'dr.sarah@mentora.com';
    passwordController.text = 'DoctorPass#2026';
    AppUtils.snackbar('Demo Credentials Filled', 'Dr. Sarah Jenkins, MD prefilled', SnackBarType.INFO);
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
          await AppMethod.saveDoctorToken(token);
          await AppMethod.saveDoctorEmail(email);
          await AppMethod.saveDoctorInfo(id: 101, name: 'Dr. Sarah Jenkins, MD');

          AppUtils.snackbar(
            'Success',
            'Welcome back to Mentora Doctors Portal',
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
