import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  FocusNode pinPutFocusNode = FocusNode();
  TextEditingController pinPutController = TextEditingController();
  TextEditingController newPasword = TextEditingController();
  TextEditingController confirmNewPassword = TextEditingController();

  RxBool hideNewPassword = true.obs;
  RxBool hideConfirmNewPassword = true.obs;
}
