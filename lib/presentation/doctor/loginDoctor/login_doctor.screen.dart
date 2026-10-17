import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/navigation/routes.dart';
import 'package:Mentora/infrastructure/theme/app_scale.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
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
              maxWidth: AppScale.isMobile ? double.infinity : 440,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildHeader(context),
                Spacing.s24.h,
                buildFormCard(context),
                Spacing.s20.h,
                buildRegisterLink(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Mentora Doctors Logo & Header ---
  Widget buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(
          height: 64,
          width: 64,
          child: Image.asset('assets/logos/logo.png', fit: BoxFit.contain),
        ),
        Spacing.s16.h,
        Text(
          'Mentora Doctors',
          textAlign: TextAlign.center,
          style: h1.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.textTheme.headlineLarge?.color,
          ),
        ),
        Spacing.s4.h,
        Text(
          'Clinical Practice & Telehealth Portal',
          textAlign: TextAlign.center,
          style: r14.copyWith(color: theme.textTheme.bodySmall?.color),
        ),
      ],
    );
  }

  // --- Login Form Card ---
  Widget buildFormCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomPrimaryCard(
      child: Padding(
        padding: const EdgeInsets.all(22),
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
                'Sign in with your clinical credentials',
                style: r14.copyWith(color: theme.textTheme.bodySmall?.color),
              ),
              Spacing.s20.h,
              buildEmailField(context, isDark),
              Spacing.s16.h,
              buildPasswordField(context, isDark),
              Spacing.s16.h,
              buildRememberAndHelpRow(context),
              Spacing.s20.h,
              buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Email Input Field ---
  Widget buildEmailField(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Doctor Email',
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
          fillColor: isDark ? const Color(0xFF282A24) : const Color(0xFFF9FAF7),
          borderColor: isDark ? slate[700] : slate[200],
          borderWidth: 1,
          focusedBorderColor: primary,
          prefixIcon: Icon(
            Icons.mail_outline_rounded,
            color: primary,
            size: 20,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Email is required';
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

  // --- Password Input Field ---
  Widget buildPasswordField(BuildContext context, bool isDark) {
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
            fillColor: isDark
                ? const Color(0xFF282A24)
                : const Color(0xFFF9FAF7),
            borderColor: isDark ? slate[700] : slate[200],
            borderWidth: 1,
            focusedBorderColor: primary,
            onFieldSubmitted: (_) => controller.login(),
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              color: primary,
              size: 20,
            ),
            suffixIcon: IconButton(
              onPressed: controller.togglePasswordVisibility,
              icon: Icon(
                controller.hidePassword.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: primary,
                size: 20,
              ),
              tooltip: controller.hidePassword.value ? 'Show' : 'Hide',
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

  // --- Remember Me & Forgot Password Row ---
  Widget buildRememberAndHelpRow(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Obx(
            () => InkWell(
              onTap: controller.toggleRememberMe,
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomCheckBox(
                      value: controller.rememberMe.value,
                      onChanged: (_) => controller.toggleRememberMe(),
                      size: 18,
                    ),
                    Spacing.s8.w,
                    Flexible(
                      child: Text(
                        'Keep me signed in',
                        overflow: TextOverflow.ellipsis,
                        style: r14.copyWith(
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Get.snackbar(
              'Doctor Support',
              'Please contact clinical support at doctors@mentora.com to reset credentials.',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: Text(
              'Forgot Password?',
              style: r14.copyWith(color: primary, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  // --- Submit Primary Button ---
  Widget buildSubmitButton() {
    return Obx(
      () => CustomPrimaryButton(
        text: 'Sign In to Portal',
        isLoading: controller.isLoading.value,
        onPressed: controller.login,
        backgroundColor: primary,
        height: 48,
        prefixIcon: const Icon(
          Icons.health_and_safety_rounded,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  // --- Register as Doctor Link ---
  Widget buildRegisterLink(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'New specialist on Mentora? ',
          style: r14.copyWith(color: theme.textTheme.bodyMedium?.color),
        ),
        InkWell(
          onTap: () => Get.toNamed(Routes.REGISTER_DOCTOR),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              'Register as a Doctor',
              style: r14.copyWith(color: primary, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}
