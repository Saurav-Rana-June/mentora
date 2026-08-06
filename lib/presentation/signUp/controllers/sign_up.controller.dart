import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../data/methods/app_method.dart';
import '../../../../data/enums/snackbar_enum.dart';
import '../../../../data/utils/app_utils.dart';
import '../../../../infrastructure/dal/services/auth_service.dart';
import '../../../../infrastructure/navigation/routes.dart';

import 'package:Mentora/controllers/global.controller.dart';

class SignUpController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final hidePassword = true.obs;
  final isLoading = false.obs;



  Future<void> signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      AppUtils.snackbar(
        'Validation Error',
        'Email and password cannot be empty.',
        SnackBarType.ERROR,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      AppUtils.snackbar(
        'Validation Error',
        'Please enter a valid email address.',
        SnackBarType.ERROR,
      );
      return;
    }

    if (password.length < 6) {
      AppUtils.snackbar(
        'Validation Error',
        'Password must be at least 6 characters long.',
        SnackBarType.ERROR,
      );
      return;
    }

    isLoading.value = true;
    try {
      // 1. Call registration endpoint
      final regResponse = await AuthService.register(
        email: email,
        password: password,
      );
      if (regResponse != null && regResponse.status == 201) {
        // 2. Automatically log the user in to retrieve JWT access token
        final loginResponse = await AuthService.login(
          email: email,
          password: password,
        );
        if (loginResponse != null && loginResponse.data != null) {
          final tokenData = loginResponse.data!;
          await AppMethod.saveUserToken(tokenData.accessToken ?? '');
          await AppMethod.saveUserEmail(email);

          if (Get.isRegistered<GlobalController>()) {
            Get.find<GlobalController>().fetchUserProfile();
          }

          AppUtils.snackbar(
            'Success',
            'Account created and signed in successfully!',
            SnackBarType.SUCCESS,
          );
          Get.offAllNamed(Routes.ONBOARDING);
        } else {
          // Fallback to manual sign in if auto login failed
          AppUtils.snackbar(
            'Success',
            'Account created successfully! Please sign in.',
            SnackBarType.SUCCESS,
          );
          Get.offAllNamed(Routes.SIGN_IN);
        }
      }
    } catch (e) {
      // ApiClient request handles snackbars automatically
      print('Sign Up Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
