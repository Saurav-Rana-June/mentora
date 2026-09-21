import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/model/video_session.model.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import '../widgets/admin_delete_dialog.widget.dart';
import '../widgets/admin_section_header.widget.dart';
import 'controllers/admin_video_session.controller.dart';
import 'views/admin_video_session_form.dialog.dart';

class AdminVideoSessionView extends StatelessWidget {
  const AdminVideoSessionView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminVideoSessionController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => AdminSectionHeader(
              title: 'Video Sessions CMS',
              subtitle:
                  'Manage guided video workouts, yoga classes, science sessions, and workshops.',
              searchHint: 'Search video sessions...',
              onSearchChanged: controller.onSearchChanged,
              buttonText: 'Add Video Session',
              onAddPressed: () => AdminVideoSessionFormDialog.show(context: context),
              onRefresh: controller.fetchSessions,
              filterWidget: controller.categories.length > 1
                  ? Container(
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
                                cat,
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
                    )
                  : null,
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

            if (controller.sessions.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(48.h),
                  child: Column(
                    children: [
                      Icon(Icons.video_library_rounded, size: 48.spMin, color: slate[400]),
                      Spacing.s12.h,
                      Text(
                        'No video sessions found',
                        style: h3.copyWith(color: slate[500]),
                      ),
                      Spacing.s8.h,
                      Text(
                        'Click "Add Video Session" to upload a new class.',
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
                  itemCount: controller.sessions.length,
                  itemBuilder: (context, index) {
                    final item = controller.sessions[index];
                    return _buildVideoCard(context, item, controller);
                  },
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildVideoCard(
    BuildContext context,
    VideoSessionModel item,
    AdminVideoSessionController controller,
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        item.imageUrl,
                        width: 56.w,
                        height: 56.w,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 56.w,
                          height: 56.w,
                          color: primary.withValues(alpha: 0.15),
                          child: Icon(Icons.play_circle_fill_rounded, color: primary, size: 28.spMin),
                        ),
                      ),
                      Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.play_arrow_rounded, color: white, size: 16.spMin),
                      ),
                    ],
                  ),
                ),
                Spacing.s12.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          item.category,
                          style: r10.copyWith(color: primary, fontWeight: FontWeight.w600),
                        ),
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
            Expanded(
              child: Text(
                item.description,
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
                  'ID: #${item.id}',
                  style: r10.copyWith(color: isDark ? slate[400] : slate[500], fontFamily: 'monospace'),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit_outlined, size: 18.spMin, color: primary),
                      tooltip: 'Edit Video',
                      onPressed: () => AdminVideoSessionFormDialog.show(
                        context: context,
                        session: item,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline_rounded, size: 18.spMin, color: dangerColor),
                      tooltip: 'Delete Video',
                      onPressed: () => AdminDeleteDialog.show(
                        context: context,
                        title: 'Delete Video Session',
                        itemName: item.title,
                        onConfirm: () => controller.deleteSession(item.id),
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
}
