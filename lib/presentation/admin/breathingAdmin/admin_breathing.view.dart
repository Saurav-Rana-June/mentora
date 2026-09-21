import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/model/breathing_pattern.model.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import '../widgets/admin_delete_dialog.widget.dart';
import '../widgets/admin_section_header.widget.dart';
import 'controllers/admin_breathing.controller.dart';
import 'views/admin_breathing_form.dialog.dart';

class AdminBreathingView extends StatelessWidget {
  const AdminBreathingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminBreathingController());

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            title: 'Breathing Exercises CMS',
            subtitle:
                'Configure guided breathwork patterns, cycle timings (inhale/hold/exhale), and presets.',
            searchHint: 'Search breathing techniques...',
            onSearchChanged: controller.onSearchChanged,
            buttonText: 'Add Technique',
            onAddPressed: () => AdminBreathingFormDialog.show(context: context),
            onRefresh: controller.fetchPatterns,
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

            if (controller.patterns.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(48.h),
                  child: Column(
                    children: [
                      Icon(Icons.air_rounded, size: 48.spMin, color: slate[400]),
                      Spacing.s12.h,
                      Text(
                        'No breathing techniques found',
                        style: h3.copyWith(color: slate[500]),
                      ),
                      Spacing.s8.h,
                      Text(
                        'Click "Add Technique" to create a new breathwork pattern.',
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
                  itemCount: controller.patterns.length,
                  itemBuilder: (context, index) {
                    final item = controller.patterns[index];
                    return _buildPatternCard(context, item, controller);
                  },
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPatternCard(
    BuildContext context,
    BreathingPatternModel item,
    AdminBreathingController controller,
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
                      item.icon?.isNotEmpty == true ? item.icon! : '🌬️',
                      style: TextStyle(fontSize: 22.spMin),
                    ),
                  ),
                ),
                Spacing.s12.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name ?? 'Breathing Technique',
                        style: r14.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.textTheme.headlineLarge?.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacing.s4.h,
                      Text(
                        'Total Cycle: ${item.cycleDuration}s',
                        style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacing.s12.h,
            // Phase chips
            Row(
              children: [
                _buildPhaseBadge('Inhale', '${item.inhale ?? 0}s', primary),
                Spacing.s4.w,
                _buildPhaseBadge('Hold', '${item.holdIn ?? 0}s', infoColor),
                Spacing.s4.w,
                _buildPhaseBadge('Exhale', '${item.exhale ?? 0}s', warningColor),
                Spacing.s4.w,
                _buildPhaseBadge('Hold', '${item.holdOut ?? 0}s', slate[500]!),
              ],
            ),
            Spacing.s8.h,
            Expanded(
              child: Text(
                item.description ?? '',
                style: r12.copyWith(
                  color: theme.textTheme.bodyMedium?.color,
                  height: 1.3,
                ),
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
                  'ID: #${item.id ?? 0}',
                  style: r10.copyWith(
                    color: isDark ? slate[400] : slate[500],
                    fontFamily: 'monospace',
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit_outlined, size: 18.spMin, color: primary),
                      tooltip: 'Edit Technique',
                      onPressed: () => AdminBreathingFormDialog.show(
                        context: context,
                        pattern: item,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline_rounded, size: 18.spMin, color: dangerColor),
                      tooltip: 'Delete Technique',
                      onPressed: () => AdminDeleteDialog.show(
                        context: context,
                        title: 'Delete Breathing Technique',
                        itemName: item.name ?? 'Technique',
                        onConfirm: () => controller.deletePattern(item.id ?? 0),
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

  Widget _buildPhaseBadge(String label, String time, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: r10.copyWith(color: color, fontWeight: FontWeight.w600),
            ),
            Text(
              time,
              style: r12.copyWith(color: color, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
