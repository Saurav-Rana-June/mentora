import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/forgotPassword/views/otp.view.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:Mentora/widgets/fields/custom_textfield.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:my_spacing/spacing.enum.dart';

import 'controllers/forgot_password.controller.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  ForgotPasswordScreen({super.key});

  @override
  final controller = Get.put(ForgotPasswordController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(),
      body: Stack(
        alignment: AlignmentGeometry.bottomCenter,
        children: [buildForm(context), buildButton()],
      ),
    );
  }

  SizedBox buildForm(BuildContext context) {
    return SizedBox(
      height: Get.height,
      child: Form(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s8.symmetric.horizontal,
            vertical: Spacing.s4.symmetric.horizontal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Forgot Your Password? 🔑",
                textAlign: TextAlign.center,
                style: h2.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.headlineMedium!.color,
                ),
              ),
              Text(
                "Enter your email address associated with your Mentora account. We'll send your a one-time password (OTP) to reset your password.",
                style: r14.copyWith(
                  color: Theme.of(context).textTheme.bodySmall!.color,
                ),
              ),
              Spacing.s32.h,

              Text(
                "Your Registered Email Address",
                textAlign: TextAlign.center,
                style: r14.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacing.s8.h,
              CustomTextFormField(
                controller: TextEditingController(),
                prefixIcon: Container(
                  width: 20,
                  padding: EdgeInsets.only(left: 8),
                  child: Center(
                    child: Text(
                      "\u{f0e0}", // Change Icon :- envelope
                      style: TextStyle(
                        fontFamily: 'FontAwesomeLight',
                        fontSize: 20,
                        color: primary,
                      ),
                    ),
                  ),
                ),
                fillColor: Theme.of(context).canvasColor,
                hintText: "Email Address",
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Title is required";
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
        vertical: Spacing.s4.symmetric.vertical,
      ),
      child: CustomPrimaryButton(
        text: "Send OTP",
        borderRadius: 50.r,
        height: 45,
        backgroundColor: primary,
        disabledColor: primary.withValues(alpha: 0.5),
        isLoading: false,
        textStyle: r16.copyWith(fontWeight: FontWeight.w600, color: white),
        onPressed: () {
          Get.to(() => OtpView(), transition: Transition.rightToLeft);
        },
      ),
    );
  }

  AppBar buildAppbar() => AppBar(
    title: CustomBackButton(),
    automaticallyImplyLeading: false,
    centerTitle: false,
    surfaceTintColor: Colors.transparent,
  );
}
