import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool hidePassword = true.obs;
}
