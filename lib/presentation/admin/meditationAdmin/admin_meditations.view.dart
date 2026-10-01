import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/model/meditation_session.model.dart';
import 'package:Mentora/infrastructure/theme/app_scale.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import '../widgets/admin_delete_dialog.widget.dart';
import '../widgets/admin_section_header.widget.dart';
import '../widgets/admin_skeleton_loading.widget.dart';
import 'controllers/admin_meditation.controller.dart';
import 'views/admin_meditation_form.dialog.dart';

class AdminMeditationsView extends StatelessWidget {
  const AdminMeditationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminMeditationsController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: AppScale.pagePaddingHorizontal(),
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => AdminSectionHeader(
              title: 'Guided Meditations CMS',
              subtitle:
                  'Manage and publish mindfulness audio sessions, durations, and categories.',
              searchHint: 'Search meditations...',
              onSearchChanged: controller.onSearchChanged,
              buttonText: 'Add Meditation',
              onAddPressed: () => AdminMeditationFormDialog.show(context: context),
              onRefresh: controller.fetchMeditations,
              filterWidget: controller.categories.length > 1
                  ? Container(
                      height: 44,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
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
                          isDense: true,
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
                            size: 20,
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
              return const AdminGridSkeleton(
                childAspectRatio: 1.35,
                cardType: AdminSkeletonCardType.standard,
              );
            }

            if (controller.meditations.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    children: [
                      Icon(
                        Icons.self_improvement_rounded,
                        size: 48,
                        color: slate[400],
                      ),
                      Spacing.s12.h,
                      Text(
                        'No meditations found',
                        style: h3.copyWith(color: slate[500]),
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
                    : (constraints.maxWidth > 650 ? 2 : 1);

                final double childAspectRatio = crossAxisCount == 1
                    ? (constraints.maxWidth < 500 ? 1.95 : 1.7)
                    : 1.35;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: constraints.maxWidth < 600 ? 10 : 14,
                    mainAxisSpacing: constraints.maxWidth < 600 ? 10 : 14,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemCount: controller.meditations.length,
                  itemBuilder: (context, index) {
                    final item = controller.meditations[index];
                    return _buildMeditationCard(context, item, controller);
                  },
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMeditationCard(
    BuildContext context,
    MeditationSessionModel item,
    AdminMeditationsController controller,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMobile = AppScale.isMobile;

    return CustomPrimaryCard(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: isMobile ? 46 : 54,
                  height: isMobile ? 46 : 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : slate[200]!,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11.r),
                    child: Image.network(
                      item.imageUrl ?? '',
                      width: isMobile ? 46 : 54,
                      height: isMobile ? 46 : 54,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 54,
                        height: 54,
                        color: primary.withValues(alpha: 0.15),
                        child: Center(
                          child: Text(
                            '\u{f4b8}',
                            style: TextStyle(
                              fontFamily: 'FontAwesomeSolid',
                              fontSize: 20,
                              color: primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacing.s12.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              item.category ?? 'Mindfulness',
                              style: r10.copyWith(
                                color: primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (item.isFeatured == true)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: warningColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    size: 12,
                                    color: warningColor,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    'Featured',
                                    style: r10.copyWith(
                                      color: warningColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      Spacing.s4.h,
                      Text(
                        item.title ?? 'Untitled Session',
                        style: r14.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.textTheme.headlineLarge?.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: slate[400],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.duration ?? '10 min',
                            style: r12.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                item.description ?? '',
                style: r12.copyWith(
                  color: theme.textTheme.bodyMedium?.color,
                  height: 1.35,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 6),
            Divider(
              height: 1,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : slate[200]!,
            ),
            Spacing.s8.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF282926) : slate[100],
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'ID: #${item.id ?? 0}',
                    style: r10.copyWith(
                      color: isDark ? slate[400] : slate[600],
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Tooltip(
                      message: 'Edit Meditation',
                      child: InkWell(
                        onTap: () => AdminMeditationFormDialog.show(
                          context: context,
                          meditation: item,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          padding: const EdgeInsets.all(6),
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
                    Spacing.s8.w,
                    Tooltip(
                      message: 'Delete Meditation',
                      child: InkWell(
                        onTap: () => AdminDeleteDialog.show(
                          context: context,
                          title: 'Delete Meditation',
                          itemName: item.title ?? 'Session',
                          onConfirm: () => controller.deleteMeditation(item.id ?? 0),
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          padding: const EdgeInsets.all(6),
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
          ],
        ),
      ),
    );
  }
}
