import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/model/expert.model.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import '../widgets/admin_delete_dialog.widget.dart';
import '../widgets/admin_section_header.widget.dart';
import '../widgets/admin_skeleton_loading.widget.dart';
import 'controllers/admin_doctor.controller.dart';
import 'views/admin_doctor_form.dialog.dart';

class AdminDoctorView extends StatelessWidget {
  const AdminDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminDoctorController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => AdminSectionHeader(
              title: 'Doctors & Experts Directory CMS',
              subtitle:
                  'Manage verified psychologists, therapists, consultation rates, and specialist tags.',
              searchHint: 'Search doctors by name or speciality...',
              onSearchChanged: controller.onSearchChanged,
              buttonText: 'Register Doctor',
              onAddPressed: () => AdminDoctorFormDialog.show(context: context),
              onRefresh: controller.fetchDoctors,
              filterWidget: Container(
                height: 44.h,
                alignment: Alignment.center,
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
                    value: controller.selectedSpeciality.value,
                    isDense: true,
                    alignment: AlignmentDirectional.centerStart,
                    dropdownColor: isDark ? const Color(0xFF242522) : white,
                    items: controller.specialities.map((spec) {
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
              return const AdminGridSkeleton(
                childAspectRatio: 1.28,
                cardType: AdminSkeletonCardType.avatar,
              );
            }

            if (controller.doctors.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(48.h),
                  child: Column(
                    children: [
                      Icon(Icons.person_search_rounded, size: 48.spMin, color: slate[400]),
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
                        : (constraints.maxWidth > 700 ? 2 : 1);

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 1.28,
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

    return CustomPrimaryCard(
      child: Padding(
        padding: EdgeInsets.all(16.w),
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
                    radius: 26.r,
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
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
                                  width: 6.w,
                                  height: 6.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: doc.isAvailable == true ? successColor : slate[400],
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  doc.isAvailable == true ? 'Active' : 'Offline',
                                  style: r10.copyWith(
                                    color: doc.isAvailable == true ? successColor : slate[500],
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
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
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
                          Icon(Icons.star_rounded, size: 14.spMin, color: warningColor),
                          SizedBox(width: 2.w),
                          Text(
                            '${doc.rating ?? 5.0}',
                            style: r10.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '(${doc.reviewsCount ?? 0})',
                            style: r10.copyWith(color: theme.textTheme.bodySmall?.color),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF282926) : slate[100],
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
            // Specialties badges
            if (doc.specialties != null && doc.specialties!.isNotEmpty) ...[
              Wrap(
                spacing: 4.w,
                runSpacing: 4.h,
                children: doc.specialties!.take(3).map((s) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF282926) : const Color(0xFFF1F3EB),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      s,
                      style: r10.copyWith(color: theme.textTheme.bodySmall?.color),
                    ),
                  );
                }).toList(),
              ),
              Spacing.s8.h,
            ],
            Expanded(
              child: Text(
                doc.bio ?? '',
                style: r12.copyWith(
                  color: theme.textTheme.bodyMedium?.color,
                  height: 1.35,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 6.h),
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
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF282926) : slate[100],
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'ID: #${doc.id ?? 0}',
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
                      message: 'Edit Doctor Profile',
                      child: InkWell(
                        onTap: () => AdminDoctorFormDialog.show(
                          context: context,
                          doctor: doc,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 16.spMin,
                            color: primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Tooltip(
                      message: 'Delete Doctor Profile',
                      child: InkWell(
                        onTap: () => AdminDeleteDialog.show(
                          context: context,
                          title: 'Delete Doctor Profile',
                          itemName: doc.name ?? 'Doctor',
                          onConfirm: () => controller.deleteDoctor(doc.id ?? 0),
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            color: dangerColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            size: 16.spMin,
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
    final theme = Theme.of(context);

    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing ${controller.doctors.length} of ${controller.totalItems.value} professionals',
            style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
          ),
          Row(
            children: [
              IconButton(
                onPressed: controller.currentPage.value > 1
                    ? () => controller.fetchDoctors(page: controller.currentPage.value - 1)
                    : null,
                icon: const Icon(Icons.chevron_left_rounded),
                tooltip: 'Previous Page',
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'Page ${controller.currentPage.value} of ${controller.totalPages.value}',
                  style: r12.copyWith(color: primary, fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                onPressed: controller.currentPage.value < controller.totalPages.value
                    ? () => controller.fetchDoctors(page: controller.currentPage.value + 1)
                    : null,
                icon: const Icon(Icons.chevron_right_rounded),
                tooltip: 'Next Page',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
