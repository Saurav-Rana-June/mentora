import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/home/controllers/home.controller.dart';
import 'package:Mentora/data/model/assessment/daily_mood_assessment.model.dart';
import 'package:Mentora/data/utils/app_utils.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';

class MoodHistoryView extends StatelessWidget {
  const MoodHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeController = Get.find<HomeController>();

    return Obx(() {
      if (homeController.moodHistoryList.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(Spacing.s24.symmetric.horizontal),
            child: Container(
              padding: EdgeInsets.all(Spacing.s24.symmetric.horizontal),
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
                border: Border.all(color: slate[100]!),
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
                      child: Text("🌱", style: TextStyle(fontSize: 32.sp)),
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
          vertical: Spacing.s16.symmetric.horizontal,
        ),
        itemCount: sortedHistory.length,
        itemBuilder: (context, index) {
          final checkIn = sortedHistory[index];
          final feelingName = checkIn.feeling ?? 'Normal';
          final moodColor = AppUtils.getMoodColor(feelingName);

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
                        margin: EdgeInsets.only(top: 18.h),
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
                              color: moodColor.withValues(alpha: 0.35),
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
                                color: slate[200]!.withValues(alpha: 0.6),
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
                      borderRadius: 20,
                      padding: EdgeInsets.all(Spacing.s16.symmetric.horizontal),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    homeController.moodImage(feelingName),
                                    width: 32.h,
                                    height: 32.h,
                                  ),
                                  Spacing.s12.w,
                                  Text(
                                    feelingName,
                                    style: r16.copyWith(
                                      color: theme.textTheme.bodyLarge!.color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                _formatDate(checkIn.createdAt),
                                style: r12.copyWith(
                                  color: theme.textTheme.bodySmall!.color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          if ((checkIn.exactFeeling != null &&
                                  checkIn.exactFeeling!.isNotEmpty) ||
                              (checkIn.why != null &&
                                  checkIn.why!.isNotEmpty)) ...[
                            Spacing.s12.h,
                            Wrap(
                              spacing: 6.w,
                              runSpacing: 6.h,
                              children: [
                                if (checkIn.exactFeeling != null)
                                  ...checkIn.exactFeeling!.map(
                                    (feeling) => _buildChip(
                                      feeling,
                                      moodColor.withValues(alpha: 0.1),
                                      moodColor,
                                    ),
                                  ),
                                if (checkIn.why != null)
                                  ...checkIn.why!.map(
                                    (reason) => _buildChip(
                                      reason,
                                      theme.primaryColorLight,
                                      theme.textTheme.bodyMedium!.color!,
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
                              padding: EdgeInsets.all(
                                Spacing.s12.symmetric.horizontal,
                              ),
                              decoration: BoxDecoration(
                                color: theme.primaryColorLight.withValues(
                                  alpha: 0.4,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border(
                                  left: BorderSide(
                                    color: moodColor.withValues(alpha: 0.8),
                                    width: 3.w,
                                  ),
                                ),
                              ),
                              child: Text(
                                checkIn.notes!,
                                style: r14.copyWith(
                                  color: theme.textTheme.bodyMedium!.color,
                                  height: 1.4,
                                ),
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
    });
  }

  Widget _buildChip(String label, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Satoshi',
          fontSize: 12.sp,
          color: textColor,
          fontWeight: FontWeight.bold,
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
