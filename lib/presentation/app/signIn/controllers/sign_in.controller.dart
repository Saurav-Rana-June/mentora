import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:Mentora/data/methods/app_method.dart';
import 'package:Mentora/data/enums/snackbar_enum.dart';
import 'package:Mentora/data/utils/app_utils.dart';
import 'package:Mentora/infrastructure/dal/services/auth_service.dart';
import 'package:Mentora/infrastructure/navigation/routes.dart';

import 'package:Mentora/controllers/global.controller.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final hidePassword = true.obs;
  final isLoading = false.obs;



  Future<void> signIn() async {
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

    isLoading.value = true;
    try {
      final response = await AuthService.login(email: email, password: password);
      if (response != null && response.data != null) {
        final tokenData = response.data!;
        await AppMethod.saveUserToken(tokenData.accessToken ?? '');
        await AppMethod.saveUserEmail(email);

        if (Get.isRegistered<GlobalController>()) {
          Get.find<GlobalController>().fetchUserProfile();
        }

        AppUtils.snackbar(
          'Success',
          'Login successful!',
          SnackBarType.SUCCESS,
        );
        Get.offAllNamed(Routes.LANDING);
      }
    } catch (e) {
      // Errors and snackbars are handled globally by ApiClient.
      print('Sign In Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
