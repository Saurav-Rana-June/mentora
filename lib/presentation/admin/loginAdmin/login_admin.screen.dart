import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:Mentora/widgets/fields/custom_textfield.widget.dart';
import 'package:Mentora/widgets/others/custom.check.box.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:Mentora/widgets/others/custom.screen.wrapper.dart';

import 'controllers/login_admin.controller.dart';

class LoginAdminScreen extends GetView<LoginAdminController> {
  LoginAdminScreen({super.key});

  @override
  final controller = Get.put(LoginAdminController());

  @override
  Widget build(BuildContext context) {
    return CustomScreenWrapper(safeAreaTop: true, body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s16.symmetric.horizontal,
          vertical: Spacing.s16.symmetric.horizontal,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 480.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildHeader(context),
              Spacing.s24.h,
              buildFormCard(context),
              Spacing.s16.h,
              buildFooterSecurityInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 52.spMin,
              width: 52.spMin,
              child: Image.asset('assets/logos/logo.png', fit: BoxFit.contain),
            ),
            Spacing.s12.w,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mentora CMS',
                  style: h1.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.headlineLarge?.color,
                  ),
                ),
                Text(
                  'Administrative Control Center',
                  style: r14.copyWith(color: theme.textTheme.bodySmall?.color),
                ),
              ],
            ),
          ],
        ),
        Spacing.s12.h,
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s12.symmetric.horizontal,
            vertical: Spacing.s4.symmetric.horizontal,
          ),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: isDark ? 0.15 : 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '\u{f3ed}', // shield icon
                style: TextStyle(
                  fontFamily: 'FontAwesomeSolid',
                  fontSize: 12,
                  color: primary,
                ),
              ),
              Spacing.s8.w,
              Text(
                'PORTAL ADMINISTRATOR ACCESS',
                style: r10.copyWith(
                  fontWeight: FontWeight.w700,
                  color: primary,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildFormCard(BuildContext context) {
    final theme = Theme.of(context);

    return CustomPrimaryCard(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s8.symmetric.horizontal,
          vertical: Spacing.s8.symmetric.horizontal,
        ),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin Sign In',
                style: h2.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.headlineMedium?.color,
                ),
              ),
              Spacing.s4.h,
              Text(
                'Please authenticate with your CMS credentials to manage content and platform operations.',
                style: r14.copyWith(color: theme.textTheme.bodySmall?.color),
              ),
              Spacing.s24.h,
              buildEmailField(context),
              Spacing.s16.h,
              buildPasswordField(context),
              // Spacing.s16.h,
              // buildRememberAndHelpRow(context),
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
          'Email Address',
          style: r14.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        Spacing.s8.h,
        CustomTextFormField(
          controller: controller.emailController,
          hintText: 'admin@mentora.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          fillColor: theme.canvasColor,
          prefixIcon: Container(
            width: 20,
            padding: const EdgeInsets.only(left: 8),
            child: Center(
              child: Text(
                '\u{f0e0}', // envelope icon
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
                  '\u{f023}', // lock icon
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
                  'Remember this session',
                  style: r14.copyWith(color: theme.textTheme.bodyMedium?.color),
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Get.snackbar(
              'Admin Assistance',
              'Please contact the super administrator to reset your CMS credentials.',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          child: Text(
            'Need Help?',
            style: r14.copyWith(color: primary, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget buildSubmitButton(BuildContext context) {
    return Obx(
      () => CustomPrimaryButton(
        text: 'Sign In to Mentora CMS',
        isLoading: controller.isLoading.value,
        onPressed: controller.login,
        backgroundColor: primary,
        prefixIcon: const Text(
          '\u{f2f6}', // sign-in-alt icon
          style: TextStyle(
            fontFamily: 'FontAwesomeSolid',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildFooterSecurityInfo(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '\u{f023}', // lock icon
          style: TextStyle(
            fontFamily: 'FontAwesomeSolid',
            fontSize: 12,
            color: primary,
          ),
        ),
        Spacing.s8.w,
        Text(
          'Protected 256-bit encrypted administrator console',
          style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
        ),
      ],
    );
  }
}
