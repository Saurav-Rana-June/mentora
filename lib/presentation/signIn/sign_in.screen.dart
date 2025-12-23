import 'package:Mentora/infrastructure/navigation/routes.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/screens.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:Mentora/widgets/fields/custom_textfield.widget.dart';
import 'package:Mentora/widgets/others/custom.check.box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:my_spacing/spacing.enum.dart';

import 'controllers/sign_in.controller.dart';

class SignInScreen extends GetView<SignInController> {
  SignInScreen({super.key});

  @override
  final controller = Get.put(SignInController());

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
                "Welcome Back! 👋",
                textAlign: TextAlign.center,
                style: h2.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.headlineMedium!.color,
                ),
              ),
              Text(
                "Sign in to continue your wellness journey",
                textAlign: TextAlign.center,
                style: r14.copyWith(
                  color: Theme.of(context).textTheme.bodySmall!.color,
                ),
              ),
              Spacing.s32.h,

              Text(
                "Email",
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
              Spacing.s16.h,

              Text(
                "Password",
                textAlign: TextAlign.center,
                style: r14.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacing.s8.h,
              Obx(
                () => CustomTextFormField(
                  controller: controller.passwordController,
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
                        controller.hidePassword.value =
                            !controller.hidePassword.value;
                      },
                      padding: EdgeInsets.zero,
                      icon: Text(
                        controller.hidePassword.value
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
                  obscureText: controller.hidePassword.value,
                  fillColor: Theme.of(context).canvasColor,
                  hintText: "Password",
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Title is required";
                    return null;
                  },
                ),
              ),
              Spacing.s16.h,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: CustomCheckBox(
                          value: false,
                          onChanged: (v) {},
                          borderWidth: 1.2,
                          borderColor: primary,
                        ),
                      ),
                      Spacing.s12.w,
                      Text(
                        "Remember Me",
                        textAlign: TextAlign.center,
                        style: r14.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  TextButton(
                    onPressed: () {
                      Get.to(
                        () => ForgotPasswordScreen(),
                        transition: Transition.rightToLeft,
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      "Forgot Password?",
                      textAlign: TextAlign.center,
                      style: r14.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Spacing.s32.h,

              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Theme.of(context).textTheme.bodySmall!.color,
                      height: 0.5,
                      thickness: 1,
                    ),
                  ),
                  Spacing.s8.w,
                  Text(
                    "or Continue with",
                    textAlign: TextAlign.center,
                    style: r14.copyWith(
                      color: Theme.of(context).textTheme.bodySmall!.color,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Spacing.s8.w,
                  Expanded(
                    child: Divider(
                      color: Theme.of(context).textTheme.bodySmall!.color,
                      height: 0.5,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              Spacing.s24.h,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildLoginOptionButton(
                    context,
                    'assets/logos/google.png',
                    20,
                    () {},
                  ),
                  buildLoginOptionButton(
                    context,
                    'assets/logos/apple.png',
                    20,
                    () {},
                  ),
                  buildLoginOptionButton(
                    context,
                    'assets/logos/facebook.png',
                    20,
                    () {},
                  ),
                  buildLoginOptionButton(
                    context,
                    'assets/logos/x.png',
                    15,
                    () {},
                  ),
                ],
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
        text: "Sign up",
        borderRadius: 50.r,
        height: 45,
        backgroundColor: primary,
        disabledColor: primary.withValues(alpha: 0.5),
        isLoading: false,
        textStyle: r16.copyWith(fontWeight: FontWeight.w600, color: white),
        onPressed: () {
          Get.toNamed(Routes.LANDING);
        },
      ),
    );
  }

  Material buildLoginOptionButton(
    BuildContext context,
    String image,
    double size,
    void Function()? onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(50.r),
        onTap: onTap,
        child: Ink(
          height: 45,
          width: 70,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color:
                  Theme.of(
                    context,
                  ).outlinedButtonTheme.style?.side?.resolve({})!.color ??
                  Colors.grey,
            ),
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: Center(
            child: SizedBox(
              height: size,
              width: size,
              child: Image.asset(image, fit: BoxFit.cover),
            ),
          ),
        ),
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
