import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/forgotPassword/controllers/forgot_password.controller.dart';
import 'package:Mentora/presentation/forgotPassword/views/password_reset.view.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:my_spacing/spacing.enum.dart';
import 'package:pinput/pinput.dart';

class OtpView extends StatelessWidget {
  OtpView({super.key});

  final controller = Get.find<ForgotPasswordController>();

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
                "Enter OTP Code? 🔐",
                textAlign: TextAlign.center,
                style: h2.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.headlineMedium!.color,
                ),
              ),
              Text(
                "Check your email inbox for a message from Mentora. Enter the one-time password (OTP) tou received below to continue reseting your password.    ",
                style: r14.copyWith(
                  color: Theme.of(context).textTheme.bodySmall!.color,
                ),
              ),
              Spacing.s32.h,

              Pinput(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                length: 6,
                controller: controller.pinPutController,
                focusNode: controller.pinPutFocusNode,
                keyboardType: TextInputType.number,
                // listenForMultipleSmsOnAndroid: true,
                // androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required field';
                  }
                  return null;
                },
                onCompleted: (value) {
                  Get.to(
                    () => PasswordResetView(),
                    transition: Transition.rightToLeft,
                  );
                },
                errorText: "Please enter OTP",
                errorTextStyle: r14.copyWith(color: dangerColor),
                defaultPinTheme: PinTheme(
                  height: 50,
                  textStyle: const TextStyle(fontSize: 22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).inputDecorationTheme.fillColor,
                  ),
                ),
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
        text: "Verify OTP",
        borderRadius: 50.r,
        height: 45,
        backgroundColor: primary,
        disabledColor: primary.withValues(alpha: 0.5),
        isLoading: false,
        textStyle: r16.copyWith(fontWeight: FontWeight.w600, color: white),
        onPressed: () {
          Get.to(() => PasswordResetView(), transition: Transition.rightToLeft);
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
