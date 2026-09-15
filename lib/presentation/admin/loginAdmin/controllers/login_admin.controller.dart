import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Mentora/controllers/global.controller.dart';
import 'package:Mentora/data/enums/snackbar_enum.dart';
import 'package:Mentora/data/methods/app_method.dart';
import 'package:Mentora/data/utils/app_utils.dart';
import 'package:Mentora/infrastructure/dal/services/auth_service.dart';

class LoginAdminController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool hidePassword = true.obs;
  final RxBool rememberMe = false.obs;
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

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;

      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final response = await AuthService.adminLogin(
        email: email,
        password: password,
      );

      if (response != null && response.data != null) {
        final token = response.data!.accessToken ?? '';
        if (token.isNotEmpty) {
          await AppMethod.saveUserToken(token);
          await AppMethod.saveUserEmail(email);

          if (Get.isRegistered<GlobalController>()) {
            Get.find<GlobalController>().fetchUserProfile();
          }

          AppUtils.snackbar(
            'Success',
            'Successfully logged into Mentora CMS',
            SnackBarType.SUCCESS,
          );
        }
      } else {
        AppUtils.snackbar(
          'Login Failed',
          response?.message ?? 'Invalid administrator credentials.',
          SnackBarType.ERROR,
        );
      }
    } catch (e) {
      Get.log('Admin login error: $e');
      AppUtils.snackbar(
        'Error',
        'An error occurred during admin login: $e',
        SnackBarType.ERROR,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
