import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:Mentora/widgets/others/custom.switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';

import 'controllers/account.controller.dart';
import 'package:Mentora/controllers/global.controller.dart';
import 'package:Mentora/presentation/widgets/loaders/loader.dart';
import 'views/edit_account.dart';

class AccountScreen extends GetView<AccountController> {
  AccountScreen({super.key});

  @override
  final controller = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorLight,
        appBar: buildAppbar(context),
        body: SizedBox(
          width: Get.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.s16.value,
              vertical: Spacing.s16.value,
            ),
            child: Column(
              children: [
                buildUpgradeBanner(context),
                Spacing.s16.h,

                Obx(() => buildProfileDetailsSection(context)),
                Spacing.s16.h,

                // Preferences & Badges
                CustomPrimaryCard(
                  padding: EdgeInsets.symmetric(
                    vertical: Spacing.s8.value,
                    horizontal: Spacing.s8.value,
                  ),
                  child: Column(
                    children: [
                      buildOptionRow(
                        context,
                        '\u{f336}', // badge-check
                        "My Badges",
                        onTap: () {},
                      ),
                      Divider(
                        height: 1,
                        indent: 40.w,
                        endIndent: 8.w,
                        color: isDark ? slate[700]! : slate[100]!,
                      ),
                      buildOptionRow(
                        context,
                        '\u{f017}', // clock
                        "Daily Reminder",
                        trailing: Obx(
                          () => CustomSwitch(
                            value: controller.dailyReminder.value,
                            onChanged: (val) =>
                                controller.dailyReminder.value = val,
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                        indent: 40.w,
                        endIndent: 8.w,
                        color: isDark ? slate[700]! : slate[100]!,
                      ),
                      buildOptionRow(
                        context,
                        '\u{f013}', // gear
                        "Preferences",
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                Spacing.s16.h,

                // App & Security Settings
                CustomPrimaryCard(
                  padding: EdgeInsets.symmetric(
                    vertical: Spacing.s8.value,
                    horizontal: Spacing.s8.value,
                  ),
                  child: Column(
                    children: [
                      buildOptionRow(
                        context,
                        '\u{f2f7}', // shield-check
                        "Account & Security",
                        onTap: () {},
                      ),
                      Divider(
                        height: 1,
                        indent: 40.w,
                        endIndent: 8.w,
                        color: isDark ? slate[700]! : slate[100]!,
                      ),
                      buildOptionRow(
                        context,
                        '\u{f0c1}', // link
                        "Linked Accounts",
                        onTap: () {},
                      ),
                      Divider(
                        height: 1,
                        indent: 40.w,
                        endIndent: 8.w,
                        color: isDark ? slate[700]! : slate[100]!,
                      ),
                      buildOptionRow(
                        context,
                        '\u{f186}', // moon (Dark Mode)
                        "Dark Mode",
                        trailing: Obx(
                          () => CustomSwitch(
                            value: controller.isDarkMode.value,
                            onChanged: (val) => controller.toggleTheme(val),
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                        indent: 40.w,
                        endIndent: 8.w,
                        color: isDark ? slate[700]! : slate[100]!,
                      ),
                      buildOptionRow(
                        context,
                        '\u{f1fe}', // chart-area
                        "Data & Analytics",
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                Spacing.s16.h,

                // Payments & Billing
                CustomPrimaryCard(
                  padding: EdgeInsets.symmetric(
                    vertical: Spacing.s8.value,
                    horizontal: Spacing.s8.value,
                  ),
                  child: Column(
                    children: [
                      buildOptionRow(
                        context,
                        '\u{f09d}', // credit-card
                        "Payment Methods",
                        onTap: () {},
                      ),
                      Divider(
                        height: 1,
                        indent: 40.w,
                        endIndent: 8.w,
                        color: isDark ? slate[700]! : slate[100]!,
                      ),
                      buildOptionRow(
                        context,
                        '\u{f005}', // star
                        "Billing and Subscription",
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                Spacing.s16.h,

                // Support & Actions
                CustomPrimaryCard(
                  padding: EdgeInsets.symmetric(
                    vertical: Spacing.s8.value,
                    horizontal: Spacing.s8.value,
                  ),
                  child: Column(
                    children: [
                      buildOptionRow(
                        context,
                        '\u{f059}', // question-circle
                        "Help & Support",
                        onTap: () {},
                      ),
                      Divider(
                        height: 1,
                        indent: 40.w,
                        endIndent: 8.w,
                        color: isDark ? slate[700]! : slate[100]!,
                      ),
                      buildOptionRow(
                        context,
                        '\u{f05a}', // info-circle
                        "About Mentora",
                        onTap: () {},
                      ),
                      Divider(
                        height: 1,
                        indent: 40.w,
                        endIndent: 8.w,
                        color: isDark ? slate[700]! : slate[100]!,
                      ),
                      buildOptionRow(
                        context,
                        '\u{f2f5}', // sign-out
                        "Log Out",
                        color: dangerColor,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUpgradeBanner(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          colors: [primary, primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.2),
            offset: const Offset(0, 4),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16.r),
          splashColor: white.withValues(alpha: 0.15),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.s16.value,
              vertical: Spacing.s16.value,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '\u{f521}', // Crown icon
                    style: TextStyle(
                      fontFamily: 'FontAwesomeSolid',
                      fontSize: 22.sp,
                      color: white,
                    ),
                  ),
                ),
                Spacing.s16.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Upgrade Plan Now!",
                        style: r16.copyWith(
                          color: white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacing.s4.h,
                      Text(
                        "Enjoy all the benefits and explore more possibilities",
                        style: r12.copyWith(
                          color: white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacing.s8.w,
                Text(
                  '\u{f054}', // chevron-right
                  style: TextStyle(
                    fontFamily: 'FontAwesomeLight',
                    fontSize: 16.sp,
                    color: white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CustomPrimaryCard buildProfileDetailsSection(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final globalController = Get.find<GlobalController>();
    final profile = globalController.userProfile.value;

    if (globalController.isLoadingProfile.value) {
      return CustomPrimaryCard(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: const Center(child: Loader(strokeWidth: 2.5)),
      );
    }

    final String name = profile?.name ?? "John Doe";
    final String email = profile?.email ?? "johndoe@example.com";
    final String? profilePictureUrl = profile?.profilePictureUrl;

    return CustomPrimaryCard(
      padding: EdgeInsets.all(Spacing.s16.value),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primary, width: 2),
            ),
            child: CircleAvatar(
              radius: 28.r,
              backgroundImage:
                  profilePictureUrl != null && profilePictureUrl.isNotEmpty
                  ? NetworkImage(profilePictureUrl)
                  : const NetworkImage(
                          "https://austinfilm.s3.us-east-2.amazonaws.com/wp-content/uploads/2019/07/29115643/john-doe-jim-herrington-cropped-1024x675.jpg",
                        )
                        as ImageProvider,
            ),
          ),
          Spacing.s16.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: r18.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacing.s8.h,
                Text(
                  email,
                  style: r12.copyWith(
                    color: Theme.of(context).textTheme.bodySmall!.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacing.s8.h,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    "PRO MEMBER",
                    style: r10.copyWith(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacing.s8.w,
          Material(
            color: isDark ? slate[800]! : slate[100]!,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Get.to(
                () => const EditAccountScreen(),
                transition: Transition.rightToLeft,
              ),
              child: Padding(
                padding: EdgeInsets.all(10.r),
                child: Text(
                  '\u{f304}', // Pen/Edit icon
                  style: TextStyle(
                    fontFamily: 'FontAwesomeSolid',
                    fontSize: 14.sp,
                    color: primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionRow(
    BuildContext context,
    String icon,
    String label, {
    Widget? trailing,
    Color? color,
    VoidCallback? onTap,
  }) {
    final Color itemColor = color ?? primary;
    final Color textColor =
        color ?? Theme.of(context).textTheme.bodyLarge!.color!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Spacing.s12.value,
            horizontal: Spacing.s8.value,
          ),
          child: Row(
            children: [
              Container(
                width: 32.w,
                alignment: Alignment.centerLeft,
                child: Text(
                  icon,
                  style: TextStyle(
                    fontFamily: 'FontAwesomeRegular',
                    fontSize: 18.sp,
                    color: itemColor,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  label,
                  style: r14.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Spacing.s8.w,
              trailing ??
                  Text(
                    '\u{f054}', // chevron-right
                    style: TextStyle(
                      fontFamily: 'FontAwesomeLight',
                      fontSize: 14.sp,
                      color: Theme.of(context).textTheme.bodySmall!.color,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColorLight,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: const Center(child: CustomBackButton(icon: MyIcons.chevronLeft)),
      title: Text(
        "Account",
        style: h2.copyWith(
          color: Theme.of(context).textTheme.bodyLarge!.color,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: Spacing.s8.value),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              splashColor: primary.withValues(alpha: 0.3),
              onTap: () {},
              child: SizedBox(
                height: 36.h,
                width: 36.h,
                child: Center(
                  child: Text(
                    '\u{f142}', // ellipsis-vertical
                    style: TextStyle(
                      fontFamily: 'FontAwesomeLight',
                      fontSize: 20,
                      color: slate[500],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
      automaticallyImplyLeading: false,
    );
  }
}
