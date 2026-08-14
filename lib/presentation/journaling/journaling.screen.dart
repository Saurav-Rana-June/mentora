import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';
import 'package:Mentora/data/model/journal_entry.model.dart';
import 'controllers/journaling.controller.dart';
import 'views/journal_question_detail.screen.dart';
import 'widgets/journaling_content_loading.dart';

class JournalingScreen extends GetView<JournalingController> {
  JournalingScreen({super.key});

  @override
  final controller = Get.put(JournalingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: buildAppbar(context),
      body: buildBody(context),
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColorLight,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: Center(child: CustomBackButton(icon: MyIcons.chevronLeft)),
      title: Text(
        "Journaling",
        style: h2.copyWith(
          color: Theme.of(context).textTheme.bodyLarge!.color,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Obx(() {
          return IconButton(
            icon: Text(
              controller.isSearching.value
                  ? MyIcons.xmark
                  : MyIcons.magnifyingGlass,
              style: TextStyle(
                fontFamily: 'FontAwesomeLight',
                fontSize: 20,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            onPressed: () {
              if (controller.isSearching.value) {
                controller.searchText.value = '';
                controller.isSearching.value = false;
              } else {
                controller.isSearching.value = true;
              }
            },
          );
        }),
        Spacing.s12.w,
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s8.symmetric.horizontal,
            vertical: Spacing.s8.symmetric.vertical,
          ),
          child: const JournalingContentLoading(),
        );
      }

      final list = controller.filteredEntries;
      return RefreshIndicator(
        onRefresh: () => Future.wait([
          controller.fetchQuestions(forceRefresh: true),
          controller.fetchEntries(forceRefresh: true),
        ]),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s8.symmetric.horizontal,
            vertical: Spacing.s8.symmetric.vertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!controller.isSearching.value) ...[
                buildTodayQuestionCard(context),
                Spacing.s16.h,
              ],
              if (list.isEmpty)
                buildEmptyState(context)
              else ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return buildEntryCard(context, list[index]);
                  },
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget buildTodayQuestionCard(BuildContext context) {
    return CustomPrimaryCard(
      padding: EdgeInsets.all(Spacing.s16.value.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's question",
                style: r12.copyWith(
                  color: slate[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
              InkWell(
                onTap: () => controller.rotateTodayQuestion(),
                borderRadius: BorderRadius.circular(12.r),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    MyIcons.rotateRight,
                    style: TextStyle(
                      fontFamily: 'FontAwesomeLight',
                      fontSize: 18,
                      color: primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Spacing.s8.h,
          Obx(() {
            return Text(
              controller.todayQuestion.value,
              style: r18.copyWith(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            );
          }),
          Spacing.s16.h,
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 140.w,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                ),
                onPressed: () {
                  Get.to(
                    () => JournalQuestionDetailScreen(
                      question: controller.todayQuestion.value,
                    ),
                    transition: Transition.rightToLeft,
                  );
                },
                child: Text(
                  "Answer",
                  style: r14.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEntryCard(BuildContext context, JournalEntryModel entry) {
    return Container(
      margin: EdgeInsets.only(bottom: Spacing.s12.value.h),
      child: CustomPrimaryCard(
        padding: EdgeInsets.all(Spacing.s16.value.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    entry.question,
                    style: r16.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ),
                Spacing.s8.w,
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: const Text(
                    '\u{f142}', // ellipsis-vertical in FontAwesome
                    style: TextStyle(
                      fontFamily: 'FontAwesomeLight',
                      fontSize: 16,
                    ),
                  ),
                  color: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      Get.to(
                        () => JournalQuestionDetailScreen(
                          question: entry.question,
                          existingEntry: entry,
                        ),
                        transition: Transition.rightToLeft,
                      );
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(context, entry.id);
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit_outlined, size: 18),
                          Spacing.s8.w,
                          Text("Edit", style: r14),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 18, color: red),
                          Spacing.s8.w,
                          Text("Delete", style: r14.copyWith(color: red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacing.s8.h,
            Text(
              entry.answer,
              style: r14.copyWith(
                color: Theme.of(context).textTheme.bodyMedium!.color,
                height: 1.4,
              ),
            ),
            if (entry.imagePath != null) ...[
              Spacing.s12.h,
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.file(
                  File(entry.imagePath!),
                  height: 120.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    padding: const EdgeInsets.all(12),
                    color: slate[100],
                    child: Row(
                      children: [
                        Icon(Icons.broken_image_outlined, color: slate[400]),
                        Spacing.s8.w,
                        Text(
                          "Attachment not found",
                          style: r12.copyWith(color: slate[400]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            Spacing.s12.h,
            Text(
              formatJournalDate(entry.createdAt),
              style: r12.copyWith(color: slate[400]),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String id) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          "Delete Entry",
          style: r18.copyWith(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to delete this journal reflection?",
          style: r14,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel", style: r14.copyWith(color: slate[500])),
          ),
          TextButton(
            onPressed: () {
              controller.deleteEntry(id);
              Get.back();
              Get.snackbar(
                "Deleted",
                "Your journal entry has been removed.",
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text(
              "Delete",
              style: r14.copyWith(color: red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80.h,
            width: 80.h,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '\u{f02d}', // Book/Journal icon in FontAwesome solid
                style: TextStyle(
                  fontFamily: 'FontAwesomeSolid',
                  fontSize: 32.sp,
                  color: primary,
                ),
              ),
            ),
          ),
          Spacing.s20.h,
          Text(
            "Your Mind is a Canvas",
            style: r18.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
          Spacing.s8.h,
          Text(
            "Write down your thoughts, reflect on today, or answer the daily question to build mindfulness.",
            textAlign: TextAlign.center,
            style: r14.copyWith(
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
        ],
      ),
    );
  }

  String formatJournalDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCompare = DateTime(dt.year, dt.month, dt.day);

    final hourNum = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final timeStr = "${hourNum.toString().padLeft(2, '0')}:$minute $period";

    if (dateToCompare == today) {
      return "Today · $timeStr";
    } else if (dateToCompare == yesterday) {
      return "Yesterday · $timeStr";
    } else {
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
      return "${months[dt.month - 1]} ${dt.day}, ${dt.year} · $timeStr";
    }
  }
}
