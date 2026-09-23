import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/model/speciality.model.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import '../controllers/admin_doctor.controller.dart';

class AdminSpecialitiesDialog extends StatefulWidget {
  const AdminSpecialitiesDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => const AdminSpecialitiesDialog(),
    );
  }

  @override
  State<AdminSpecialitiesDialog> createState() => _AdminSpecialitiesDialogState();
}

class _AdminSpecialitiesDialogState extends State<AdminSpecialitiesDialog> {
  final _controller = Get.find<AdminDoctorController>();

  void _showFormModal({Speciality? speciality}) {
    final nameController = TextEditingController(text: speciality?.name ?? '');
    final descController = TextEditingController(text: speciality?.description ?? '');
    final formKey = GlobalKey<FormState>();
    bool isActive = speciality?.isActive ?? true;

    showDialog(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final isDark = theme.brightness == Brightness.dark;
        final isEditing = speciality != null;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF1E1F1D) : white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              title: Text(
                isEditing ? 'Edit Speciality' : 'Add New Speciality',
                style: h3.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.headlineMedium?.color,
                ),
              ),
              content: SizedBox(
                width: 440.w,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Speciality Name *',
                        style: r12.copyWith(fontWeight: FontWeight.w600, color: theme.textTheme.bodyMedium?.color),
                      ),
                      Spacing.s4.h,
                      TextFormField(
                        controller: nameController,
                        style: r14.copyWith(color: theme.textTheme.bodyLarge?.color),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Name required' : null,
                        decoration: InputDecoration(
                          hintText: 'e.g. Neuropsychology',
                          filled: true,
                          fillColor: isDark ? const Color(0xFF282926) : const Color(0xFFF9FAF7),
                          contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.1) : slate[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(color: primary, width: 1.5),
                          ),
                        ),
                      ),
                      Spacing.s12.h,
                      Text(
                        'Description / Clinical Focus',
                        style: r12.copyWith(fontWeight: FontWeight.w600, color: theme.textTheme.bodyMedium?.color),
                      ),
                      Spacing.s4.h,
                      TextFormField(
                        controller: descController,
                        maxLines: 2,
                        style: r14.copyWith(color: theme.textTheme.bodyLarge?.color),
                        decoration: InputDecoration(
                          hintText: 'Brief summary of this medical/therapeutic field...',
                          filled: true,
                          fillColor: isDark ? const Color(0xFF282926) : const Color(0xFFF9FAF7),
                          contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.1) : slate[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(color: primary, width: 1.5),
                          ),
                        ),
                      ),
                      Spacing.s12.h,
                      SwitchListTile(
                        value: isActive,
                        onChanged: (val) => setModalState(() => isActive = val),
                        title: Text('Active in Doctor Selection', style: r12.copyWith(fontWeight: FontWeight.w600)),
                        contentPadding: EdgeInsets.zero,
                        activeTrackColor: primary,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('Cancel', style: r14.copyWith(color: theme.textTheme.bodyMedium?.color)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    Navigator.of(ctx).pop();

                    final payload = {
                      'name': nameController.text.trim(),
                      'description': descController.text.trim(),
                      'isActive': isActive,
                      'icon': 'spa',
                    };

                    if (isEditing) {
                      await _controller.updateSpeciality(speciality.id!, payload);
                    } else {
                      await _controller.createSpeciality(payload);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: Text(
                    isEditing ? 'Save Changes' : 'Create Speciality',
                    style: r14.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(Speciality speciality) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1F1D) : white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text('Delete Speciality', style: h3.copyWith(fontWeight: FontWeight.w700)),
        content: Text(
          'Are you sure you want to delete "${speciality.name}"? Existing doctors with this title will remain unaffected.',
          style: r14.copyWith(color: theme.textTheme.bodyLarge?.color),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: r14.copyWith(color: theme.textTheme.bodyMedium?.color)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              if (speciality.id != null) {
                await _controller.deleteSpeciality(speciality.id!);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: dangerColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            child: Text('Delete', style: r14.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1E1F1D) : white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        width: 640.w,
        constraints: BoxConstraints(maxHeight: Get.height * 0.85),
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Doctor Specialities Management',
                      style: h3.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.textTheme.headlineLarge?.color,
                      ),
                    ),
                    Spacing.s4.h,
                    Text(
                      'Configure available clinical specialities for doctor registration & search filtering.',
                      style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            Spacing.s16.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      '${_controller.specialities.length} Total Specialities',
                      style: r12.copyWith(color: primary, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showFormModal(),
                  icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
                  label: Text('Add Speciality', style: r14.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    elevation: 0,
                  ),
                ),
              ],
            ),
            Spacing.s16.h,
            const Divider(),
            Expanded(
              child: Obx(() {
                if (_controller.isLoadingSpecialities.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (_controller.specialities.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.category_outlined, size: 40.spMin, color: slate[400]),
                        Spacing.s8.h,
                        Text('No specialities configured', style: r14.copyWith(color: slate[500])),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: _controller.specialities.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: isDark ? Colors.white.withValues(alpha: 0.06) : slate[200]!,
                  ),
                  itemBuilder: (context, index) {
                    final spec = _controller.specialities[index];

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Row(
                        children: [
                          Container(
                            width: 36.w,
                            height: 36.w,
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Text(
                                '\u{f0f0}', // user-md
                                style: TextStyle(
                                  fontFamily: 'FontAwesomeSolid',
                                  fontSize: 16.spMin,
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
                                    Text(
                                      spec.name,
                                      style: r14.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: theme.textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                    if (!spec.isActive) ...[
                                      Spacing.s8.w,
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          color: warningColor.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(4.r),
                                        ),
                                        child: Text(
                                          'Inactive',
                                          style: r10.copyWith(color: warningColor, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                if (spec.description != null && spec.description!.isNotEmpty) ...[
                                  SizedBox(height: 2.h),
                                  Text(
                                    spec.description!,
                                    style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit_outlined, size: 18.spMin, color: primary),
                            tooltip: 'Edit Speciality',
                            onPressed: () => _showFormModal(speciality: spec),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline_rounded, size: 18.spMin, color: dangerColor),
                            tooltip: 'Delete Speciality',
                            onPressed: () => _confirmDelete(spec),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
