import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/navigation/routes.dart';
import 'package:Mentora/infrastructure/theme/app_scale.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/doctor/widgets/doctor_badge.widget.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:Mentora/widgets/fields/custom_textfield.widget.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:Mentora/widgets/others/custom.screen.wrapper.dart';
import 'controllers/register_doctor.controller.dart';

class RegisterDoctorScreen extends GetView<RegisterDoctorController> {
  RegisterDoctorScreen({super.key});

  @override
  final controller = Get.put(RegisterDoctorController());

  @override
  Widget build(BuildContext context) {
    return CustomScreenWrapper(
      safeAreaTop: true,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppScale.pagePaddingHorizontal(),
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 780),
            child: Column(
              children: [
                buildHeader(context),
                Spacing.s20.h,
                buildStepperIndicator(context),
                Spacing.s20.h,
                buildFormCard(context),
                Spacing.s16.h,
                buildFooterLinks(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 44,
              width: 44,
              child: Image.asset('assets/logos/logo.png', fit: BoxFit.contain),
            ),
            Spacing.s12.w,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mentora Doctors',
                  style: h1.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.headlineLarge?.color,
                  ),
                ),
                Text(
                  'Clinical Practice & Telehealth Portal',
                  style: r14.copyWith(color: theme.textTheme.bodySmall?.color),
                ),
              ],
            ),
          ],
        ),
        Spacing.s12.h,
        DoctorBadge(
          text: 'DOCTOR ONBOARDING & CREDENTIALING',
          icon: '\u{f0f0}', // user-md
          color: primary,
        ),
      ],
    );
  }

  Widget buildStepperIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final steps = [
      {'title': 'Clinical Info', 'icon': '\u{f0f0}'},
      {'title': 'Credentials', 'icon': '\u{f19d}'},
      {'title': 'Availability', 'icon': '\u{f017}'},
      {'title': 'Verification', 'icon': '\u{f00c}'},
    ];

    return Obx(() {
      final current = controller.currentStep.value;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1F1D) : white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : slate[200]!,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(steps.length, (index) {
            final isDone = index < current;
            final isCurrent = index == current;
            final color = (isDone || isCurrent) ? primary : (isDark ? slate[700]! : slate[300]!);

            return Expanded(
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isDone
                          ? primary
                          : (isCurrent
                              ? primary.withValues(alpha: 0.15)
                              : (isDark ? slate[800] : slate[100])),
                      shape: BoxShape.circle,
                      border: Border.all(color: color, width: 1.5),
                    ),
                    child: Center(
                      child: isDone
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : Text(
                              '${index + 1}',
                              style: r12.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isCurrent ? primary : theme.textTheme.bodySmall?.color,
                              ),
                            ),
                    ),
                  ),
                  Spacing.s8.w,
                  if (!AppScale.isMobile)
                    Flexible(
                      child: Text(
                        steps[index]['title']!,
                        style: r12.copyWith(
                          fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                          color: isCurrent ? theme.textTheme.bodyLarge?.color : theme.textTheme.bodySmall?.color,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (index < steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        color: index < current ? primary : (isDark ? slate[800]! : slate[200]!),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      );
    });
  }

  Widget buildFormCard(BuildContext context) {
    return CustomPrimaryCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Obx(() {
          final step = controller.currentStep.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (step == 0) buildStep1Personal(context),
              if (step == 1) buildStep2Credentials(context),
              if (step == 2) buildStep3Availability(context),
              if (step == 3) buildStep4Preview(context),
              Spacing.s24.h,
              buildStepperButtons(context),
            ],
          );
        }),
      ),
    );
  }

  // --- Step 1: Personal & Clinical Info ---
  Widget buildStep1Personal(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Form(
      key: controller.step1FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 1: Clinical Profile & Identity',
            style: h2.copyWith(fontWeight: FontWeight.w700),
          ),
          Spacing.s4.h,
          Text(
            'Provide your professional medical identity, specialization, and consultation rates.',
            style: r14.copyWith(color: theme.textTheme.bodySmall?.color),
          ),
          Spacing.s20.h,

          // Avatar Selector Row
          Row(
            children: [
              Stack(
                children: [
                  Obx(
                    () => ClipRRect(
                      borderRadius: BorderRadius.circular(50.r),
                      child: CachedNetworkImage(
                        imageUrl: controller.imageController.text.isNotEmpty
                            ? controller.imageController.text
                            : 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=500',
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => const CircleAvatar(
                          radius: 36,
                          child: Icon(Icons.person, size: 36),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () => controller.pickAndUploadImage(source: ImageSource.gallery),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: isDark ? const Color(0xFF1E1F1D) : white, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                      ),
                    ),
                  ),
                ],
              ),
              Spacing.s16.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Doctor Profile Photo', style: r14.copyWith(fontWeight: FontWeight.w600)),
                    Spacing.s4.h,
                    Text(
                      'Upload high-resolution clinical headshot (PNG, JPG, WebP).',
                      style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                    ),
                    Spacing.s8.h,
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => controller.pickAndUploadImage(source: ImageSource.gallery),
                          icon: const Icon(Icons.upload_file_rounded, size: 16),
                          label: const Text('Upload Photo'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacing.s20.h,

          // Full Name & Primary Speciality
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Full Name & Title *', style: r14.copyWith(fontWeight: FontWeight.w600)),
                    Spacing.s8.h,
                    CustomTextFormField(
                      controller: controller.nameController,
                      hintText: 'e.g. Dr. Emily Vance, MD',
                      fillColor: theme.canvasColor,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                    ),
                  ],
                ),
              ),
              Spacing.s12.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Primary Speciality *', style: r14.copyWith(fontWeight: FontWeight.w600)),
                    Spacing.s8.h,
                    Obx(
                      () => Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: theme.canvasColor,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: isDark ? slate[700]! : slate[300]!),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: controller.availableSpecialityNames.contains(controller.selectedSpeciality.value)
                                ? controller.selectedSpeciality.value
                                : (controller.availableSpecialityNames.isNotEmpty ? controller.availableSpecialityNames.first : null),
                            isExpanded: true,
                            items: controller.availableSpecialityNames.map((s) {
                              return DropdownMenuItem(value: s, child: Text(s, style: r14));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) controller.selectedSpeciality.value = val;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacing.s16.h,

          // Years Experience & Starting Rate
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Years of Experience', style: r14.copyWith(fontWeight: FontWeight.w600)),
                    Spacing.s8.h,
                    CustomTextFormField(
                      controller: controller.experienceController,
                      keyboardType: TextInputType.number,
                      hintText: '8',
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
                    Text('Starting Consultation Fee (\$/hr) *', style: r14.copyWith(fontWeight: FontWeight.w600)),
                    Spacing.s8.h,
                    CustomTextFormField(
                      controller: controller.priceController,
                      keyboardType: TextInputType.number,
                      hintText: '85.0',
                      fillColor: theme.canvasColor,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Fee is required' : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacing.s16.h,

          // Sub Specialties & Languages
          Text('Focus Areas / Sub-Specialties (comma-separated)', style: r14.copyWith(fontWeight: FontWeight.w600)),
          Spacing.s8.h,
          CustomTextFormField(
            controller: controller.specialtiesController,
            hintText: 'Anxiety & Panic, CBT Therapy, Trauma Recovery, Stress',
            fillColor: theme.canvasColor,
          ),
          Spacing.s16.h,

          Text('Spoken Languages (comma-separated)', style: r14.copyWith(fontWeight: FontWeight.w600)),
          Spacing.s8.h,
          CustomTextFormField(
            controller: controller.languagesController,
            hintText: 'English, Spanish, French',
            fillColor: theme.canvasColor,
          ),
          Spacing.s16.h,

          Text('Professional Biography & Clinical Approach *', style: r14.copyWith(fontWeight: FontWeight.w600)),
          Spacing.s8.h,
          CustomTextFormField(
            controller: controller.bioController,
            maxLines: 3,
            hintText: 'Describe your clinical background, philosophy, and specializations...',
            fillColor: theme.canvasColor,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Biography is required' : null,
          ),
        ],
      ),
    );
  }

  // --- Step 2: Educational & Professional Credentials ---
  Widget buildStep2Credentials(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: controller.step2FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 2: Medical Credentials & Licensing',
            style: h2.copyWith(fontWeight: FontWeight.w700),
          ),
          Spacing.s4.h,
          Text(
            'Enter your verified university, medical license, and clinical certifications.',
            style: r14.copyWith(color: theme.textTheme.bodySmall?.color),
          ),
          Spacing.s20.h,

          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Medical / Clinical Degree *', style: r14.copyWith(fontWeight: FontWeight.w600)),
                    Spacing.s8.h,
                    CustomTextFormField(
                      controller: controller.degreeController,
                      hintText: 'e.g. Ph.D. in Clinical Psychology / M.D.',
                      fillColor: theme.canvasColor,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Degree is required' : null,
                    ),
                  ],
                ),
              ),
              Spacing.s12.w,
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Graduation Year', style: r14.copyWith(fontWeight: FontWeight.w600)),
                    Spacing.s8.h,
                    CustomTextFormField(
                      controller: controller.gradYearController,
                      keyboardType: TextInputType.number,
                      hintText: '2016',
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
                    Text('University / Medical Institution *', style: r14.copyWith(fontWeight: FontWeight.w600)),
                    Spacing.s8.h,
                    CustomTextFormField(
                      controller: controller.universityController,
                      hintText: 'e.g. Columbia University Medical Center',
                      fillColor: theme.canvasColor,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'University is required' : null,
                    ),
                  ],
                ),
              ),
              Spacing.s12.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Medical License Number *', style: r14.copyWith(fontWeight: FontWeight.w600)),
                    Spacing.s8.h,
                    CustomTextFormField(
                      controller: controller.licenseController,
                      hintText: 'e.g. PSY-NY-849201',
                      fillColor: theme.canvasColor,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'License is required' : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacing.s16.h,

          Text('Board Certifications & Fellowships (comma-separated)', style: r14.copyWith(fontWeight: FontWeight.w600)),
          Spacing.s8.h,
          CustomTextFormField(
            controller: controller.certificationsController,
            hintText: 'American Board of Professional Psychology, Beck Institute CBT Certified',
            fillColor: theme.canvasColor,
          ),
        ],
      ),
    );
  }

  // --- Step 3: Availability & Consultation Modalities ---
  Widget buildStep3Availability(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: controller.step3FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 3: Availability & Modalities',
            style: h2.copyWith(fontWeight: FontWeight.w700),
          ),
          Spacing.s4.h,
          Text(
            'Configure your active consultation days, working hours, and telehealth modalities.',
            style: r14.copyWith(color: theme.textTheme.bodySmall?.color),
          ),
          Spacing.s20.h,

          // Modality Toggles
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('HD Video Consultations'),
                    subtitle: const Text('Enable secure 1-on-1 video telehealth'),
                    value: controller.videoCallFeature.value,
                    activeTrackColor: primary,
                    activeThumbColor: primary,
                    onChanged: (v) => controller.videoCallFeature.value = v,
                  ),
                ),
              ),
              Expanded(
                child: Obx(
                  () => SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Voice / Audio Calls'),
                    subtitle: const Text('Enable encrypted voice consultations'),
                    value: controller.callFeature.value,
                    activeTrackColor: primary,
                    activeThumbColor: primary,
                    onChanged: (v) => controller.callFeature.value = v,
                  ),
                ),
              ),
            ],
          ),
          Spacing.s16.h,

          // Weekly Available Days
          Text('Available Days of the Week', style: r14.copyWith(fontWeight: FontWeight.w600)),
          Spacing.s8.h,
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.allDaysOfWeek.map((day) {
                final isSelected = controller.selectedDays.contains(day);
                return FilterChip(
                  label: Text(day, style: r12),
                  selected: isSelected,
                  selectedColor: primary.withValues(alpha: 0.2),
                  checkmarkColor: primary,
                  onSelected: (_) => controller.toggleDay(day),
                );
              }).toList(),
            ),
          ),
          Spacing.s16.h,

          // Available Shifts
          Text('Available Consultation Shifts', style: r14.copyWith(fontWeight: FontWeight.w600)),
          Spacing.s8.h,
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.allShifts.map((shift) {
                final isSelected = controller.selectedShifts.contains(shift);
                return FilterChip(
                  label: Text(shift, style: r12),
                  selected: isSelected,
                  selectedColor: infoColor.withValues(alpha: 0.2),
                  checkmarkColor: infoColor,
                  onSelected: (_) => controller.toggleShift(shift),
                );
              }).toList(),
            ),
          ),
          Spacing.s16.h,

          // Session Durations
          Text('Supported Consultation Durations', style: r14.copyWith(fontWeight: FontWeight.w600)),
          Spacing.s8.h,
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.allDurations.map((d) {
                final isSelected = controller.selectedDurations.contains(d);
                return FilterChip(
                  label: Text('$d Minutes', style: r12),
                  selected: isSelected,
                  selectedColor: primary.withValues(alpha: 0.2),
                  checkmarkColor: primary,
                  onSelected: (_) => controller.toggleDuration(d),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // --- Step 4: Verification & Live Preview ---
  Widget buildStep4Preview(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step 4: Clinical Profile Verification',
          style: h2.copyWith(fontWeight: FontWeight.w700),
        ),
        Spacing.s4.h,
        Text(
          'Review how your profile and credentials will be presented to patients on Mentora.',
          style: r14.copyWith(color: theme.textTheme.bodySmall?.color),
        ),
        Spacing.s20.h,

        // Profile Preview Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF161715) : const Color(0xFFF9FAF7),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: primary.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50.r),
                    child: CachedNetworkImage(
                      imageUrl: controller.imageController.text,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => const CircleAvatar(radius: 30, child: Icon(Icons.person)),
                    ),
                  ),
                  Spacing.s16.w,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                controller.nameController.text,
                                style: h3.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            Spacing.s8.w,
                            DoctorBadge(text: 'VERIFIED', color: primary),
                          ],
                        ),
                        Spacing.s4.h,
                        Text(
                          '${controller.selectedSpeciality.value} • ${controller.experienceController.text} Years Exp',
                          style: r12.copyWith(color: primary, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${controller.degreeController.text} • ${controller.universityController.text}',
                          style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacing.s16.h,
              Text(
                controller.bioController.text,
                style: r14.copyWith(color: theme.textTheme.bodyMedium?.color),
              ),
              Spacing.s16.h,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rate: \$${controller.priceController.text}/hr',
                    style: h3.copyWith(fontWeight: FontWeight.w700, color: primary),
                  ),
                  Text(
                    'License: ${controller.licenseController.text}',
                    style: r12.copyWith(color: theme.textTheme.bodySmall?.color, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
        Spacing.s20.h,

        // Verification Acknowledgement
        Row(
          children: [
            Icon(Icons.verified_user_rounded, color: primary, size: 20),
            Spacing.s8.w,
            Expanded(
              child: Text(
                'By completing registration, I certify that all clinical licenses and educational credentials provided are authentic and in good standing.',
                style: r12.copyWith(color: theme.textTheme.bodyMedium?.color),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildStepperButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (controller.currentStep.value > 0)
          OutlinedButton.icon(
            onPressed: controller.prevStep,
            icon: const Icon(Icons.arrow_back_rounded, size: 16),
            label: const Text('Back'),
          )
        else
          const SizedBox(),
        if (controller.currentStep.value < 3)
          CustomPrimaryButton(
            text: 'Continue',
            backgroundColor: primary,
            onPressed: controller.nextStep,
            prefixIcon: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
          )
        else
          Obx(
            () => CustomPrimaryButton(
              text: 'Complete Registration & Open Portal',
              isLoading: controller.isLoading.value,
              backgroundColor: primary,
              onPressed: controller.submitRegistration,
              prefixIcon: const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 18),
            ),
          ),
      ],
    );
  }

  Widget buildFooterLinks(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already registered as a Mentora Doctor? ',
          style: r14.copyWith(color: theme.textTheme.bodyMedium?.color),
        ),
        InkWell(
          onTap: () => Get.toNamed(Routes.LOGIN_DOCTOR),
          child: Text(
            'Sign In',
            style: r14.copyWith(color: primary, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
