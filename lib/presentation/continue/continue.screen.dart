import 'package:Mentora/presentation/signIn/sign_in.screen.dart';
import 'package:Mentora/presentation/signUp/sign_up.screen.dart';
import 'package:Mentora/widgets/buttons/custom_outline_button.widget.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../infrastructure/theme/theme.dart';
import 'controllers/continue.controller.dart';

class ContinueScreen extends GetView<ContinueController> {
  const ContinueScreen({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).scaffoldBackgroundColor,
        statusBarIconBrightness: Get.isDarkMode
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: black,
      ),
    );

    return Scaffold(body: SafeArea(top: false, child: buildBody(context)));
  }

  Padding buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
      ),
      child: SizedBox(
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTopSection(context),
            Spacing.s40.h,
            buildAuthButtons(context),
            Spacing.s40.h,
            buildExtraButtons(context),
          ],
        ),
      ),
    );
  }

  Row buildExtraButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Privacy Policy",
          textAlign: TextAlign.center,
          style: r14.copyWith(
            color: Theme.of(context).textTheme.bodySmall!.color,
          ),
        ),
        Spacing.s12.w,
        Container(
          height: 5,
          width: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(
              context,
            ).textTheme.bodySmall!.color!.withValues(alpha: 0.5),
          ),
        ),
        Spacing.s12.w,
        Text(
          "Terms of Service",
          textAlign: TextAlign.center,
          style: r14.copyWith(
            color: Theme.of(context).textTheme.bodySmall!.color,
          ),
        ),
      ],
    );
  }

  Column buildAuthButtons(BuildContext context) {
    return Column(
      children: [
        CustomOutlineButton(
          label: "Continue  with Google",
          height: 45.h,
          borderRadius: 50.r,
          borderSize: 1.2,
          textColor: Theme.of(context).textTheme.bodyLarge!.color,
          buttonIcon: SizedBox(
            width: 25.w,
            height: 25.h,
            child: Image.asset('assets/logos/google.png'),
          ),
          borderColor:
              Theme.of(
                context,
              ).textTheme.bodySmall?.color?.withValues(alpha: 0.25) ??
              Colors.black,
          onTap: () {},
        ),
        Spacing.s16.h,
        CustomOutlineButton(
          label: "Continue  with Apple",
          height: 45.h,
          borderRadius: 50.r,
          borderSize: 1.2,
          textColor: Theme.of(context).textTheme.bodyLarge!.color,
          buttonIcon: SizedBox(
            width: 25.w,
            height: 25.h,
            child: Image.asset('assets/logos/apple.png'),
          ),
          borderColor:
              Theme.of(
                context,
              ).textTheme.bodySmall?.color?.withValues(alpha: 0.25) ??
              Colors.black,
          onTap: () {},
        ),
        Spacing.s16.h,
        CustomOutlineButton(
          label: "Continue  with Facebook",
          height: 45.h,
          borderRadius: 50.r,
          borderSize: 1.2,
          textColor: Theme.of(context).textTheme.bodyLarge!.color,
          buttonIcon: SizedBox(
            width: 25.w,
            height: 25.h,
            child: Image.asset('assets/logos/facebook.png', fit: BoxFit.cover),
          ),
          borderColor:
              Theme.of(
                context,
              ).textTheme.bodySmall?.color?.withValues(alpha: 0.25) ??
              Colors.black,
          onTap: () {},
        ),
        Spacing.s16.h,
        CustomOutlineButton(
          label: "Continue  with X",
          height: 45.h,
          borderRadius: 50.r,
          borderSize: 1.2,
          textColor: Theme.of(context).textTheme.bodyLarge!.color,
          buttonIcon: SizedBox(
            width: 16.w,
            height: 16.h,
            child: Image.asset('assets/logos/x.png', fit: BoxFit.cover),
          ),
          borderColor:
              Theme.of(
                context,
              ).textTheme.bodySmall?.color?.withValues(alpha: 0.25) ??
              Colors.black,
          onTap: () {},
        ),
        Spacing.s40.h,

        CustomPrimaryButton(
          text: "Sign up",
          borderRadius: 50.r,
          height: 45.h,
          backgroundColor: primary,
          disabledColor: primary.withValues(alpha: 0.5),
          isLoading: false,
          textStyle: r16.copyWith(fontWeight: FontWeight.w600, color: white),
          onPressed: () {
            Get.to(() => SignUpScreen(), transition: Transition.rightToLeft);
          },
        ),
        Spacing.s8.h,

        CustomPrimaryButton(
          text: "Sign in",
          borderRadius: 50.r,
          height: 45.h,
          backgroundColor: primary.withValues(alpha: 0.25),
          disabledColor: secondary.withValues(alpha: 0.5),
          isLoading: false,
          textStyle: r16.copyWith(fontWeight: FontWeight.w600, color: primary),
          onPressed: () {
            Get.to(() => SignInScreen(), transition: Transition.rightToLeft);
          },
        ),
      ],
    );
  }

  Column buildTopSection(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 60.spMin,
          width: 60.spMin,
          child: Image.asset('assets/logos/logo.png', fit: BoxFit.fill),
        ),
        Spacing.s12.h,
        Text(
          "Let's Get Started!",
          textAlign: TextAlign.center,
          style: h3.copyWith(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).textTheme.headlineMedium!.color,
          ),
        ),

        Text(
          "Let's dive into your account",
          textAlign: TextAlign.center,
          style: r14.copyWith(
            color: Theme.of(context).textTheme.bodySmall!.color,
          ),
        ),
      ],
    );
  }
}
