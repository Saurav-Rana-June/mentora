import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/model/journal_question.model.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import '../widgets/admin_delete_dialog.widget.dart';
import '../widgets/admin_section_header.widget.dart';
import 'controllers/admin_journaling.controller.dart';
import 'views/admin_journal_form.dialog.dart';

class AdminJournalingView extends StatelessWidget {
  const AdminJournalingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminJournalingController());

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            title: 'Journaling Prompts CMS',
            subtitle:
                'Manage daily reflection prompt questions presented to users in their mindfulness journal.',
            searchHint: 'Search prompt questions...',
            onSearchChanged: controller.onSearchChanged,
            buttonText: 'Add Prompt',
            onAddPressed: () => AdminJournalQuestionFormDialog.show(context: context),
            onRefresh: controller.fetchQuestions,
          ),
          Spacing.s20.h,
          Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(40.h),
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }

            final list = controller.filteredQuestions;
            if (list.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(48.h),
                  child: Column(
                    children: [
                      Icon(Icons.menu_book_rounded, size: 48.spMin, color: slate[400]),
                      Spacing.s12.h,
                      Text(
                        'No journaling prompts found',
                        style: h3.copyWith(color: slate[500]),
                      ),
                      Spacing.s8.h,
                      Text(
                        'Click "Add Prompt" to publish a new reflection prompt.',
                        style: r14.copyWith(color: slate[400]),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, __) => Spacing.s12.h,
              itemBuilder: (context, index) {
                final q = list[index];
                return _buildQuestionCard(context, q, index + 1, controller);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(
    BuildContext context,
    JournalQuestionModel q,
    int displayIndex,
    AdminJournalingController controller,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomPrimaryCard(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Text(
                  '#$displayIndex',
                  style: r12.copyWith(
                    fontWeight: FontWeight.w700,
                    color: primary,
                  ),
                ),
              ),
            ),
            Spacing.s16.w,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    q.questionText,
                    style: r16.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.headlineLarge?.color,
                    ),
                  ),
                  Spacing.s4.h,
                  Text(
                    'DB ID: ${q.id} • Created: ${q.createdAt.toLocal().toString().split(' ')[0]}',
                    style: r10.copyWith(
                      color: isDark ? slate[400] : slate[500],
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            Spacing.s12.w,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined, size: 20.spMin, color: primary),
                  tooltip: 'Edit Prompt',
                  onPressed: () => AdminJournalQuestionFormDialog.show(
                    context: context,
                    question: q,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline_rounded, size: 20.spMin, color: dangerColor),
                  tooltip: 'Delete Prompt',
                  onPressed: () => AdminDeleteDialog.show(
                    context: context,
                    title: 'Delete Prompt Question',
                    itemName: q.questionText,
                    onConfirm: () => controller.deleteQuestion(q.id),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
