import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/model/expert.model.dart';
import 'package:Mentora/infrastructure/theme/app_scale.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import '../widgets/admin_delete_dialog.widget.dart';
import '../widgets/admin_pagination_footer.widget.dart';
import '../widgets/admin_section_header.widget.dart';
import '../widgets/admin_skeleton_loading.widget.dart';
import 'controllers/admin_doctor.controller.dart';
import 'views/admin_doctor_wizard.dialog.dart';
import 'views/admin_specialities_dialog.widget.dart';

class AdminDoctorView extends StatelessWidget {
  const AdminDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminDoctorController());
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
              title: 'Doctors & Experts Directory CMS',
              subtitle:
                  'Manage verified psychologists, therapists, consultation rates, specialities, and working schedules.',
              searchHint: 'Search doctors by name or speciality...',
              onSearchChanged: controller.onSearchChanged,
              secondaryButtonText: 'Specialities',
              secondaryButtonIcon: Icons.category_outlined,
              onSecondaryPressed: () => AdminSpecialitiesDialog.show(context),
              buttonText: 'Register Doctor',
              onAddPressed: () =>
                  AdminDoctorWizardDialog.show(context: context),
              onRefresh: () {
                controller.fetchSpecialities();
                controller.fetchDoctors();
              },
              filterWidget: Container(
                height: 44,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 12),
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
                    value:
                        controller.specialityFilterOptions.contains(
                          controller.selectedSpeciality.value,
                        )
                        ? controller.selectedSpeciality.value
                        : controller.specialityFilterOptions.firstOrNull ??
                              'All Specialities',
                    isDense: true,
                    alignment: AlignmentDirectional.centerStart,
                    dropdownColor: isDark ? const Color(0xFF242522) : white,
                    items: controller.specialityFilterOptions.map((spec) {
                      return DropdownMenuItem<String>(
                        value: spec,
                        child: Text(
                          spec,
                          style: r14.copyWith(
                            color: theme.textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) controller.onSpecialityChanged(val);
                    },
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
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
              return const AdminGridSkeleton(
                childAspectRatio: 1.28,
                cardType: AdminSkeletonCardType.avatar,
              );
            }

            if (controller.doctors.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    children: [
                      Icon(
                        Icons.person_search_rounded,
                        size: 48,
                        color: slate[400],
                      ),
                      Spacing.s12.h,
                      Text(
                        'No doctors or experts found',
                        style: h3.copyWith(color: slate[500]),
                      ),
                      Spacing.s8.h,
                      Text(
                        'Click "Register Doctor" to create a new professional profile.',
                        style: r14.copyWith(color: slate[400]),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 1100
                        ? 3
                        : (constraints.maxWidth > 650 ? 2 : 1);

                    final double childAspectRatio = crossAxisCount == 1
                        ? (constraints.maxWidth < 500 ? 1.85 : 1.6)
                        : 1.15;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: constraints.maxWidth < 600 ? 10 : 14,
                        mainAxisSpacing: constraints.maxWidth < 600 ? 10 : 14,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemCount: controller.doctors.length,
                      itemBuilder: (context, index) {
                        final doc = controller.doctors[index];
                        return _buildDoctorCard(context, doc, controller);
                      },
                    );
                  },
                ),
                Spacing.s20.h,
                _buildPaginationFooter(context, controller),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(
    BuildContext context,
    Expert doc,
    AdminDoctorController controller,
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : slate[200]!,
                      width: 1.5,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: isMobile ? 20.r : 24.r,
                    backgroundColor: primary.withValues(alpha: 0.15),
                    backgroundImage: doc.image != null && doc.image!.isNotEmpty
                        ? NetworkImage(doc.image!)
                        : null,
                    child: doc.image == null || doc.image!.isEmpty
                        ? Text(
                            doc.name?.isNotEmpty == true
                                ? doc.name![0].toUpperCase()
                                : 'D',
                            style: h3.copyWith(color: primary),
                          )
                        : null,
                  ),
                ),
                Spacing.s12.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              doc.name ?? 'Doctor Profile',
                              style: r14.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.textTheme.headlineLarge?.color,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: doc.isAvailable == true
                                  ? successColor.withValues(alpha: 0.12)
                                  : slate[300]!.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: doc.isAvailable == true
                                        ? successColor
                                        : slate[400],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  doc.isAvailable == true
                                      ? 'Active'
                                      : 'Offline',
                                  style: r10.copyWith(
                                    color: doc.isAvailable == true
                                        ? successColor
                                        : slate[500],
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Spacing.s4.h,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          doc.speciality ?? 'Specialist',
                          style: r10.copyWith(
                            color: primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Spacing.s4.h,
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: warningColor,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${doc.rating ?? 5.0}',
                            style: r10.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '(${doc.reviewsCount ?? 0})',
                            style: r10.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF282926)
                                  : slate[100],
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              '\$${doc.startingPricePerHour ?? 25}/hr',
                              style: r10.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.textTheme.headlineMedium?.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacing.s8.h,
            // Education snippet
            if ((doc.degree != null && doc.degree!.isNotEmpty) ||
                (doc.university != null && doc.university!.isNotEmpty)) ...[
              Row(
                children: [
                  Icon(Icons.school_outlined, size: 14, color: primary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      [
                        doc.degree,
                        doc.university,
                      ].where((s) => s != null && s.isNotEmpty).join(' • '),
                      style: r10.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Spacing.s4.h,
            ],
            // Modalities & Availability chips
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                if (doc.callFeature == true)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: infoColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.call_rounded, size: 12, color: infoColor),
                        const SizedBox(width: 3),
                        Text(
                          'Voice',
                          style: r10.copyWith(
                            color: infoColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (doc.videoCallFeature == true)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.videocam_rounded, size: 12, color: primary),
                        const SizedBox(width: 3),
                        Text(
                          'Video',
                          style: r10.copyWith(
                            color: primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (doc.availableDays != null && doc.availableDays!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF282926) : slate[100],
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      '${doc.availableDays!.length} days/wk',
                      style: r10.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const Spacer(),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF282926) : slate[100],
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'Exp: ${doc.experienceYears ?? 1} yrs',
                    style: r10.copyWith(
                      color: isDark ? slate[400] : slate[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Tooltip(
                      message: 'Edit Doctor',
                      child: InkWell(
                        onTap: () => AdminDoctorWizardDialog.show(
                          context: context,
                          doctor: doc,
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
                    const SizedBox(width: 8),
                    Tooltip(
                      message: 'Delete Doctor',
                      child: InkWell(
                        onTap: () => AdminDeleteDialog.show(
                          context: context,
                          title: 'Delete Doctor Profile',
                          itemName: doc.name ?? 'Doctor',
                          onConfirm: () => controller.deleteDoctor(doc.id ?? 0),
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

  Widget _buildPaginationFooter(
    BuildContext context,
    AdminDoctorController controller,
  ) {
    return Obx(
      () => AdminPaginationFooter(
        currentPage: controller.currentPage.value,
        totalPages: controller.totalPages.value,
        totalItems: controller.totalItems.value,
        currentItemCount: controller.doctors.length,
        itemsPerPage: 9,
        itemName: 'doctors',
        onPageChanged: (page) => controller.fetchDoctors(page: page),
      ),
    );
  }
}
