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

  Color getFieldFillColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF141612) : const Color(0xFFF6F8F3);
  }

  Color getFieldBorderColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF2C3127) : const Color(0xFFDCE2D6);
  }

  Color getCardBgColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF1B1D19) : Colors.white;
  }

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
            constraints: const BoxConstraints(maxWidth: 820),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildTopBar(context),
                  Spacing.s16.h,
                  buildHeroHeader(context),
                  Spacing.s24.h,
                  buildClinicalIdentityCard(context),
                  Spacing.s20.h,
                  buildCredentialsCard(context),
                  Spacing.s20.h,
                  buildScheduleAndTelehealthCard(context),
                  Spacing.s20.h,
                  buildLivePatientPreviewCard(context),
                  Spacing.s20.h,
                  buildSubmitAndCertificationCard(context),
                  Spacing.s32.h,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Top Bar with Back Navigation ---
  Widget buildTopBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            if (Navigator.of(context).canPop()) {
              Get.back();
            } else {
              Get.offNamed(Routes.LOGIN_DOCTOR);
            }
          },
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E201B) : Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isDark ? const Color(0xFF2D3128) : slate[200]!,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_back_rounded, size: 16),
                Spacing.s8.w,
                Text(
                  'Back to Sign In',
                  style: r12.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        DoctorBadge(
          text: 'CLINICAL CREDENTIALING',
          icon: '\u{f0f0}',
          color: primary,
        ),
      ],
    );
  }

  // --- Hero Header with Mentora Branding ---
  Widget buildHeroHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1E221A), const Color(0xFF171914)]
              : [const Color(0xFFF1F6EC), const Color(0xFFFAFCF8)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: primary.withValues(alpha: isDark ? 0.25 : 0.4),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  height: 38,
                  width: 38,
                  child: Image.asset('assets/logos/logo.png', fit: BoxFit.contain),
                ),
              ),
              Spacing.s16.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mentora Specialist Network',
                      style: h1.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.textTheme.headlineLarge?.color,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Spacing.s4.h,
                    Text(
                      'Clinical Practice & Telehealth Onboarding',
                      style: r14.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacing.s16.h,
          Text(
            'Complete your medical identity, licensing credentials, and practice schedule in the sections below to start receiving patient appointments.',
            style: r14.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.85),
              height: 1.45,
            ),
          ),
          Spacing.s16.h,
          // Quick section navigation badges
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSectionIndicatorPill('1. Clinical Profile', Icons.person_rounded),
              _buildSectionIndicatorPill('2. Credentials', Icons.school_rounded),
              _buildSectionIndicatorPill('3. Telehealth & Hours', Icons.calendar_month_rounded),
              _buildSectionIndicatorPill('4. Patient Preview', Icons.visibility_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionIndicatorPill(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: primary),
          Spacing.s4.w,
          Text(
            title,
            style: r12.copyWith(color: primary, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // --- CARD 1: Clinical Profile & Identity ---
  Widget buildClinicalIdentityCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fill = getFieldFillColor(context);
    final border = getFieldBorderColor(context);

    return CustomPrimaryCard(
      color: getCardBgColor(context),
      border: Border.all(
        color: isDark ? Colors.white.withValues(alpha: 0.08) : slate[200]!,
        width: 1,
      ),
      padding: const EdgeInsets.all(24),
      borderRadius: 18.r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardSectionHeader(
            context: context,
            icon: Icons.person_pin_rounded,
            badge: 'STEP 1',
            title: 'Clinical Profile & Identity',
            subtitle: 'Provide your professional photo, clinical specialization, and consultation pricing.',
          ),
          Spacing.s20.h,

          // Avatar Row
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    Obx(
                      () => Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(44.r),
                            child: CachedNetworkImage(
                              imageUrl: controller.avatarUrl.value.isNotEmpty
                                  ? controller.avatarUrl.value
                                  : 'https://images.unsplash.com/photo-1594824813501-4895781a7047?w=500',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => const CircleAvatar(
                                radius: 40,
                                child: Icon(Icons.person, size: 40),
                              ),
                            ),
                          ),
                          if (controller.isUploadingImage.value)
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                color: Colors.black45,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                              ),
                            ),
                        ],
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
                            border: Border.all(
                              color: isDark ? const Color(0xFF1E1F1D) : Colors.white,
                              width: 2,
                            ),
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
                      Text(
                        'Professional Headshot',
                        style: r16.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Spacing.s4.h,
                      Text(
                        'Upload a high-resolution portrait in medical or clinical attire. Formats: PNG, JPG.',
                        style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                      ),
                      Spacing.s8.h,
                      OutlinedButton.icon(
                        onPressed: () => controller.pickAndUploadImage(source: ImageSource.gallery),
                        icon: const Icon(Icons.upload_file_rounded, size: 16),
                        label: const Text('Change Portrait'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Spacing.s20.h,

          // Full Name & Primary Speciality
          Row(
            children: [
              Expanded(
                child: _buildInputGroup(
                  context: context,
                  label: 'Full Name & Clinical Title *',
                  hint: 'e.g. Dr. Emily Vance, Ph.D.',
                  controller: controller.nameController,
                  prefixIcon: const Icon(Icons.badge_outlined, size: 20),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                ),
              ),
              Spacing.s16.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Primary Speciality *', style: r14.copyWith(fontWeight: FontWeight.w600)),
                    Spacing.s8.h,
                    Obx(
                      () => Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: fill,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: border, width: 1.0),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: controller.availableSpecialityNames.contains(controller.selectedSpeciality.value)
                                ? controller.selectedSpeciality.value
                                : (controller.availableSpecialityNames.isNotEmpty
                                    ? controller.availableSpecialityNames.first
                                    : null),
                            isExpanded: true,
                            dropdownColor: isDark ? const Color(0xFF1E201B) : Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            items: controller.availableSpecialityNames.map((s) {
                              return DropdownMenuItem(
                                value: s,
                                child: Text(s, style: r14.copyWith(fontWeight: FontWeight.w500)),
                              );
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

          // Consultation Hourly Rate & Years Experience
          Row(
            children: [
              Expanded(
                child: _buildInputGroup(
                  context: context,
                  label: 'Starting Consultation Fee (\$/hr) *',
                  hint: '85.0',
                  controller: controller.priceController,
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.attach_money_rounded, size: 20),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Rate is required' : null,
                ),
              ),
              Spacing.s16.w,
              Expanded(
                child: _buildInputGroup(
                  context: context,
                  label: 'Years of Experience *',
                  hint: '8',
                  controller: controller.experienceController,
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.history_edu_rounded, size: 20),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Experience is required' : null,
                ),
              ),
            ],
          ),
          Spacing.s16.h,

          // Spoken Languages & Patients Count
          Row(
            children: [
              Expanded(
                child: _buildInputGroup(
                  context: context,
                  label: 'Spoken Consultation Languages',
                  hint: 'English, Spanish',
                  controller: controller.languagesController,
                  prefixIcon: const Icon(Icons.translate_rounded, size: 20),
                ),
              ),
              Spacing.s16.w,
              Expanded(
                child: _buildInputGroup(
                  context: context,
                  label: 'Past Treated Patients (Approx)',
                  hint: '340',
                  controller: controller.patientsController,
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.people_outline_rounded, size: 20),
                ),
              ),
            ],
          ),
          Spacing.s16.h,

          // Specializations list
          _buildInputGroup(
            context: context,
            label: 'Clinical Focus & Modalities (comma separated)',
            hint: 'Anxiety & Panic, CBT Therapy, Trauma Recovery, Stress Management',
            controller: controller.specialtiesController,
            prefixIcon: const Icon(Icons.psychology_outlined, size: 20),
          ),
          Spacing.s16.h,

          // Clinical Bio
          _buildInputGroup(
            context: context,
            label: 'Clinical Bio & Therapeutic Philosophy *',
            hint: 'Describe your clinical approach, methodologies (CBT, ACT, etc.), and what patients can expect in sessions...',
            controller: controller.bioController,
            maxLines: 4,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Bio is required' : null,
          ),
        ],
      ),
    );
  }

  Widget buildCredentialsCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomPrimaryCard(
      color: getCardBgColor(context),
      border: Border.all(
        color: isDark ? Colors.white.withValues(alpha: 0.08) : slate[200]!,
        width: 1,
      ),
      padding: const EdgeInsets.all(24),
      borderRadius: 18.r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardSectionHeader(
            context: context,
            icon: Icons.school_rounded,
            badge: 'STEP 2',
            title: 'Medical Education & Board Credentials',
            subtitle: 'Provide accredited graduate degrees, medical licenses, and board certifications.',
          ),
          Spacing.s16.h,

          // Security Verification Callout
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: primary.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                Icon(Icons.verified_user_outlined, color: primary, size: 22),
                Spacing.s12.w,
                Expanded(
                  child: Text(
                    'Verification Notice: Medical licenses are validated against state licensing registries. Only verified providers receive the Mentora Verified Specialist badge.',
                    style: r12.copyWith(
                      color: theme.textTheme.bodyMedium?.color,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacing.s20.h,

          // Degree & Graduation Year
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildInputGroup(
                  context: context,
                  label: 'Medical / Graduate Degree *',
                  hint: 'e.g. Ph.D. in Clinical Psychology / M.D.',
                  controller: controller.degreeController,
                  prefixIcon: const Icon(Icons.workspace_premium_outlined, size: 20),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Degree is required' : null,
                ),
              ),
              Spacing.s16.w,
              Expanded(
                flex: 1,
                child: _buildInputGroup(
                  context: context,
                  label: 'Graduation Year *',
                  hint: '2016',
                  controller: controller.gradYearController,
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.event_available_rounded, size: 20),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Year is required' : null,
                ),
              ),
            ],
          ),
          Spacing.s16.h,

          // University / Institution
          _buildInputGroup(
            context: context,
            label: 'University / Medical Institution *',
            hint: 'e.g. Columbia University Medical Center',
            controller: controller.universityController,
            prefixIcon: const Icon(Icons.account_balance_outlined, size: 20),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'University is required' : null,
          ),
          Spacing.s16.h,

          // License Number
          _buildInputGroup(
            context: context,
            label: 'State Medical License Number *',
            hint: 'e.g. PSY-NY-849201',
            controller: controller.licenseController,
            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'License number is required' : null,
          ),
          Spacing.s16.h,

          // Board Certifications
          _buildInputGroup(
            context: context,
            label: 'Board Certifications & Fellowships',
            hint: 'American Board of Professional Psychology, Beck Institute Certified CBT Clinician',
            controller: controller.certificationsController,
            prefixIcon: const Icon(Icons.card_membership_rounded, size: 20),
          ),
        ],
      ),
    );
  }

  // --- CARD 3: Telehealth Modalities & Practice Schedule ---
  Widget buildScheduleAndTelehealthCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fill = getFieldFillColor(context);
    final border = getFieldBorderColor(context);

    return CustomPrimaryCard(
      color: getCardBgColor(context),
      border: Border.all(
        color: isDark ? Colors.white.withValues(alpha: 0.08) : slate[200]!,
        width: 1,
      ),
      padding: const EdgeInsets.all(24),
      borderRadius: 18.r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardSectionHeader(
            context: context,
            icon: Icons.calendar_month_rounded,
            badge: 'STEP 3',
            title: 'Telehealth Modalities & Practice Schedule',
            subtitle: 'Configure consultation channels, weekly active days, and practice hours.',
          ),
          Spacing.s20.h,

          // Modality Toggles (Clean Interactive Cards)
          Text('Supported Consultation Modalities', style: r14.copyWith(fontWeight: FontWeight.w600)),
          Spacing.s8.h,
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => _buildModalityToggleCard(
                    context: context,
                    icon: Icons.videocam_rounded,
                    title: 'HD Video Calls',
                    subtitle: 'Secure 1-on-1 telehealth video',
                    isActive: controller.videoCallFeature.value,
                    onToggle: (val) => controller.videoCallFeature.value = val,
                  ),
                ),
              ),
              Spacing.s16.w,
              Expanded(
                child: Obx(
                  () => _buildModalityToggleCard(
                    context: context,
                    icon: Icons.phone_in_talk_rounded,
                    title: 'Voice / Audio Calls',
                    subtitle: 'Encrypted audio sessions',
                    isActive: controller.callFeature.value,
                    onToggle: (val) => controller.callFeature.value = val,
                  ),
                ),
              ),
            ],
          ),
          Spacing.s24.h,

          // Weekly Available Days
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Available Practice Days *', style: r14.copyWith(fontWeight: FontWeight.w600)),
              Row(
                children: [
                  TextButton(
                    onPressed: controller.selectAllWeekdays,
                    child: Text('Weekdays (Mon-Fri)', style: r12.copyWith(color: primary, fontWeight: FontWeight.w600)),
                  ),
                  TextButton(
                    onPressed: controller.selectAllDays,
                    child: Text('All 7 Days', style: r12.copyWith(color: primary, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
          Spacing.s8.h,
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.allDaysOfWeek.map((day) {
                final isSelected = controller.selectedDays.contains(day);
                return FilterChip(
                  label: Text(day, style: r12.copyWith(fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
                  selected: isSelected,
                  selectedColor: primary.withValues(alpha: 0.2),
                  checkmarkColor: primary,
                  backgroundColor: fill,
                  side: BorderSide(color: isSelected ? primary : border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  onSelected: (_) => controller.toggleDay(day),
                );
              }).toList(),
            ),
          ),
          Spacing.s20.h,

          // Available Shifts & Durations
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Consultation Shifts', style: r14.copyWith(fontWeight: FontWeight.w600)),
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
                            backgroundColor: fill,
                            side: BorderSide(color: isSelected ? infoColor : border),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                            onSelected: (_) => controller.toggleShift(shift),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.s16.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Session Durations', style: r14.copyWith(fontWeight: FontWeight.w600)),
                    Spacing.s8.h,
                    Obx(
                      () => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.allDurations.map((d) {
                          final isSelected = controller.selectedDurations.contains(d);
                          return FilterChip(
                            label: Text('$d Min', style: r12),
                            selected: isSelected,
                            selectedColor: primary.withValues(alpha: 0.2),
                            checkmarkColor: primary,
                            backgroundColor: fill,
                            side: BorderSide(color: isSelected ? primary : border),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                            onSelected: (_) => controller.toggleDuration(d),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacing.s20.h,

          // Working Hours Start & End
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Working Hours Start', style: r14.copyWith(fontWeight: FontWeight.w600)),
                    Spacing.s8.h,
                    Obx(
                      () => _buildTimeDropdown(
                        context: context,
                        value: controller.workingHoursStart.value,
                        onChanged: (v) => controller.workingHoursStart.value = v,
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.s16.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Working Hours End', style: r14.copyWith(fontWeight: FontWeight.w600)),
                    Spacing.s8.h,
                    Obx(
                      () => _buildTimeDropdown(
                        context: context,
                        value: controller.workingHoursEnd.value,
                        onChanged: (v) => controller.workingHoursEnd.value = v,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModalityToggleCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isActive,
    required ValueChanged<bool> onToggle,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isActive
            ? primary.withValues(alpha: isDark ? 0.15 : 0.08)
            : getFieldFillColor(context),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isActive ? primary : getFieldBorderColor(context),
          width: isActive ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive ? primary : slate[400]!.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: isActive ? Colors.white : slate[600]),
          ),
          Spacing.s12.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: r14.copyWith(fontWeight: FontWeight.w700)),
                Text(subtitle, style: r10.copyWith(color: theme.textTheme.bodySmall?.color)),
              ],
            ),
          ),
          Switch.adaptive(
            value: isActive,
            activeThumbColor: primary,
            activeTrackColor: primary.withValues(alpha: 0.4),
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDropdown({
    required BuildContext context,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final times = [
      '07:00 AM',
      '08:00 AM',
      '09:00 AM',
      '10:00 AM',
      '11:00 AM',
      '12:00 PM',
      '01:00 PM',
      '02:00 PM',
      '03:00 PM',
      '04:00 PM',
      '05:00 PM',
      '06:00 PM',
      '07:00 PM',
      '08:00 PM',
      '09:00 PM',
    ];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: getFieldFillColor(context),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: getFieldBorderColor(context), width: 1.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: times.contains(value) ? value : times.first,
          isExpanded: true,
          dropdownColor: isDark ? const Color(0xFF1E201B) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          items: times.map((t) {
            return DropdownMenuItem(value: t, child: Text(t, style: r14));
          }).toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ),
    );
  }

  // --- CARD 4: Live Patient Profile Preview Card ---
  Widget buildLivePatientPreviewCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomPrimaryCard(
      color: getCardBgColor(context),
      border: Border.all(
        color: primary.withValues(alpha: 0.4),
        width: 1.4,
      ),
      padding: const EdgeInsets.all(24),
      borderRadius: 18.r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardSectionHeader(
            context: context,
            icon: Icons.visibility_rounded,
            badge: 'LIVE PREVIEW',
            title: 'Live Patient Profile Preview',
            subtitle: 'Real-time preview of how patients will see your profile in the Mentora directory.',
            trailing: DoctorBadge(text: 'LIVE DEMO', color: primary),
          ),
          Spacing.s20.h,

          // Reactive Patient Profile Card
          ListenableBuilder(
            listenable: Listenable.merge([
              controller.nameController,
              controller.degreeController,
              controller.universityController,
              controller.experienceController,
              controller.priceController,
              controller.bioController,
              controller.licenseController,
              controller.languagesController,
            ]),
            builder: (context, _) {
              return Obx(() {
                final name = controller.nameController.text.trim().isNotEmpty
                    ? controller.nameController.text.trim()
                    : 'Dr. Specialist Name';
                final speciality = controller.selectedSpeciality.value;
                final exp = controller.experienceController.text.trim().isNotEmpty
                    ? controller.experienceController.text.trim()
                    : '8';
                final degree = controller.degreeController.text.trim().isNotEmpty
                    ? controller.degreeController.text.trim()
                    : 'Clinical Degree';
                final uni = controller.universityController.text.trim().isNotEmpty
                    ? controller.universityController.text.trim()
                    : 'Accredited Institution';
                final price = controller.priceController.text.trim().isNotEmpty
                    ? controller.priceController.text.trim()
                    : '85';
                final bio = controller.bioController.text.trim().isNotEmpty
                    ? controller.bioController.text.trim()
                    : 'Clinical psychologist with evidence-based cognitive therapy and trauma relief focus.';

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF131512) : const Color(0xFFF7FAF4),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isDark ? const Color(0xFF2C3127) : const Color(0xFFE0E7DA),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(35.r),
                            child: CachedNetworkImage(
                              imageUrl: controller.avatarUrl.value.isNotEmpty
                                  ? controller.avatarUrl.value
                                  : 'https://images.unsplash.com/photo-1594824813501-4895781a7047?w=500',
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => const CircleAvatar(radius: 35, child: Icon(Icons.person)),
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
                                        name,
                                        style: h2.copyWith(fontWeight: FontWeight.w700),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Spacing.s8.w,
                                    DoctorBadge(text: 'VERIFIED', color: primary),
                                  ],
                                ),
                                Spacing.s4.h,
                                Text(
                                  '$speciality • $exp Years Exp',
                                  style: r14.copyWith(color: primary, fontWeight: FontWeight.w600),
                                ),
                                Spacing.s4.h,
                                Text(
                                  '$degree • $uni',
                                  style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                                ),
                                Spacing.s8.h,
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                                    Spacing.s4.w,
                                    Text('4.95', style: r12.copyWith(fontWeight: FontWeight.w700)),
                                    Spacing.s4.w,
                                    Text('(95 patient reviews)', style: r12.copyWith(color: theme.textTheme.bodySmall?.color)),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: primary.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(20.r),
                                      ),
                                      child: Text(
                                        '\$$price / hr',
                                        style: r14.copyWith(color: primary, fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Spacing.s16.h,
                      Text(
                        bio,
                        style: r12.copyWith(
                          color: theme.textTheme.bodyMedium?.color,
                          height: 1.45,
                        ),
                      ),
                      Spacing.s16.h,
                      // Modality badges & schedule preview
                      Row(
                        children: [
                          if (controller.videoCallFeature.value) ...[
                            _buildPreviewBadge(Icons.videocam_rounded, 'HD Video'),
                            Spacing.s8.w,
                          ],
                          if (controller.callFeature.value) ...[
                            _buildPreviewBadge(Icons.phone_in_talk_rounded, 'Voice Call'),
                            Spacing.s8.w,
                          ],
                          _buildPreviewBadge(Icons.event_available_rounded, '${controller.selectedDays.length} Days/wk'),
                          const Spacer(),
                          Text(
                            'Hours: ${controller.workingHoursStart.value} - ${controller.workingHoursEnd.value}',
                            style: r10.copyWith(color: theme.textTheme.bodySmall?.color, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: primary),
          Spacing.s4.w,
          Text(
            text,
            style: r10.copyWith(color: primary, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  // --- CARD 5: Certification & Submit Application ---
  Widget buildSubmitAndCertificationCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomPrimaryCard(
      color: getCardBgColor(context),
      border: Border.all(
        color: isDark ? Colors.white.withValues(alpha: 0.08) : slate[200]!,
        width: 1,
      ),
      padding: const EdgeInsets.all(24),
      borderRadius: 18.r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Certification Checkbox
          Obx(
            () => InkWell(
              onTap: () => controller.certifiedCredentials.value = !controller.certifiedCredentials.value,
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: controller.certifiedCredentials.value
                      ? primary.withValues(alpha: isDark ? 0.12 : 0.06)
                      : getFieldFillColor(context),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: controller.certifiedCredentials.value
                        ? primary
                        : getFieldBorderColor(context),
                  ),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: controller.certifiedCredentials.value,
                      activeColor: primary,
                      onChanged: (val) {
                        if (val != null) controller.certifiedCredentials.value = val;
                      },
                    ),
                    Spacing.s8.w,
                    Expanded(
                      child: Text(
                        'I formally certify that all medical licenses, credentials, and practice history submitted in this application are authentic, active, and compliant with relevant medical authorities.',
                        style: r12.copyWith(
                          color: theme.textTheme.bodyMedium?.color,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Spacing.s20.h,

          // Submit Primary Button
          Obx(
            () => CustomPrimaryButton(
              text: 'Complete Registration & Open Doctor Portal',
              isLoading: controller.isLoading.value,
              backgroundColor: primary,
              height: 52,
              borderRadius: 14.r,
              onPressed: controller.submitRegistration,
              prefixIcon: const Icon(
                Icons.verified_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          Spacing.s16.h,

          // Footer Link to Sign In
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already registered as a Mentora Specialist? ',
                style: r14.copyWith(color: theme.textTheme.bodyMedium?.color),
              ),
              InkWell(
                onTap: () => Get.offNamed(Routes.LOGIN_DOCTOR),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    'Sign In',
                    style: r14.copyWith(
                      color: primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Helper: Section Header within Cards ---
  Widget _buildCardSectionHeader({
    required BuildContext context,
    required IconData icon,
    required String badge,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: primary, size: 22),
        ),
        Spacing.s12.w,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: h3.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Spacing.s8.w,
                  DoctorBadge(text: badge, color: primary),
                ],
              ),
              Spacing.s4.h,
              Text(
                subtitle,
                style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[
          Spacing.s8.w,
          trailing,
        ],
      ],
    );
  }

  // --- Helper: Input Group with High-Contrast Theming ---
  Widget _buildInputGroup({
    required BuildContext context,
    required String label,
    required String hint,
    required TextEditingController controller,
    Widget? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    FormFieldValidator<String>? validator,
  }) {
    final fill = getFieldFillColor(context);
    final border = getFieldBorderColor(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: r14.copyWith(fontWeight: FontWeight.w600),
        ),
        Spacing.s8.h,
        CustomTextFormField(
          controller: controller,
          hintText: hint,
          keyboardType: keyboardType,
          maxLines: maxLines,
          fillColor: fill,
          borderColor: border,
          borderWidth: 1.0,
          focusedBorderColor: primary,
          prefixIcon: prefixIcon,
          validator: validator,
        ),
      ],
    );
  }
}
