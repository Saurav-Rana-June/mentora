import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/continue/continue.screen.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:Mentora/widgets/fields/custom_textfield.widget.dart';
import 'package:Mentora/widgets/others/custom.primary.appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:my_spacing/spacing.enum.dart';

import '../controllers/forgot_password.controller.dart';

class PasswordResetView extends StatelessWidget {
  PasswordResetView({super.key});

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
                "Secure your account",
                textAlign: TextAlign.center,
                style: h2.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.headlineMedium!.color,
                ),
              ),
              Text(
                "Enter your new password for your Mentora account below. Make sure it's secure and easy to remember",
                textAlign: TextAlign.center,
                style: r14.copyWith(
                  color: Theme.of(context).textTheme.bodySmall!.color,
                ),
              ),
              Spacing.s32.h,

              Text(
                "New Password",
                textAlign: TextAlign.center,
                style: r14.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacing.s8.h,
              Obx(
                () => CustomTextFormField(
                  controller: controller.newPasword,
                  prefixIcon: Container(
                    width: 20,
                    padding: EdgeInsets.only(left: 8),
                    child: Center(
                      child: Text(
                        "\u{f023}", // Change Icon :- lock
                        style: TextStyle(
                          fontFamily: 'FontAwesomeLight',
                          fontSize: 20,
                          color: primary,
                        ),
                      ),
                    ),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: IconButton(
                      onPressed: () {
                        controller.hideNewPassword.value =
                            !controller.hideNewPassword.value;
                      },
                      padding: EdgeInsets.zero,
                      icon: Text(
                        controller.hideNewPassword.value
                            ? "\u{f06e}"
                            : "\u{f070}", // Change Icon :- eye, eye-slash
                        style: TextStyle(
                          fontFamily: 'FontAwesomeLight',
                          fontSize: 20,
                          color: primary,
                        ),
                      ),
                    ),
                  ),
                  obscureText: controller.hideNewPassword.value,
                  fillColor: Theme.of(context).canvasColor,
                  hintText: "Password",
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    return null;
                  },
                ),
              ),
              Spacing.s16.h,

              Text(
                "Confirm New Password",
                textAlign: TextAlign.center,
                style: r14.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacing.s8.h,
              Obx(
                () => CustomTextFormField(
                  controller: controller.confirmNewPassword,
                  prefixIcon: Container(
                    width: 20,
                    padding: EdgeInsets.only(left: 8),
                    child: Center(
                      child: Text(
                        "\u{f023}", // Change Icon :- lock
                        style: TextStyle(
                          fontFamily: 'FontAwesomeLight',
                          fontSize: 20,
                          color: primary,
                        ),
                      ),
                    ),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: IconButton(
                      onPressed: () {
                        controller.hideConfirmNewPassword.value =
                            !controller.hideConfirmNewPassword.value;
                      },
                      padding: EdgeInsets.zero,
                      icon: Text(
                        controller.hideConfirmNewPassword.value
                            ? "\u{f06e}"
                            : "\u{f070}", // Change Icon :- eye, eye-slash
                        style: TextStyle(
                          fontFamily: 'FontAwesomeLight',
                          fontSize: 20,
                          color: primary,
                        ),
                      ),
                    ),
                  ),
                  obscureText: controller.hideConfirmNewPassword.value,
                  fillColor: Theme.of(context).canvasColor,
                  hintText: "Password",
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    return null;
                  },
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
        text: "Reset New Password",
        borderRadius: 50.r,
        height: 45,
        backgroundColor: primary,
        disabledColor: primary.withValues(alpha: 0.5),
        isLoading: false,
        textStyle: r16.copyWith(fontWeight: FontWeight.w600, color: white),
        onPressed: () {
          Get.offAll(
            () => ContinueScreen(),
            transition: Transition.leftToRight,
          );
        },
      ),
    );
  }

  PreferredSizeWidget buildAppbar() => const CustomPrimaryAppBar(
    leading: Center(child: CustomBackButton()),
    automaticallyImplyLeading: false,
    centerTitle: false,
  );
}
