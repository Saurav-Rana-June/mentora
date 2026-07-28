import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../data/methods/app_method.dart';
import '../../../../infrastructure/dal/services/auth_service.dart';
import '../../../../infrastructure/navigation/routes.dart';

class SignUpController extends GetxController {
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

  Future<void> signUp() async {
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

    if (password.length < 6) {
      Get.snackbar(
        'Validation Error',
        'Password must be at least 6 characters long.',
        backgroundColor: const Color(0xFFF44336),
        colorText: const Color(0xffffffff),
      );
      return;
    }

    isLoading.value = true;
    try {
      // 1. Call registration endpoint
      final regResponse = await AuthService.register(email: email, password: password);
      if (regResponse != null && regResponse.status == 201) {
        // 2. Automatically log the user in to retrieve JWT access token
        final loginResponse = await AuthService.login(email: email, password: password);
        if (loginResponse != null && loginResponse.data != null) {
          final tokenData = loginResponse.data!;
          await AppMethod.saveUserToken(tokenData.accessToken);
          await AppMethod.saveUserEmail(email);

          Get.snackbar(
            'Success',
            'Account created and signed in successfully!',
            backgroundColor: const Color(0xFF4CAF50),
            colorText: const Color(0xffffffff),
          );
          Get.offAllNamed(Routes.ONBOARDING);
        } else {
          // Fallback to manual sign in if auto login failed
          Get.snackbar(
            'Success',
            'Account created successfully! Please sign in.',
            backgroundColor: const Color(0xFF4CAF50),
            colorText: const Color(0xffffffff),
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
