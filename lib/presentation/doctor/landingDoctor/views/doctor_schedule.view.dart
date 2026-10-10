import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/enums/snackbar_enum.dart';
import 'package:Mentora/data/utils/app_utils.dart';
import 'package:Mentora/infrastructure/dal/services/doctor_portal_service.dart';
import 'package:Mentora/infrastructure/theme/app_scale.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/doctor/widgets/doctor_section_header.widget.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import '../controllers/landing_doctor.controller.dart';

class DoctorScheduleView extends StatefulWidget {
  const DoctorScheduleView({super.key});

  @override
  State<DoctorScheduleView> createState() => _DoctorScheduleViewState();
}

class _DoctorScheduleViewState extends State<DoctorScheduleView> {
  final _landingCtrl = Get.find<LandingDoctorController>();

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  late Set<String> _activeDays;
  late String _startHour;
  late String _endHour;
  late Set<String> _shifts;
  late Set<int> _durations;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = _landingCtrl.doctorProfile.value;
    _activeDays = Set.from(profile?.availableDays ?? ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']);
    _startHour = profile?.workingHoursStart ?? '09:00 AM';
    _endHour = profile?.workingHoursEnd ?? '06:00 PM';
    _shifts = Set.from(profile?.availableShifts ?? ['Morning', 'Afternoon', 'Evening']);
    _durations = Set.from(profile?.sessionDurations ?? [15, 30, 45, 60]);
  }

  Future<void> _saveSchedule() async {
    setState(() => _isSaving = true);
    final profile = _landingCtrl.doctorProfile.value;
    if (profile != null) {
      final updated = profile.copyWith(
        availableDays: _activeDays.toList(),
        workingHoursStart: _startHour,
        workingHoursEnd: _endHour,
        availableShifts: _shifts.toList(),
        sessionDurations: _durations.toList(),
      );
      await DoctorPortalService.saveCurrentDoctorProfile(updated);
      _landingCtrl.doctorProfile.value = updated;
      AppUtils.snackbar('Saved', 'Consultation availability updated successfully', SnackBarType.SUCCESS);
    }
    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
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
          DoctorSectionHeader(
            title: 'Schedule & Telehealth Availability',
            subtitle: 'Configure weekly consultation hours, shifts, and open booking slots for patients.',
            buttonText: 'Save Schedule',
            buttonIcon: '\u{f0c7}', // save
            onButtonPressed: _saveSchedule,
          ),
          CustomPrimaryCard(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Weekly Practice Days', style: h3.copyWith(fontWeight: FontWeight.w700)),
                  Spacing.s4.h,
                  Text(
                    'Select the days patients are permitted to book consultations.',
                    style: r14.copyWith(color: theme.textTheme.bodySmall?.color),
                  ),
                  Spacing.s16.h,
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _days.map((day) {
                      final isSelected = _activeDays.contains(day);
                      return FilterChip(
                        label: Text(day),
                        selected: isSelected,
                        selectedColor: primary.withValues(alpha: 0.2),
                        checkmarkColor: primary,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _activeDays.add(day);
                            } else if (_activeDays.length > 1) {
                              _activeDays.remove(day);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  Spacing.s24.h,

                  Text('Consultation Working Hours', style: h3.copyWith(fontWeight: FontWeight.w700)),
                  Spacing.s12.h,
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF222320) : slate[50],
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: isDark ? slate[700]! : slate[300]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Daily Start Time', style: r10.copyWith(color: theme.textTheme.bodySmall?.color)),
                              Spacing.s4.h,
                              Text(_startHour, style: r16.copyWith(fontWeight: FontWeight.w700, color: primary)),
                            ],
                          ),
                        ),
                      ),
                      Spacing.s16.w,
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF222320) : slate[50],
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: isDark ? slate[700]! : slate[300]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Daily End Time', style: r10.copyWith(color: theme.textTheme.bodySmall?.color)),
                              Spacing.s4.h,
                              Text(_endHour, style: r16.copyWith(fontWeight: FontWeight.w700, color: primary)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacing.s24.h,

                  Text('Active Shifts & Consultation Durations', style: h3.copyWith(fontWeight: FontWeight.w700)),
                  Spacing.s12.h,
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [15, 30, 45, 60].map((d) {
                      final isSelected = _durations.contains(d);
                      return FilterChip(
                        label: Text('$d Minutes'),
                        selected: isSelected,
                        selectedColor: primary.withValues(alpha: 0.2),
                        checkmarkColor: primary,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _durations.add(d);
                            } else if (_durations.length > 1) {
                              _durations.remove(d);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  Spacing.s24.h,

                  CustomPrimaryButton(
                    text: 'Save Availability Settings',
                    isLoading: _isSaving,
                    backgroundColor: primary,
                    onPressed: _saveSchedule,
                    prefixIcon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
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

