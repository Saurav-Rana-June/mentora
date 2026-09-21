import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/enums/snackbar_enum.dart';
import 'package:Mentora/data/utils/app_utils.dart';
import 'package:Mentora/infrastructure/dal/services/auth_service.dart';
import 'package:Mentora/infrastructure/environment/environment.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import '../landingAdmin/controllers/landing_admin.controller.dart';

class AdminSettingsView extends StatefulWidget {
  const AdminSettingsView({super.key});

  @override
  State<AdminSettingsView> createState() => _AdminSettingsViewState();
}

class _AdminSettingsViewState extends State<AdminSettingsView> {
  final _landingController = Get.find<LandingAdminController>();

  void _showChangePasswordDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: isDark ? const Color(0xFF1E1F1D) : white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              child: Container(
                width: 440.w,
                padding: EdgeInsets.all(24.w),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Change Admin Password',
                            style: h3.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.textTheme.headlineLarge?.color,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                      Spacing.s16.h,
                      _buildPasswordField(
                        label: 'Current Password',
                        controller: oldPasswordController,
                        hint: 'Enter your current password',
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        isDark: isDark,
                      ),
                      Spacing.s12.h,
                      _buildPasswordField(
                        label: 'New Password',
                        controller: newPasswordController,
                        hint: 'Enter new secure password',
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (v.length < 6) return 'Password must be at least 6 characters';
                          return null;
                        },
                        isDark: isDark,
                      ),
                      Spacing.s12.h,
                      _buildPasswordField(
                        label: 'Confirm New Password',
                        controller: confirmPasswordController,
                        hint: 'Re-enter new password',
                        validator: (v) {
                          if (v != newPasswordController.text) return 'Passwords do not match';
                          return null;
                        },
                        isDark: isDark,
                      ),
                      Spacing.s20.h,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: isSubmitting ? null : () => Get.back(),
                            child: Text('Cancel', style: r14.copyWith(color: theme.textTheme.bodyMedium?.color)),
                          ),
                          Spacing.s12.w,
                          ElevatedButton(
                            onPressed: isSubmitting
                                ? null
                                : () async {
                                    if (!formKey.currentState!.validate()) return;
                                    setStateDialog(() => isSubmitting = true);
                                    try {
                                      final res = await AuthService.adminChangePassword(
                                        oldPassword: oldPasswordController.text.trim(),
                                        newPassword: newPasswordController.text.trim(),
                                      );
                                      if (res != null) {
                                        Get.back();
                                        AppUtils.snackbar(
                                          'Success',
                                          'Password changed successfully',
                                          SnackBarType.SUCCESS,
                                        );
                                      }
                                    } catch (_) {
                                    } finally {
                                      if (mounted) setStateDialog(() => isSubmitting = false);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                              elevation: 0,
                            ),
                            child: isSubmitting
                                ? SizedBox(
                                    width: 18.w,
                                    height: 18.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text('Update Password', style: r14.copyWith(color: white, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required String? Function(String?)? validator,
    required bool isDark,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: r12.copyWith(fontWeight: FontWeight.w600, color: theme.textTheme.bodyMedium?.color),
        ),
        Spacing.s4.h,
        TextFormField(
          controller: controller,
          obscureText: true,
          validator: validator,
          style: r14.copyWith(color: theme.textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: r14.copyWith(color: slate[400]),
            filled: true,
            fillColor: isDark ? const Color(0xFF282926) : const Color(0xFFF9FAF7),
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.1) : slate[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.08) : slate[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final env = ConfigEnvironments.getEnvironments();

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Platform Settings & Diagnostics',
            style: h2.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.textTheme.headlineLarge?.color,
            ),
          ),
          Spacing.s4.h,
          Text(
            'Manage CMS credentials, environment endpoints, and security configuration.',
            style: r14.copyWith(color: theme.textTheme.bodySmall?.color),
          ),
          Spacing.s24.h,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Admin Account Card
              Expanded(
                child: CustomPrimaryCard(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24.r,
                              backgroundColor: primary.withValues(alpha: 0.15),
                              child: Text(
                                '\u{f4fe}',
                                style: TextStyle(
                                  fontFamily: 'FontAwesomeSolid',
                                  fontSize: 18.spMin,
                                  color: primary,
                                ),
                              ),
                            ),
                            Spacing.s12.w,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Admin Account',
                                    style: h3.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  Obx(
                                    () => Text(
                                      _landingController.adminEmail.value,
                                      style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Spacing.s16.h,
                        const Divider(),
                        Spacing.s16.h,
                        _buildSettingRow(
                          title: 'Portal Role',
                          value: 'Super Administrator',
                          badgeColor: primary,
                        ),
                        Spacing.s12.h,
                        _buildSettingRow(
                          title: 'Session Status',
                          value: 'Authenticated (Active)',
                          badgeColor: successColor,
                        ),
                        Spacing.s20.h,
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _showChangePasswordDialog,
                              icon: Icon(Icons.lock_reset_rounded, size: 18.spMin, color: white),
                              label: Text('Change Password', style: r14.copyWith(color: white, fontWeight: FontWeight.w600)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                elevation: 0,
                              ),
                            ),
                            Spacing.s12.w,
                            OutlinedButton.icon(
                              onPressed: _landingController.logout,
                              icon: Icon(Icons.logout_rounded, size: 18.spMin, color: dangerColor),
                              label: Text('Logout', style: r14.copyWith(color: dangerColor, fontWeight: FontWeight.w600)),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: dangerColor.withValues(alpha: 0.5)),
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Spacing.s16.w,
              // Server Environment Card
              Expanded(
                child: CustomPrimaryCard(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(
                                color: infoColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(Icons.cloud_done_rounded, color: infoColor, size: 24.spMin),
                            ),
                            Spacing.s12.w,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Backend Environment', style: h3.copyWith(fontWeight: FontWeight.w700)),
                                Text('REST API Gateway', style: r12.copyWith(color: theme.textTheme.bodySmall?.color)),
                              ],
                            ),
                          ],
                        ),
                        Spacing.s16.h,
                        const Divider(),
                        Spacing.s16.h,
                        _buildSettingRow(
                          title: 'Active Environment',
                          value: (env['env'] ?? 'PROD').toUpperCase(),
                          badgeColor: infoColor,
                        ),
                        Spacing.s12.h,
                        _buildSettingRow(
                          title: 'API Base URL',
                          value: env['url'] ?? '',
                          isMono: true,
                        ),
                        Spacing.s12.h,
                        _buildSettingRow(
                          title: 'Connection Status',
                          value: 'Connected (HTTP 200)',
                          badgeColor: successColor,
                        ),
                        Spacing.s20.h,
                        Text(
                          'Mentora CMS Console v2.0 • Flutter Web / Desktop',
                          style: r10.copyWith(color: isDark ? slate[400] : slate[500]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow({
    required String title,
    required String value,
    Color? badgeColor,
    bool isMono = false,
  }) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: r14.copyWith(color: theme.textTheme.bodyMedium?.color)),
        if (badgeColor != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              value,
              style: r12.copyWith(color: badgeColor, fontWeight: FontWeight.w600),
            ),
          )
        else
          Text(
            value,
            style: isMono
                ? r12.copyWith(fontFamily: 'monospace', fontWeight: FontWeight.w600)
                : r14.copyWith(fontWeight: FontWeight.w600),
          ),
      ],
    );
  }
}
