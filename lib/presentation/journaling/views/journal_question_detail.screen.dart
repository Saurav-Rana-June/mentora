import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/data/model/journal_entry.model.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:Mentora/widgets/buttons/custom_outline_button.widget.dart';
import '../controllers/journaling.controller.dart';
import 'package:Mentora/data/enums/snackbar_enum.dart';
import 'package:Mentora/data/utils/app_utils.dart';

class JournalQuestionDetailScreen extends StatefulWidget {
  final String question;
  final JournalEntryModel? existingEntry;

  const JournalQuestionDetailScreen({
    super.key,
    required this.question,
    this.existingEntry,
  });

  @override
  State<JournalQuestionDetailScreen> createState() =>
      _JournalQuestionDetailScreenState();
}

class _JournalQuestionDetailScreenState
    extends State<JournalQuestionDetailScreen> {
  final JournalingController controller = Get.find<JournalingController>();
  late final TextEditingController _answerController;
  late final RxString _currentQuestion;

  @override
  void initState() {
    super.initState();
    _answerController = TextEditingController(
      text: widget.existingEntry?.answer ?? '',
    );
    _currentQuestion = (widget.existingEntry?.question ?? widget.question).obs;

    // Initialize attachment state
    if (widget.existingEntry != null) {
      controller.attachedImagePath.value = widget.existingEntry!.imagePath;
    } else {
      controller.attachedImagePath.value = null;
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _rotateQuestion() {
    if (widget.existingEntry != null) {
      // Disable question rotation when editing an existing entry to maintain integrity
      AppUtils.snackbar(
        "Info",
        "You cannot change the question of an existing entry.",
        SnackBarType.INFO,
      );
      return;
    }
    final current = _currentQuestion.value;
    final available = controller.questionsList
        .map((q) => q.questionText)
        .toList();
    final listToUse = available.isNotEmpty
        ? available
        : controller.fallbackQuestions;
    final filtered = listToUse.where((q) => q != current).toList();
    if (filtered.isNotEmpty) {
      _currentQuestion.value = (filtered..shuffle()).first;
    }
  }

  void _handleSave() {
    final answer = _answerController.text.trim();
    if (answer.isEmpty) {
      AppUtils.snackbar(
        "Required",
        "Please write an answer before saving.",
        SnackBarType.WARNING,
      );
      return;
    }

    if (widget.existingEntry != null) {
      controller.updateEntry(
        widget.existingEntry!.id,
        answer,
        imagePath: controller.attachedImagePath.value,
      );
      Get.back();
    } else {
      controller.addEntry(
        _currentQuestion.value,
        answer,
        imagePath: controller.attachedImagePath.value,
      );
      Get.back();
    }
  }

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
      leading: IconButton(
        icon: Text(
          MyIcons.xmark,
          style: TextStyle(
            fontFamily: 'FontAwesomeLight',
            fontSize: 20,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        onPressed: () => Get.back(),
      ),
      actions: [
        if (widget.existingEntry == null)
          IconButton(
            icon: Text(
              MyIcons.rotateRight,
              style: TextStyle(
                fontFamily: 'FontAwesomeLight',
                fontSize: 18,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            onPressed: _rotateQuestion,
          ),
        Spacing.s12.w,
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.s12.symmetric.horizontal,
                vertical: Spacing.s12.symmetric.horizontal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question Text
                  Obx(() {
                    return Text(
                      _currentQuestion.value,
                      style: h3.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    );
                  }),
                  Spacing.s8.h,
                  // Answer Input Field
                  TextField(
                    controller: _answerController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    autofocus: true,
                    style: r16.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      height: 1.5,
                    ),
                    decoration: InputDecoration(
                      hintText: "Your answer...",
                      hintStyle: r16.copyWith(color: slate[400]),
                      fillColor: Colors.transparent,
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Spacing.s20.h,
                  // Image Attachment Preview
                  Obx(() {
                    final path = controller.attachedImagePath.value;
                    if (path == null) return const SizedBox.shrink();
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.file(
                            File(path),
                            width: double.infinity,
                            height: 200.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: GestureDetector(
                            onTap: () => controller.clearAttachment(),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
          // Tool Attachment Row
          buildAttachmentRow(context),
          Spacing.s16.h,
          // Bottom Cancel & Save Buttons Row
          buildActionButtonsRow(context),
          Spacing.s16.h,
        ],
      ),
    );
  }

  Widget buildAttachmentRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s12.symmetric.horizontal,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Microphone / Audio Note
          buildBottomActionIcon(
            context: context,
            iconUnicode: '\u{f130}', // Microphone in FA
            onTap: () {
              AppUtils.snackbar("Info", "Coming Soon!!", SnackBarType.INFO);
            },
          ),
          Spacing.s16.w,
          // Camera
          buildBottomActionIcon(
            context: context,
            iconUnicode: '\u{f030}', // Camera in FA
            onTap: () {
              AppUtils.snackbar("Info", "Coming Soon!!", SnackBarType.INFO);
            },
          ),
          Spacing.s16.w,
          // Image / Gallery
          buildBottomActionIcon(
            context: context,
            iconUnicode: '\u{f03e}', // Image/Gallery in FA
            onTap: () {
              AppUtils.snackbar("Info", "Coming Soon!!", SnackBarType.INFO);
            },
          ),
          Spacing.s16.w,
          // File / Document
          buildBottomActionIcon(
            context: context,
            iconUnicode: '\u{f15b}', // File/Doc in FA
            onTap: () {
              AppUtils.snackbar("Info", "Coming Soon!!", SnackBarType.INFO);
            },
          ),
        ],
      ),
    );
  }

  Widget buildBottomActionIcon({
    required BuildContext context,
    required String iconUnicode,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 40.h,
      width: 40.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.light
              ? slate[200]!
              : slate[700]!,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Center(
            child: Text(
              iconUnicode,
              style: TextStyle(
                fontFamily: 'FontAwesomeLight',
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildActionButtonsRow(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
      ),
      child: Row(
        children: [
          // Cancel Button
          Expanded(
            child: CustomOutlineButton(
              label: "Cancel",
              onTap: () => Get.back(),
              height: 42.h,
              borderRadius: 26.r,
              borderColor: isLight ? primary : slate[600],
              textColor: isLight ? primary : Colors.white70,
            ),
          ),
          Spacing.s16.w,
          // Save Button
          Expanded(
            child: CustomPrimaryButton(
              text: "Save",
              onPressed: _handleSave,
              height: 42.h,
              borderRadius: 26.r,
              backgroundColor: primary,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
