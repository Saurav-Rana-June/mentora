import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/home/controllers/home.controller.dart';
import 'package:Mentora/data/model/assessment/daily_mood_assessment.model.dart';
import 'package:Mentora/data/utils/app_utils.dart';
import 'package:Mentora/data/enums/date_filter_enum.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:Mentora/widgets/others/custom.horizontal.scrollable.filter.widget.dart';
import 'package:my_icons/icons.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';

class MoodHistoryView extends StatelessWidget {
  const MoodHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeController = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: theme.primaryColorLight,
      appBar: AppBar(
        title: Text(
          "Mood History",
          style: r18.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge!.color,
          ),
        ),
        leading: const Center(
          child: CustomBackButton(icon: MyIcons.chevronLeft),
        ),
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: theme.primaryColorLight,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Chips Section
            Obx(() => _buildFilterChips(context, homeController)),
            // Content Section (List or Empty state)
            Expanded(
              child: Obx(() {
                if (homeController.moodHistoryList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(Spacing.s24.symmetric.horizontal),
                      child: Container(
                        padding: EdgeInsets.all(
                          Spacing.s24.symmetric.horizontal,
                        ),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: Border.all(
                            color: theme.brightness == Brightness.dark
                                ? slate[800]!
                                : slate[100]!,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 72.h,
                              height: 72.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    primary.withValues(alpha: 0.2),
                                    primary.withValues(alpha: 0.05),
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  "🌱",
                                  style: TextStyle(fontSize: 32.sp),
                                ),
                              ),
                            ),
                            Spacing.s24.h,
                            Text(
                              "No check-ins logged yet",
                              textAlign: TextAlign.center,
                              style: r18.copyWith(
                                color: theme.textTheme.bodyLarge!.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacing.s8.h,
                            Text(
                              "Log how you feel today and track your progress metrics over time.",
                              textAlign: TextAlign.center,
                              style: r14.copyWith(
                                color: theme.textTheme.bodySmall!.color,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                // Sort history: latest first
                final sortedHistory = List<DailyMoodAssessmentModel>.from(
                  homeController.moodHistoryList,
                );
                sortedHistory.sort((a, b) {
                  final aDate = a.createdAt != null
                      ? DateTime.tryParse(a.createdAt!)
                      : null;
                  final bDate = b.createdAt != null
                      ? DateTime.tryParse(b.createdAt!)
                      : null;
                  if (aDate == null) return 1;
                  if (bDate == null) return -1;
                  return bDate.compareTo(aDate);
                });

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: Spacing.s8.symmetric.horizontal,
                    vertical: Spacing.s8.symmetric.horizontal,
                  ),
                  itemCount: sortedHistory.length,
                  itemBuilder: (context, index) {
                    final checkIn = sortedHistory[index];
                    final feelingName = checkIn.feeling ?? 'Normal';
                    final moodColor = AppUtils.getMoodColor(feelingName);
                    final moodIcon = homeController.moodImage(feelingName);
                    final dateStr = _formatDate(checkIn.createdAt);
                    final isDarkMode = theme.brightness == Brightness.dark;

                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Journal Timeline Node
                          SizedBox(
                            width: 24.w,
                            child: Column(
                              children: [
                                Container(
                                  width: 12.h,
                                  height: 12.h,
                                  decoration: BoxDecoration(
                                    color: moodColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: theme.scaffoldBackgroundColor,
                                      width: 2.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: moodColor.withValues(
                                          alpha: 0.35,
                                        ),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: index == sortedHistory.length - 1
                                      ? const SizedBox()
                                      : Container(
                                          width: 2.w,
                                          color: slate[200]!.withValues(
                                            alpha: 0.6,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          Spacing.s12.w,
                          // Check-in card body
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 20.h),
                              child: CustomPrimaryCard(
                                borderRadius: 8,
                                padding: EdgeInsets.all(16.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        if (moodIcon.isNotEmpty)
                                          Container(
                                            padding: EdgeInsets.all(8.w),
                                            decoration: BoxDecoration(
                                              color: moodColor.withValues(
                                                alpha: 0.12,
                                              ),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "CHECK-IN",
                                                    style: r10.copyWith(
                                                      color: theme
                                                          .textTheme
                                                          .bodySmall!
                                                          .color,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      letterSpacing: 1.0,
                                                    ),
                                                  ),
                                                  if (dateStr.isNotEmpty) ...[
                                                    Spacing.s8.w,
                                                    Container(
                                                      width: 4.w,
                                                      height: 4.w,
                                                      decoration: BoxDecoration(
                                                        color: theme
                                                            .textTheme
                                                            .bodySmall!
                                                            .color!
                                                            .withValues(
                                                              alpha: 0.5,
                                                            ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    Spacing.s8.w,
                                                    Text(
                                                      dateStr,
                                                      style: r10.copyWith(
                                                        color: theme
                                                            .textTheme
                                                            .bodySmall!
                                                            .color,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                              Spacing.s4.h,
                                              Text(
                                                "You feel $feelingName",
                                                style: r16.copyWith(
                                                  color: theme
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if ((checkIn.exactFeeling?.isNotEmpty ??
                                            false) ||
                                        (checkIn.why?.isNotEmpty ?? false)) ...[
                                      Spacing.s12.h,
                                      Divider(
                                        color: isDarkMode
                                            ? slate[700]!
                                            : slate[100]!,
                                        height: 1,
                                      ),
                                      Spacing.s12.h,
                                      Wrap(
                                        spacing: 8.w,
                                        runSpacing: 8.h,
                                        children: [
                                          ...(checkIn.exactFeeling ?? []).map(
                                            (e) => _buildMoodTag(
                                              context,
                                              e,
                                              moodColor,
                                            ),
                                          ),
                                          ...(checkIn.why ?? []).map(
                                            (w) => _buildMoodTag(
                                              context,
                                              w,
                                              primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    if (checkIn.notes != null &&
                                        checkIn.notes!.trim().isNotEmpty) ...[
                                      Spacing.s12.h,
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 10.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: theme.primaryColorLight,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(16.r),
                                            bottomLeft: Radius.circular(16.r),
                                            bottomRight: Radius.circular(16.r),
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 2.h,
                                              ),
                                              child: Text(
                                                '\u{f10d}',
                                                style: TextStyle(
                                                  fontFamily:
                                                      'FontAwesomeSolid',
                                                  fontSize: 9.sp,
                                                  color: theme
                                                      .textTheme
                                                      .bodySmall!
                                                      .color!
                                                      .withValues(alpha: 0.6),
                                                ),
                                              ),
                                            ),
                                            Spacing.s8.w,
                                            Expanded(
                                              child: Text(
                                                checkIn.notes!,
                                                style: r12.copyWith(
                                                  color: theme
                                                      .textTheme
                                                      .bodyMedium!
                                                      .color,
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
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, HomeController controller) {
    return CustomHorizontalScrollableFilter<DateFilter>(
      items: DateFilter.values,
      selectedItem: controller.selectedDateFilter.value,
      labelBuilder: (filter) => filter.value,
      onItemSelected: (filter) => controller.changeDateFilter(filter),
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s16.symmetric.horizontal,
        vertical: Spacing.s8.symmetric.horizontal,
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

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    final date = DateTime.tryParse(dateStr)?.toLocal();
    if (date == null) return '';
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }
}
