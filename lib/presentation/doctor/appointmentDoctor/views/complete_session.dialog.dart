import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/enums/snackbar_enum.dart';
import 'package:Mentora/data/model/doctor_appointment.model.dart';
import 'package:Mentora/data/utils/app_utils.dart';
import 'package:Mentora/infrastructure/dal/services/doctor_portal_service.dart';
import 'package:Mentora/infrastructure/theme/app_scale.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:Mentora/widgets/fields/custom_textfield.widget.dart';
import '../controllers/appointment_doctor.controller.dart';

class CompleteSessionDialog extends StatefulWidget {
  final DoctorAppointmentModel appointment;
  final String? initialNotes;
  final int? elapsedDurationMinutes;

  const CompleteSessionDialog({
    super.key,
    required this.appointment,
    this.initialNotes,
    this.elapsedDurationMinutes,
  });

  static Future<bool?> show({
    required BuildContext context,
    required DoctorAppointmentModel appointment,
    String? initialNotes,
    int? elapsedDurationMinutes,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => CompleteSessionDialog(
        appointment: appointment,
        initialNotes: initialNotes,
        elapsedDurationMinutes: elapsedDurationMinutes,
      ),
    );
  }

  @override
  State<CompleteSessionDialog> createState() => _CompleteSessionDialogState();
}

class _CompleteSessionDialogState extends State<CompleteSessionDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _clinicalNotesController;
  late final TextEditingController _prescriptionsController;
  late final TextEditingController _durationController;

  String _selectedFollowUp = '1 Week';
  final List<String> _followUpOptions = [
    'No Follow-up Needed',
    '3 Days',
    '1 Week',
    '2 Weeks',
    '1 Month',
  ];

  final List<String> _recommendedTools = [
    'Box Breathing (4x4)',
    'Cognitive Restructuring',
    'Sleep Soundscape (Rain & Binaural)',
    'Daily Thought Journal',
    'Mindful Body Scan',
  ];
  final Set<String> _selectedTools = {'Box Breathing (4x4)', 'Daily Thought Journal'};

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _clinicalNotesController = TextEditingController(
      text: widget.initialNotes ??
          widget.appointment.clinicalNotes ??
          'Patient engaged in structured therapeutic discussion regarding acute stressors. Practiced grounding techniques and established clear mindfulness coping mechanisms for daily triggers.',
    );
    _prescriptionsController = TextEditingController(
      text: widget.appointment.prescription ??
          'Practice 10 minutes of box breathing twice daily. Complete morning thought journaling before work routines.',
    );
    _durationController = TextEditingController(
      text: (widget.elapsedDurationMinutes ?? widget.appointment.duration).toString(),
    );
  }

  @override
  void dispose() {
    _clinicalNotesController.dispose();
    _prescriptionsController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final combinedPrescription = [
        _prescriptionsController.text.trim(),
        if (_selectedTools.isNotEmpty)
          'Assigned App Tools: ${_selectedTools.join(', ')}',
        if (_selectedFollowUp != 'No Follow-up Needed')
          'Recommended Next Visit: $_selectedFollowUp',
      ].where((s) => s.isNotEmpty).join('\n• ');

      final success = await DoctorPortalService.completeAppointment(
        appointmentId: widget.appointment.id,
        clinicalNotes: _clinicalNotesController.text.trim(),
        prescription: combinedPrescription,
        actualDuration: int.tryParse(_durationController.text.trim()),
      );

      if (success) {
        AppUtils.snackbar(
          'Session Completed',
          'Consultation notes and recommendations saved successfully.',
          SnackBarType.SUCCESS,
        );

        if (Get.isRegistered<AppointmentDoctorController>()) {
          Get.find<AppointmentDoctorController>().fetchAppointments();
        }

        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } else {
        AppUtils.snackbar('Error', 'Failed to complete session', SnackBarType.ERROR);
      }
    } catch (e) {
      Get.log('Error completing session: $e');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1E1F1D) : white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppScale.pagePaddingHorizontal(),
        vertical: 20,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: successColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(Icons.verified_outlined, color: successColor, size: 24),
                    ),
                    Spacing.s12.w,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Complete Consultation',
                            style: h2.copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'Patient: ${widget.appointment.patientName} (#${widget.appointment.id})',
                            style: r14.copyWith(color: theme.textTheme.bodySmall?.color),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Spacing.s16.h,
                Divider(
                  color: isDark ? Colors.white.withValues(alpha: 0.08) : slate[200]!,
                  height: 1,
                ),
                Spacing.s16.h,

                // Body Form
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Duration Field
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Actual Duration (Minutes)',
                                    style: r14.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  Spacing.s8.h,
                                  CustomTextFormField(
                                    controller: _durationController,
                                    keyboardType: TextInputType.number,
                                    fillColor: theme.canvasColor,
                                    prefixIcon: const Icon(Icons.timer_outlined, size: 18),
                                  ),
                                ],
                              ),
                            ),
                            Spacing.s12.w,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Recommended Follow-up',
                                    style: r14.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  Spacing.s8.h,
                                  Container(
                                    height: 48,
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: theme.canvasColor,
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: isDark ? slate[700]! : slate[300]!,
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedFollowUp,
                                        isExpanded: true,
                                        items: _followUpOptions.map((opt) {
                                          return DropdownMenuItem(
                                            value: opt,
                                            child: Text(opt, style: r14),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          if (val != null) setState(() => _selectedFollowUp = val);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Spacing.s16.h,
                        Text(
                          'Doctor Clinical Summary & Observations *',
                          style: r14.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Spacing.s8.h,
                        CustomTextFormField(
                          controller: _clinicalNotesController,
                          maxLines: 4,
                          hintText: 'Record patient mental state, diagnosis, therapy notes...',
                          fillColor: theme.canvasColor,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Clinical notes are required';
                            }
                            return null;
                          },
                        ),

                        Spacing.s16.h,
                        Text(
                          'Care Plan & Self-Care Guidance',
                          style: r14.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Spacing.s8.h,
                        CustomTextFormField(
                          controller: _prescriptionsController,
                          maxLines: 3,
                          hintText: 'Prescribe exercises, homework, or lifestyle advice...',
                          fillColor: theme.canvasColor,
                        ),

                        Spacing.s16.h,
                        Text(
                          'Assign In-App Wellness Tools',
                          style: r14.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Spacing.s8.h,
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _recommendedTools.map((tool) {
                            final isSelected = _selectedTools.contains(tool);
                            return FilterChip(
                              label: Text(tool, style: r12),
                              selected: isSelected,
                              selectedColor: primary.withValues(alpha: 0.2),
                              checkmarkColor: primary,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedTools.add(tool);
                                  } else {
                                    _selectedTools.remove(tool);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                Spacing.s16.h,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: r14.copyWith(color: theme.textTheme.bodyMedium?.color),
                      ),
                    ),
                    Spacing.s12.w,
                    CustomPrimaryButton(
                      text: 'Submit & Finalize Session',
                      isLoading: _isSubmitting,
                      onPressed: _submit,
                      backgroundColor: primary,
                      prefixIcon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
