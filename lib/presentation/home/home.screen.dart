import 'package:Mentora/controllers/bottom.nav.controller.dart';
import 'package:Mentora/controllers/global.controller.dart';
import 'package:Mentora/data/utils/app_utils.dart';
import 'package:Mentora/infrastructure/navigation/routes.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/screens.dart';
import 'package:Mentora/widgets/others/custom.avatar.dart';
import 'package:Mentora/data/model/daily_mood_assessment.model.dart';
import 'package:Mentora/widgets/others/custom.dashed.line.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:Mentora/widgets/charts/custom.line.chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';

import 'controllers/home.controller.dart';
import 'package:Mentora/presentation/widgets/loaders/loader.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});

  @override
  final controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: buildAppbar(context),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          controller.fetchStreakStats(forceRefresh: true),
          controller.fetchDailyPlan(forceRefresh: true),
          controller.globalController.fetchMoodHistory(forceRefresh: true),
        ]);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s8.symmetric.horizontal,
          vertical: Spacing.s4.symmetric.horizontal,
        ),
        child: Column(
          children: [
            buildTopBanner(),
            Spacing.s16.h,
            buildStreakAndProgressRow(context),
            Spacing.s16.h,
            Obx(() {
              if (controller.globalController.todayCheckIn.value == null) {
                return buildMoodCheckinSection(context);
              } else {
                return buildMoodCheckedInCard(
                  context,
                  controller.globalController.todayCheckIn.value!,
                );
              }
            }),
            Spacing.s16.h,
            // buildConnectSection(context),
            // Spacing.s16.h,
            buildMoodTrendsCard(context),
            Spacing.s16.h,
            Obx(
              () => controller.plans.isNotEmpty
                  ? buildTodayPlanSection(context)
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStreakAndProgressRow(BuildContext context) {
    return Obx(() {
      final streak = controller.streakCount.value;
      final weeklyCount = controller.weeklyCheckInCount.value;
      return Row(
        children: [
          buildStatusCard(
            context: context,
            icon: '\u{f06d}', // fire icon
            iconColor: Colors.orange.shade800,
            iconBgColor: primary.withValues(alpha: 0.15),
            title: streak > 0 ? "$streak Days" : "0 Days",
            subtitle: "Active Streak 🔥",
          ),
          Spacing.s16.w,
          buildStatusCard(
            context: context,
            icon: '\u{f073}', // calendar icon
            iconColor: infoColor.withValues(alpha: 0.9),
            iconBgColor: primary.withValues(alpha: 0.15),
            title: "$weeklyCount / 7 Days",
            subtitle: "Weekly Progress",
          ),
        ],
      );
    });
  }

  Widget buildStatusCard({
    required BuildContext context,
    required String icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
  }) {
    return Expanded(
      child: CustomPrimaryCard(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                icon,
                style: TextStyle(
                  fontFamily: 'FontAwesomeSolid',
                  fontSize: 16.sp,
                  color: iconColor,
                ),
              ),
            ),
            Spacing.s12.w,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: r14.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: r10.copyWith(
                      color: Theme.of(context).textTheme.bodySmall!.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMoodTrendsCard(BuildContext context) {
    final globalController = Get.find<GlobalController>();

    return Obx(() {
      final stats = globalController.moodTrackerStats.value;
      final checkedInMoods =
          stats?.data?.map((d) => d.feeling).whereType<String>().toList() ?? [];
      final historyLength = checkedInMoods.length;

      return GestureDetector(
        onTap: () {
          if (Get.isRegistered<BottamNavController>()) {
            Get.find<BottamNavController>().changeTabIndex(4);
          }
        },
        child: CustomPrimaryCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mood Trends",
                        style: r18.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacing.s4.h,
                      Text(
                        "This Week (resets weekly)",
                        style: r12.copyWith(
                          color: Theme.of(
                            context,
                          ).textTheme.bodySmall!.color!.withValues(alpha: 0.65),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "View",
                        style: r12.copyWith(
                          color: primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacing.s8.w,
                      Text(
                        '\u{f054}', // angle-right
                        style: TextStyle(
                          fontFamily: 'FontAwesomeSolid',
                          fontSize: 10.sp,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacing.s12.h,
              if (historyLength < 2)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: slate[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text("🌟", style: TextStyle(fontSize: 24.sp)),
                      Spacing.s8.h,
                      Text(
                        "Check in a few more days to see your\ntrends",
                        textAlign: TextAlign.center,
                        style: r12.copyWith(
                          color: Theme.of(context).textTheme.bodySmall!.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              else
                SizedBox(
                  height: 100.h,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: CustomLineChart(
                      checkInMoods: checkedInMoods,
                      primaryColor: primary,
                      textColor:
                          Theme.of(context).textTheme.bodySmall!.color ??
                          slate[500]!,
                      padding: 12.0,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildTodayPlanSection(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingPlans.value) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your plan for today",
              style: r18.copyWith(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacing.s12.h,
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: const Loader(),
              ),
            ),
          ],
        );
      }

      final total = controller.plans.length;
      final completed = controller.plans.where((p) => p.isComplete).length;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your plan for today ($completed/$total)",
            textAlign: TextAlign.center,
            style: r18.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacing.s12.h,

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: total,
            itemBuilder: (context, index) {
              final plan = controller.plans[index];
              return buildTodayPlanTimelineTile(
                context,
                plan.uiTitle,
                plan.label,
                plan.uiCaption,
                plan.uiIcon,
                index == 0 ? true : false,
                index + 1 == total ? true : false,
                plan.isComplete,
                () {
                  controller.togglePlanCompletion(index);
                },
              );
            },
          ),
        ],
      );
    });
  }

  IntrinsicHeight buildTodayPlanTimelineTile(
    BuildContext context,
    String title,
    String label,
    String caption,
    String icon,
    bool isFirst,
    bool isLast,
    bool isComplete,
    Function()? onTap,
  ) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              CustomDashedLine(
                color: isFirst ? Colors.transparent : primary,
                width: 1.2,
              ),
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primary, width: 1.2),
                ),
                child: isComplete
                    ? Center(
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primary,
                          ),
                        ),
                      )
                    : SizedBox(),
              ),
              CustomDashedLine(
                color: isLast ? Colors.transparent : primary,
                width: 1.2,
              ),
            ],
          ),
          Spacing.s12.w,
          Expanded(
            child: Column(
              children: [
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: onTap,
                    child: CustomPrimaryCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title.toUpperCase(),
                                  style: r12.copyWith(
                                    color: primary,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                Spacing.s8.h,
                                Text(
                                  label,
                                  style: r16.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge!.color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Spacing.s4.h,
                                Text(
                                  caption,
                                  textAlign: TextAlign.center,
                                  style: r14.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodySmall!.color,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            icon,
                            style: TextStyle(
                              fontFamily: 'FontAwesomeSolid',
                              fontSize: 30.sp,
                              color: primary.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Spacing.s16.h,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildConnectSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: Get.width / 2.3,
          child: buildConnectTile(context, '\u{f544}', 'Chat with Mentora', () {
            Get.to(() => ChatAIScreen(), transition: Transition.rightToLeft);
          }), // Change Icon :- robot
        ),

        SizedBox(
          width: Get.width / 2.3,
          child: buildConnectTile(context, '\u{f0f0}', 'Talk with Experts', () {
            Get.to(
              () => ChatExpertsScreen(),
              transition: Transition.rightToLeft,
            );
          }), // Change Icon :- user-doctor
        ),
      ],
    );
  }

  Widget buildConnectTile(
    BuildContext context,
    String icon,
    String label,
    Function()? onTap,
  ) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: primary.withValues(alpha: .2),
        highlightColor: primary.withValues(alpha: .1),
        onTap: onTap,
        child: CustomPrimaryCard(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  icon,
                  style: TextStyle(
                    fontFamily: 'FontAwesomeSolid',
                    fontSize: 16.sp,
                    color: primary,
                  ),
                ),
              ),
              Spacing.s8.w,
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: r14.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMoodCheckinSection(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Get.toNamed(Routes.MOOD_CHECKIN);
      },
      child: CustomPrimaryCard(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "How do you feel today?",
                  textAlign: TextAlign.center,
                  style: r18.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Spacing.s12.h,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  "assets/moods/Angry Face.svg",
                  width: 45,
                  height: 45,
                ),
                SvgPicture.asset(
                  "assets/moods/Not Good Face.svg",
                  width: 45,
                  height: 45,
                ),
                SvgPicture.asset(
                  "assets/moods/Normal Face.svg",
                  width: 45,
                  height: 45,
                ),
                SvgPicture.asset(
                  "assets/moods/Happy Face.svg",
                  width: 45,
                  height: 45,
                ),
                SvgPicture.asset(
                  "assets/moods/Very Happy Face.svg",
                  width: 45,
                  height: 45,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static const Map<String, String> _moodReasonsEmojiMap = {
    // Factors
    'Work': '💼',
    'School': '🎓',
    'Family': '👨‍👩‍👧‍👦',
    'Partner': '💑',
    'Health': '🏥',
    'Friends': '🧑‍🤝‍🧑',
    'Weather': '🌦️',
    'Hobbies': '🎨',
    'Finances': '💰',
    'Events': '🎉',
    'Exercise': '🏋️‍♂️',
    'Travel': '✈️',
    'Nature': '🌳',
    'Sleep': '😴',
    'Stress': '😣',
    'Time Pressure': '⏰',
    'Deadlines': '📚',
    'Money Worries': '💸',
    'Relationship': '💔',
    'Illness': '🤒',
    'Overthinking': '📱',
    'Traffic': '🚦',
    'Mental Load': '🧠',
    // Exact feelings
    'Happy': '😄',
    'Calm': '😊',
    'Relaxed': '😌',
    'Excited': '😁',
    'Content': '🥰',
    'Grateful': '🙏',
    'Stressed': '😣',
    'Anxious': '😰',
    'Overwhelmed': '😓',
    'Frustrated': '😤',
    'Angry': '😠',
    'Sad': '😔',
    'Disappointed': '😞',
    'Lonely': '🥺',
    'Hurt': '😢',
    'Tired': '😴',
    'Exhausted': '🥱',
    'Numb': '😐',
    'Mentally Drained': '🤯',
    'Motivated': '💪',
    'Focused': '🧠',
    'Inspired': '✨',
  };

  Color _getMoodColor(String feeling) {
    switch (feeling) {
      case 'Angry':
        return const Color(0xFFF34538);
      case 'Not Good':
        return const Color(0xFFFF991C);
      case 'Normal':
        return const Color(0xFF939393);
      case 'Good':
        return const Color(0xFF8DC255);
      case 'Very Good':
        return const Color(0xFF49AF58);
      default:
        return const Color(0xFFA5C67C); // brand primary
    }
  }

  String _formatTime(String createdAt) {
    try {
      final dateTime = DateTime.parse(createdAt).toLocal();
      final hour = dateTime.hour > 12
          ? dateTime.hour - 12
          : (dateTime.hour == 0 ? 12 : dateTime.hour);
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = dateTime.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    } catch (_) {
      return '';
    }
  }

  Widget _buildMoodTag(BuildContext context, String label, Color tintColor) {
    final emoji = _moodReasonsEmojiMap[label] ?? '';
    final displayLabel = emoji.isNotEmpty ? '$emoji $label' : label;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: isDarkMode
            ? tintColor.withValues(alpha: 0.12)
            : tintColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: tintColor.withValues(alpha: 0.2), width: 1),
      ),
      child: Text(
        displayLabel,
        style: r12.copyWith(
          color: isDarkMode
              ? tintColor.withValues(alpha: 0.9)
              : tintColor.withValues(alpha: 0.8),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildMoodCheckedInCard(
    BuildContext context,
    DailyMoodAssessmentModel checkIn,
  ) {
    final mood = checkIn.feeling ?? '';
    final moodIcon = AppUtils.getMoodImage(mood);
    final moodColor = _getMoodColor(mood);
    final timeStr = _formatTime(checkIn.createdAt ?? '');
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Get.toNamed(Routes.MOOD_CHECKIN, arguments: checkIn);
      },
      child: CustomPrimaryCard(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (moodIcon.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: moodColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      moodIcon,
                      width: 38.w,
                      height: 38.w,
                    ),
                  ),
                Spacing.s12.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "TODAY'S CHECK-IN",
                            style: r10.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall!.color,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                          if (timeStr.isNotEmpty) ...[
                            Spacing.s8.w,
                            Container(
                              width: 4.w,
                              height: 4.w,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .color!
                                    .withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Spacing.s8.w,
                            Text(
                              timeStr,
                              style: r10.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall!.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                      Spacing.s4.h,
                      Text(
                        "You feel $mood",
                        style: r16.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if ((checkIn.exactFeeling?.isNotEmpty ?? false) ||
                (checkIn.why?.isNotEmpty ?? false)) ...[
              Spacing.s12.h,
              Divider(color: isDarkMode ? slate[700]! : slate[100]!, height: 1),
              Spacing.s12.h,
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  ...(checkIn.exactFeeling ?? []).map(
                    (e) => _buildMoodTag(context, e, moodColor),
                  ),
                  ...(checkIn.why ?? []).map(
                    (w) => _buildMoodTag(context, w, primary),
                  ),
                ],
              ),
            ],
            if (checkIn.notes != null && checkIn.notes!.isNotEmpty) ...[
              Spacing.s12.h,
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16.r),
                    bottomLeft: Radius.circular(16.r),
                    bottomRight: Radius.circular(16.r),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Text(
                        '\u{f10d}', // Open Quote icon in FontAwesomeSolid
                        style: TextStyle(
                          fontFamily: 'FontAwesomeSolid',
                          fontSize: 9.sp,
                          color: Theme.of(
                            context,
                          ).textTheme.bodySmall!.color!.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    Spacing.s8.w,
                    Expanded(
                      child: Text(
                        checkIn.notes!,
                        style: r12.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildTopBanner() {
    return Container(
      width: Get.width,
      height: Get.height / 4.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage("assets/images/banner.png"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColorLight,
      surfaceTintColor: Colors.transparent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: 25,
                width: 25,
                child: Image.asset('assets/logos/logo.png', fit: BoxFit.fill),
              ),
              Spacing.s12.w,
              Text(
                "Mentora",
                textAlign: TextAlign.center,
                style: h2.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          Row(
            children: [
              Text(
                MyIcons.magnifyingGlass,
                style: TextStyle(
                  fontFamily: 'FontAwesomeLight',
                  fontSize: 20,
                  color: slate[500],
                ),
              ),
              Spacing.s12.w,
              Obx(() {
                final globalController = Get.find<GlobalController>();
                final profile = globalController.userProfile.value;
                return GestureDetector(
                  onTap: () => Get.to(
                    () => AccountScreen(),
                    transition: Transition.rightToLeft,
                  ),
                  child: CustomAvatar(
                    radius: 14.r,
                    imageUrl: profile?.profilePictureUrl,
                    name: profile?.name,
                  ),
                );
              }),
            ],
          ),
        ],
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }
}
