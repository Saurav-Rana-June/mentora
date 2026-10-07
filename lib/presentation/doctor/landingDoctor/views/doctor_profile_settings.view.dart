import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/enums/snackbar_enum.dart';
import 'package:Mentora/data/utils/app_utils.dart';
import 'package:Mentora/infrastructure/theme/app_scale.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/doctor/widgets/doctor_badge.widget.dart';
import 'package:Mentora/presentation/doctor/widgets/doctor_section_header.widget.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:Mentora/widgets/fields/custom_textfield.widget.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import '../controllers/landing_doctor.controller.dart';

class DoctorProfileSettingsView extends StatefulWidget {
  const DoctorProfileSettingsView({super.key});

  @override
  State<DoctorProfileSettingsView> createState() => _DoctorProfileSettingsViewState();
}

class _DoctorProfileSettingsViewState extends State<DoctorProfileSettingsView> {
  final _landingCtrl = Get.find<LandingDoctorController>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _specialityCtrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _licenseCtrl;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final p = _landingCtrl.doctorProfile.value;
    _nameCtrl = TextEditingController(text: p?.name ?? 'Dr. Sarah Jenkins, MD');
    _specialityCtrl = TextEditingController(text: p?.speciality ?? 'Clinical Psychologist');
    _bioCtrl = TextEditingController(
      text: p?.bio ??
          'Board-certified Clinical Psychologist specializing in Cognitive Behavioral Therapy (CBT), anxiety disorders, and mindfulness.',
    );
    _priceCtrl = TextEditingController(text: (p?.startingPricePerHour ?? 85.0).toString());
    _licenseCtrl = TextEditingController(text: p?.licenseNumber ?? 'PSY-CA-994820');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _specialityCtrl.dispose();
    _bioCtrl.dispose();
    _priceCtrl.dispose();
    _licenseCtrl.dispose();
    super.dispose();
  }

  void _saveProfile() {
    setState(() => _isSaving = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isSaving = false);
        AppUtils.snackbar('Profile Updated', 'Doctor profile information saved.', SnackBarType.SUCCESS);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: AppScale.pagePaddingHorizontal(),
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoctorSectionHeader(
            title: 'Doctor Profile & Settings',
            subtitle: 'Manage your practitioner bio, license credentials, and account settings.',
          ),
          CustomPrimaryCard(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.r),
                        child: CachedNetworkImage(
                          imageUrl: _landingCtrl.doctorProfile.value?.image ??
                              'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=500',
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => const CircleAvatar(child: Icon(Icons.person)),
                        ),
                      ),
                      Spacing.s16.w,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Text(
                                _landingCtrl.doctorName.value,
                                style: h3.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            Spacing.s4.h,
                            DoctorBadge(text: 'ACTIVE CLINICAL PRACTITIONER', color: primary),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacing.s24.h,

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Full Name & Title', style: r14.copyWith(fontWeight: FontWeight.w600)),
                            Spacing.s8.h,
                            CustomTextFormField(
                              controller: _nameCtrl,
                              fillColor: theme.canvasColor,
                            ),
                          ],
                        ),
                      ),
                      Spacing.s12.w,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Primary Speciality', style: r14.copyWith(fontWeight: FontWeight.w600)),
                            Spacing.s8.h,
                            CustomTextFormField(
                              controller: _specialityCtrl,
                              fillColor: theme.canvasColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacing.s16.h,

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Consultation Rate (\$/hr)', style: r14.copyWith(fontWeight: FontWeight.w600)),
                            Spacing.s8.h,
                            CustomTextFormField(
                              controller: _priceCtrl,
                              keyboardType: TextInputType.number,
                              fillColor: theme.canvasColor,
                            ),
                          ],
                        ),
                      ),
                      Spacing.s12.w,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Medical License Number', style: r14.copyWith(fontWeight: FontWeight.w600)),
                            Spacing.s8.h,
                            CustomTextFormField(
                              controller: _licenseCtrl,
                              fillColor: theme.canvasColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacing.s16.h,

                  Text('Professional Biography', style: r14.copyWith(fontWeight: FontWeight.w600)),
                  Spacing.s8.h,
                  CustomTextFormField(
                    controller: _bioCtrl,
                    maxLines: 4,
                    fillColor: theme.canvasColor,
                  ),
                  Spacing.s24.h,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _landingCtrl.logout,
                        icon: Icon(Icons.logout_rounded, color: dangerColor, size: 16),
                        label: Text('Log Out of Doctor Portal', style: TextStyle(color: dangerColor)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: dangerColor.withValues(alpha: 0.5)),
                        ),
                      ),
                      CustomPrimaryButton(
                        text: 'Save Changes',
                        isLoading: _isSaving,
                        backgroundColor: primary,
                        onPressed: _saveProfile,
                        prefixIcon: const Icon(Icons.check, color: Colors.white, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
