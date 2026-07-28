import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../data/methods/app_method.dart';
import '../../../../infrastructure/dal/services/auth_service.dart';
import '../../../../infrastructure/navigation/routes.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final hidePassword = true.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> signIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Email and password cannot be empty.',
        backgroundColor: const Color(0xFFF44336),
        colorText: const Color(0xffffffff),
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Validation Error',
        'Please enter a valid email address.',
        backgroundColor: const Color(0xFFF44336),
        colorText: const Color(0xffffffff),
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await AuthService.login(email: email, password: password);
      if (response != null && response.data != null) {
        final tokenData = response.data!;
        await AppMethod.saveUserToken(tokenData.accessToken);
        await AppMethod.saveUserEmail(email);

        Get.snackbar(
          'Success',
          'Login successful!',
          backgroundColor: const Color(0xFF4CAF50),
          colorText: const Color(0xffffffff),
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
