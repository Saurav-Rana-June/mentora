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

class CancelSessionDialog extends StatefulWidget {
  final DoctorAppointmentModel appointment;

  const CancelSessionDialog({super.key, required this.appointment});

  static Future<bool?> show({
    required BuildContext context,
    required DoctorAppointmentModel appointment,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => CancelSessionDialog(appointment: appointment),
    );
  }

  @override
  State<CancelSessionDialog> createState() => _CancelSessionDialogState();
}

class _CancelSessionDialogState extends State<CancelSessionDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _notesController = TextEditingController();

  String _selectedReason = 'Doctor Emergency / Hospital Duty';
  final List<String> _reasons = [
    'Doctor Emergency / Hospital Duty',
    'Unforeseen Clinical Conflict',
    'Technical / Telehealth Connection Failure',
    'Patient Requested Reschedule',
    'Illness / Medical Leave',
    'Other Special Circumstances',
  ];

  bool _isSubmitting = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final success = await DoctorPortalService.cancelAppointment(
        appointmentId: widget.appointment.id,
        reason: _selectedReason,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
      );

      if (success) {
        AppUtils.snackbar(
          'Appointment Cancelled',
          'The session was cancelled and patient was notified.',
          SnackBarType.INFO,
        );

        if (Get.isRegistered<AppointmentDoctorController>()) {
          Get.find<AppointmentDoctorController>().fetchAppointments();
        }

        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } else {
        AppUtils.snackbar('Error', 'Failed to cancel appointment', SnackBarType.ERROR);
      }
    } catch (e) {
      Get.log('Error cancelling session: $e');
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
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: dangerColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(Icons.cancel_outlined, color: dangerColor, size: 24),
                    ),
                    Spacing.s12.w,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cancel Appointment',
                            style: h3.copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'With ${widget.appointment.patientName} (${widget.appointment.bookingDate} • ${widget.appointment.bookingTimeslot})',
                            style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Spacing.s16.h,
                Text(
                  'Please select a primary reason for cancellation. A courtesy notification will be sent to the patient.',
                  style: r14.copyWith(color: theme.textTheme.bodyMedium?.color),
                ),
                Spacing.s16.h,

                // Reason Radio Group
                Container(
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
                      value: _selectedReason,
                      isExpanded: true,
                      items: _reasons.map((r) {
                        return DropdownMenuItem(
                          value: r,
                          child: Text(r, style: r14),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedReason = val);
                      },
                    ),
                  ),
                ),
                Spacing.s16.h,

                // Optional Note
                Text(
                  'Additional Notes for Patient (Optional)',
                  style: r14.copyWith(fontWeight: FontWeight.w600),
                ),
                Spacing.s8.h,
                CustomTextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  hintText: 'e.g., Doctor is called in for emergency consultation. Please choose an alternate slot.',
                  fillColor: theme.canvasColor,
                ),

                Spacing.s20.h,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Keep Appointment',
                        style: r14.copyWith(color: theme.textTheme.bodyMedium?.color),
                      ),
                    ),
                    Spacing.s12.w,
                    CustomPrimaryButton(
                      text: 'Confirm Cancellation',
                      isLoading: _isSubmitting,
                      onPressed: _submit,
                      backgroundColor: dangerColor,
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
