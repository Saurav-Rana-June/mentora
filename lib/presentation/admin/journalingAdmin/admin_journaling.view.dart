import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/model/journal_question.model.dart';
import 'package:Mentora/infrastructure/theme/app_scale.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import '../widgets/admin_delete_dialog.widget.dart';
import '../widgets/admin_section_header.widget.dart';
import '../widgets/admin_skeleton_loading.widget.dart';
import 'controllers/admin_journaling.controller.dart';
import 'views/admin_journal_form.dialog.dart';

class AdminJournalingView extends StatelessWidget {
  const AdminJournalingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminJournalingController());

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: AppScale.pagePaddingHorizontal(context),
        vertical: AppScale.pagePaddingVertical(context),
      ),
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
              return const AdminListSkeleton(itemCount: 6);
            }

            final list = controller.filteredQuestions;
            if (list.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(AppScale.isMobile ? 24.0 : 48.0),
                  child: Column(
                    children: [
                      Icon(Icons.menu_book_rounded, size: 48, color: slate[400]),
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
    final isMobile = AppScale.isMobile;

    return CustomPrimaryCard(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 14.0 : 18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: isMobile ? 36.0 : 42.0,
              height: isMobile ? 36.0 : 42.0,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : slate[200]!,
                ),
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
            SizedBox(width: isMobile ? 12.0 : 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    q.questionText,
                    style: r14.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.headlineLarge?.color,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF282926) : slate[100],
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          'ID: #${q.id}',
                          style: r10.copyWith(
                            color: isDark ? slate[400] : slate[600],
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 14, color: slate[400]),
                          const SizedBox(width: 4),
                          Text(
                            q.createdAt.toLocal().toString().split(' ')[0],
                            style: r10.copyWith(
                              color: isDark ? slate[400] : slate[500],
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: isMobile ? 8.0 : 12.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Tooltip(
                  message: 'Edit Prompt',
                  child: InkWell(
                    onTap: () => AdminJournalQuestionFormDialog.show(
                      context: context,
                      question: q,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      padding: EdgeInsets.all(isMobile ? 6.0 : 8.0),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isMobile ? 6.0 : 8.0),
                Tooltip(
                  message: 'Delete Prompt',
                  child: InkWell(
                    onTap: () => AdminDeleteDialog.show(
                      context: context,
                      title: 'Delete Prompt Question',
                      itemName: q.questionText,
                      onConfirm: () => controller.deleteQuestion(q.id),
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      padding: EdgeInsets.all(isMobile ? 6.0 : 8.0),
                      decoration: BoxDecoration(
                        color: dangerColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 16,
                        color: dangerColor,
                      ),
                    ),
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
