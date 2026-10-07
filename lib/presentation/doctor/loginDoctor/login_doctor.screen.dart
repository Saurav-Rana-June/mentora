import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/navigation/routes.dart';
import 'package:Mentora/infrastructure/theme/app_scale.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/doctor/widgets/doctor_badge.widget.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:Mentora/widgets/fields/custom_textfield.widget.dart';
import 'package:Mentora/widgets/others/custom.check.box.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:Mentora/widgets/others/custom.screen.wrapper.dart';
import 'controllers/login_doctor.controller.dart';

class LoginDoctorScreen extends GetView<LoginDoctorController> {
  LoginDoctorScreen({super.key});

  @override
  final controller = Get.put(LoginDoctorController());

  @override
  Widget build(BuildContext context) {
    return CustomScreenWrapper(
      safeAreaTop: true,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppScale.pagePaddingHorizontal(),
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: AppScale.isMobile ? double.infinity : 480,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildHeader(context),
                Spacing.s24.h,
                buildFormCard(context),
                Spacing.s16.h,
                buildQuickDemoCredentials(context),
                Spacing.s16.h,
                buildRegisterDoctorLink(context),
                Spacing.s16.h,
                buildFooterSecurityInfo(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 48,
              width: 48,
              child: Image.asset('assets/logos/logo.png', fit: BoxFit.contain),
            ),
            Spacing.s12.w,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mentora Doctors',
                  style: h1.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.headlineLarge?.color,
                  ),
                ),
                Text(
                  'Clinical Practice & Telehealth Portal',
                  style: r14.copyWith(color: theme.textTheme.bodySmall?.color),
                ),
              ],
            ),
          ],
        ),
        Spacing.s12.h,
        DoctorBadge(
          text: 'DOCTOR & CLINICAL SPECIALIST ACCESS',
          icon: '\u{f0f0}', // user-md
          color: primary,
        ),
      ],
    );
  }

  Widget buildFormCard(BuildContext context) {
    final theme = Theme.of(context);

    return CustomPrimaryCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Doctor Sign In',
                style: h2.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.headlineMedium?.color,
                ),
              ),
              Spacing.s4.h,
              Text(
                'Sign in with your clinical credentials to manage appointments and patient consultations.',
                style: r14.copyWith(color: theme.textTheme.bodySmall?.color),
              ),
              Spacing.s24.h,
              buildEmailField(context),
              Spacing.s16.h,
              buildPasswordField(context),
              Spacing.s16.h,
              buildRememberAndHelpRow(context),
              Spacing.s24.h,
              buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmailField(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Doctor Email Address',
          style: r14.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        Spacing.s8.h,
        CustomTextFormField(
          controller: controller.emailController,
          hintText: 'dr.sarah@mentora.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          fillColor: theme.canvasColor,
          prefixIcon: Container(
            width: 20,
            padding: const EdgeInsets.only(left: 8),
            child: Center(
              child: Text(
                '\u{f0e0}', // envelope
                style: TextStyle(
                  fontFamily: 'FontAwesomeLight',
                  fontSize: 18,
                  color: primary,
                ),
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Email address is required';
            }
            if (!GetUtils.isEmail(value.trim())) {
              return 'Enter a valid email address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget buildPasswordField(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: r14.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        Spacing.s8.h,
        Obx(
          () => CustomTextFormField(
            controller: controller.passwordController,
            hintText: '••••••••••••',
            obscureText: controller.hidePassword.value,
            textInputAction: TextInputAction.done,
            fillColor: theme.canvasColor,
            onFieldSubmitted: (_) => controller.login(),
            prefixIcon: Container(
              width: 20,
              padding: const EdgeInsets.only(left: 8),
              child: Center(
                child: Text(
                  '\u{f023}', // lock
                  style: TextStyle(
                    fontFamily: 'FontAwesomeLight',
                    fontSize: 18,
                    color: primary,
                  ),
                ),
              ),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: IconButton(
                onPressed: controller.togglePasswordVisibility,
                padding: EdgeInsets.zero,
                icon: Text(
                  controller.hidePassword.value ? '\u{f06e}' : '\u{f070}',
                  style: TextStyle(
                    fontFamily: 'FontAwesomeLight',
                    fontSize: 18,
                    color: primary,
                  ),
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Password is required';
              }
              if (value.trim().length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget buildRememberAndHelpRow(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(
          () => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomCheckBox(
                value: controller.rememberMe.value,
                onChanged: (_) => controller.toggleRememberMe(),
                size: 20,
              ),
              Spacing.s8.w,
              GestureDetector(
                onTap: controller.toggleRememberMe,
                child: Text(
                  'Keep me signed in',
                  style: r14.copyWith(color: theme.textTheme.bodyMedium?.color),
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Get.snackbar(
              'Doctor Support',
              'Please contact clinical support at doctors@mentora.com to reset your credentials.',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          child: Text(
            'Forgot Password?',
            style: r14.copyWith(color: primary, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget buildSubmitButton(BuildContext context) {
    return Obx(
      () => CustomPrimaryButton(
        text: 'Sign In to Mentora Doctors',
        isLoading: controller.isLoading.value,
        onPressed: controller.login,
        backgroundColor: primary,
        prefixIcon: const Text(
          '\u{f0f0}', // user-md
          style: TextStyle(
            fontFamily: 'FontAwesomeSolid',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildQuickDemoCredentials(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: controller.fillDemoDoctorCredentials,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: primary.withValues(alpha: isDark ? 0.12 : 0.08),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: primary.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Icon(Icons.flash_on_rounded, color: primary, size: 20),
            Spacing.s8.w,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Demo Doctor Sign-In',
                    style: r12.copyWith(fontWeight: FontWeight.w700, color: primary),
                  ),
                  Text(
                    'Prefills Dr. Sarah Jenkins, MD (Clinical Psychologist)',
                    style: r10.copyWith(color: theme.textTheme.bodySmall?.color),
                  ),
                ],
              ),
            ),
            Text(
              'Fill',
              style: r12.copyWith(fontWeight: FontWeight.w700, color: primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRegisterDoctorLink(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'New specialist on Mentora? ',
              style: r14.copyWith(color: theme.textTheme.bodyMedium?.color),
            ),
            InkWell(
              onTap: () => Get.toNamed(Routes.REGISTER_DOCTOR),
              child: Text(
                'Register as a Doctor',
                style: r14.copyWith(color: primary, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        Spacing.s12.h,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => Get.toNamed(Routes.LOGIN_ADMIN),
              child: Text(
                'Admin CMS Portal',
                style: r12.copyWith(color: slate[500]),
              ),
            ),
            Spacing.s8.w,
            Text('•', style: r12.copyWith(color: slate[400])),
            Spacing.s8.w,
            InkWell(
              onTap: () => Get.toNamed(Routes.SIGN_IN),
              child: Text(
                'Patient Wellness App',
                style: r12.copyWith(color: slate[500]),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildFooterSecurityInfo(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '\u{f3ed}', // shield
          style: TextStyle(
            fontFamily: 'FontAwesomeSolid',
            fontSize: 12,
            color: primary,
          ),
        ),
        Spacing.s8.w,
        Flexible(
          child: Text(
            'HIPAA & GDPR-compliant encrypted clinical practitioner portal',
            style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
