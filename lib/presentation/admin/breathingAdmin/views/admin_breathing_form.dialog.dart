import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/model/breathing_pattern.model.dart';
import 'package:Mentora/infrastructure/theme/app_scale.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import '../controllers/admin_breathing.controller.dart';

class AdminBreathingFormDialog extends StatefulWidget {
  final BreathingPatternModel? pattern;

  const AdminBreathingFormDialog({super.key, this.pattern});

  static Future<bool?> show({
    required BuildContext context,
    BreathingPatternModel? pattern,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AdminBreathingFormDialog(pattern: pattern),
    );
  }

  @override
  State<AdminBreathingFormDialog> createState() =>
      _AdminBreathingFormDialogState();
}

class _AdminBreathingFormDialogState extends State<AdminBreathingFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<AdminBreathingController>();

  late final TextEditingController _nameController;
  late final TextEditingController _iconController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _inhaleController;
  late final TextEditingController _holdInController;
  late final TextEditingController _exhaleController;
  late final TextEditingController _holdOutController;
  late final TextEditingController _cyclesController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final p = widget.pattern;
    _nameController = TextEditingController(text: p?.name ?? '');
    _iconController = TextEditingController(text: p?.icon ?? '🌬️');
    _descriptionController = TextEditingController(
      text:
          p?.description ??
          'A balanced pranayama breathwork pattern to induce mental clarity and physical relaxation.',
    );
    _inhaleController = TextEditingController(
      text: (p?.inhale ?? 4).toString(),
    );
    _holdInController = TextEditingController(
      text: (p?.holdIn ?? 4).toString(),
    );
    _exhaleController = TextEditingController(
      text: (p?.exhale ?? 4).toString(),
    );
    _holdOutController = TextEditingController(
      text: (p?.holdOut ?? 4).toString(),
    );
    _cyclesController = TextEditingController(text: '4');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _iconController.dispose();
    _descriptionController.dispose();
    _inhaleController.dispose();
    _holdInController.dispose();
    _exhaleController.dispose();
    _holdOutController.dispose();
    _cyclesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final inhale = int.tryParse(_inhaleController.text.trim()) ?? 4;
    final holdIn = int.tryParse(_holdInController.text.trim()) ?? 0;
    final exhale = int.tryParse(_exhaleController.text.trim()) ?? 4;
    final holdOut = int.tryParse(_holdOutController.text.trim()) ?? 0;

    bool success;
    if (widget.pattern != null) {
      success = await _controller.updatePattern(
        id: widget.pattern!.id ?? 0,
        name: _nameController.text.trim(),
        icon: _iconController.text.trim(),
        description: _descriptionController.text.trim(),
        inhale: inhale,
        holdIn: holdIn,
        exhale: exhale,
        holdOut: holdOut,
      );
    } else {
      success = await _controller.createPattern(
        name: _nameController.text.trim(),
        icon: _iconController.text.trim(),
        description: _descriptionController.text.trim(),
        inhale: inhale,
        holdIn: holdIn,
        exhale: exhale,
        holdOut: holdOut,
      );
    }

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.of(context, rootNavigator: true).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEditing = widget.pattern != null;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1E1F1D) : white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppScale.pagePaddingHorizontal(),
        vertical: 20,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppScale.dialogMaxWidth(500),
          maxHeight: MediaQuery.of(context).size.height * 0.90,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        isEditing
                            ? 'Edit Breathing Technique'
                            : 'Add Breathing Technique',
                        style: h3.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.textTheme.headlineLarge?.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                Spacing.s16.h,
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 80,
                              child: _buildTextField(
                                label: 'Icon *',
                                controller: _iconController,
                                hint: '📦',
                                validator: (v) =>
                                    v == null || v.isEmpty ? 'Req' : null,
                              ),
                            ),
                            Spacing.s12.w,
                            Expanded(
                              child: _buildTextField(
                                label: 'Technique Name *',
                                controller: _nameController,
                                hint: 'e.g. Box Breathing, 4-7-8 Relax',
                                validator: (v) =>
                                    v == null || v.isEmpty ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),
                        Spacing.s16.h,
                        Text(
                          'Cycle Phase Timings (Seconds)',
                          style: r12.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                        Spacing.s8.h,
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                label: 'Inhale (s)',
                                controller: _inhaleController,
                                keyboardType: TextInputType.number,
                                validator: (v) =>
                                    v == null || v.isEmpty ? 'Req' : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildTextField(
                                label: 'Hold In (s)',
                                controller: _holdInController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildTextField(
                                label: 'Exhale (s)',
                                controller: _exhaleController,
                                keyboardType: TextInputType.number,
                                validator: (v) =>
                                    v == null || v.isEmpty ? 'Req' : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildTextField(
                                label: 'Hold Out (s)',
                                controller: _holdOutController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        Spacing.s12.h,
                        _buildTextField(
                          label: 'Default Suggested Cycles',
                          controller: _cyclesController,
                          hint: '4',
                          keyboardType: TextInputType.number,
                        ),
                        Spacing.s12.h,
                        _buildTextField(
                          label: 'Description & Health Benefits',
                          controller: _descriptionController,
                          hint:
                              'Instructions and calming physiological benefits...',
                          maxLines: 3,
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
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: r14.copyWith(
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                    Spacing.s12.w,
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              isEditing ? 'Save Changes' : 'Create Technique',
                              style: r14.copyWith(
                                color: white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: r12.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
        Spacing.s4.h,
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: r14.copyWith(color: theme.textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: r14.copyWith(color: slate[400]),
            filled: true,
            fillColor: isDark
                ? const Color(0xFF282926)
                : const Color(0xFFF9FAF7),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : slate[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : slate[200]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
