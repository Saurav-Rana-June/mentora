import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/model/activity.model.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import '../widgets/admin_delete_dialog.widget.dart';
import '../widgets/admin_section_header.widget.dart';
import 'controllers/admin_activity.controller.dart';
import 'views/admin_activity_form.dialog.dart';

class AdminActivityView extends StatelessWidget {
  const AdminActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminActivityController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => AdminSectionHeader(
              title: 'Activity Plans CMS',
              subtitle:
                  'Manage wellness activity catalog records, mood tags, and recommendation priorities.',
              searchHint: 'Search activity plans by title, category...',
              onSearchChanged: controller.onSearchChanged,
              buttonText: 'Add Activity',
              onAddPressed: () => AdminActivityFormDialog.show(context: context),
              onRefresh: controller.fetchActivities,
              filterWidget: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF242522) : white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : slate[200]!,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedCategory.value,
                    items: controller.categories.map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat,
                        child: Text(
                          cat.capitalizeFirst ?? cat,
                          style: r14.copyWith(
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) controller.onCategoryChanged(val);
                    },
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20.spMin,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              ),
            ),
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

            final list = controller.filteredActivities;
            if (list.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(48.h),
                  child: Column(
                    children: [
                      Icon(Icons.assignment_outlined, size: 48.spMin, color: slate[400]),
                      Spacing.s12.h,
                      Text(
                        'No activities found',
                        style: h3.copyWith(color: slate[500]),
                      ),
                      Spacing.s8.h,
                      Text(
                        'Click "Add Activity" to register a new plan template.',
                        style: r14.copyWith(color: slate[400]),
                      ),
                    ],
                  ),
                ),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 1100
                    ? 3
                    : (constraints.maxWidth > 700 ? 2 : 1);

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 1.35,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return _buildActivityCard(context, item, controller);
                  },
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context,
    ActivityModel item,
    AdminActivityController controller,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomPrimaryCard(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      _getActivityIcon(item.icon),
                      style: TextStyle(
                        fontFamily: 'FontAwesomeSolid',
                        fontSize: 18.spMin,
                        color: primary,
                      ),
                    ),
                  ),
                ),
                Spacing.s12.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              item.category.toUpperCase(),
                              style: r10.copyWith(color: primary, fontWeight: FontWeight.w700),
                            ),
                          ),
                          if (item.isSafetyPriority) ...[
                            SizedBox(width: 6.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                color: dangerColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                'Crisis Priority',
                                style: r10.copyWith(color: dangerColor, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Spacing.s4.h,
                      Text(
                        item.title,
                        style: r14.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.textTheme.headlineLarge?.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        item.duration,
                        style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacing.s8.h,
            // Tags
            if (item.tags.isNotEmpty) ...[
              Wrap(
                spacing: 4.w,
                runSpacing: 4.h,
                children: item.tags.take(3).map((tag) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF282926) : const Color(0xFFF1F3EB),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      tag,
                      style: r10.copyWith(color: theme.textTheme.bodySmall?.color),
                    ),
                  );
                }).toList(),
              ),
              Spacing.s8.h,
            ],
            Expanded(
              child: Text(
                item.caption,
                style: r12.copyWith(color: theme.textTheme.bodyMedium?.color, height: 1.3),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Spacing.s8.h,
            const Divider(height: 1),
            Spacing.s8.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ID: #${item.id} • ${item.isActive ? 'Active' : 'Archived'}',
                  style: r10.copyWith(color: isDark ? slate[400] : slate[500], fontFamily: 'monospace'),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit_outlined, size: 18.spMin, color: primary),
                      tooltip: 'Edit Activity',
                      onPressed: () => AdminActivityFormDialog.show(
                        context: context,
                        activity: item,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline_rounded, size: 18.spMin, color: dangerColor),
                      tooltip: 'Archive Activity',
                      onPressed: () => AdminDeleteDialog.show(
                        context: context,
                        title: 'Archive Activity',
                        itemName: item.title,
                        onConfirm: () => controller.deleteActivity(item.id),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getActivityIcon(String icon) {
    switch (icon.toLowerCase()) {
      case 'box':
      case 'breathing':
        return '\u{f72e}'; // wind
      case 'lotus':
      case 'spa':
      case 'meditation':
        return '\u{f4b8}'; // spa
      case 'moon':
      case 'sleep':
        return '\u{f186}'; // moon
      case 'book':
      case 'journaling':
        return '\u{f518}'; // book-open
      case 'heart':
      case 'gratitude':
        return '\u{f004}'; // heart
      case 'running':
      case 'movement':
      case 'walking':
        return '\u{f70c}'; // walking
      default:
        return '\u{f0ae}'; // tasks
    }
  }
}
