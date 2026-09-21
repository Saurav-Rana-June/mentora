import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/model/breathing_pattern.model.dart';
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
  State<AdminBreathingFormDialog> createState() => _AdminBreathingFormDialogState();
}

class _AdminBreathingFormDialogState extends State<AdminBreathingFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<AdminBreathingController>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _iconController;
  late final TextEditingController _inhaleController;
  late final TextEditingController _holdInController;
  late final TextEditingController _exhaleController;
  late final TextEditingController _holdOutController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final p = widget.pattern;
    _nameController = TextEditingController(text: p?.name ?? '');
    _descriptionController = TextEditingController(
      text: p?.description ?? 'Relieve stress, clear your mind, and improve focus under pressure.',
    );
    _iconController = TextEditingController(text: p?.icon ?? '📦');
    _inhaleController = TextEditingController(text: (p?.inhale ?? 4).toString());
    _holdInController = TextEditingController(text: (p?.holdIn ?? 4).toString());
    _exhaleController = TextEditingController(text: (p?.exhale ?? 4).toString());
    _holdOutController = TextEditingController(text: (p?.holdOut ?? 4).toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _iconController.dispose();
    _inhaleController.dispose();
    _holdInController.dispose();
    _exhaleController.dispose();
    _holdOutController.dispose();
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
        description: _descriptionController.text.trim(),
        inhale: inhale,
        holdIn: holdIn,
        exhale: exhale,
        holdOut: holdOut,
        icon: _iconController.text.trim(),
      );
    } else {
      success = await _controller.createPattern(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        inhale: inhale,
        holdIn: holdIn,
        exhale: exhale,
        holdOut: holdOut,
        icon: _iconController.text.trim(),
      );
    }

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) Get.back(result: true);
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
      child: Container(
        width: 500.w,
        constraints: BoxConstraints(maxHeight: Get.height * 0.85),
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? 'Edit Breathing Technique' : 'Add Breathing Technique',
                    style: h3.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.textTheme.headlineLarge?.color,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
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
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 80.w,
                            child: _buildTextField(
                              label: 'Icon *',
                              controller: _iconController,
                              hint: '📦',
                              validator: (v) => v == null || v.isEmpty ? 'Req' : null,
                            ),
                          ),
                          Spacing.s12.w,
                          Expanded(
                            child: _buildTextField(
                              label: 'Technique Name *',
                              controller: _nameController,
                              hint: 'e.g. Box Breathing, 4-7-8 Relax',
                              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
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
                              validator: (v) => v == null || v.isEmpty ? 'Req' : null,
                            ),
                          ),
                          Spacing.s8.w,
                          Expanded(
                            child: _buildTextField(
                              label: 'Hold In (s)',
                              controller: _holdInController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Spacing.s8.w,
                          Expanded(
                            child: _buildTextField(
                              label: 'Exhale (s)',
                              controller: _exhaleController,
                              keyboardType: TextInputType.number,
                              validator: (v) => v == null || v.isEmpty ? 'Req' : null,
                            ),
                          ),
                          Spacing.s8.w,
                          Expanded(
                            child: _buildTextField(
                              label: 'Hold Out (s)',
                              controller: _holdOutController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      Spacing.s16.h,
                      _buildTextField(
                        label: 'Description',
                        controller: _descriptionController,
                        hint: 'Purpose and instructions for this technique...',
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              Spacing.s20.h,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Get.back(),
                    child: Text('Cancel', style: r14.copyWith(color: theme.textTheme.bodyMedium?.color)),
                  ),
                  Spacing.s12.w,
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            isEditing ? 'Save Changes' : 'Add Technique',
                            style: r14.copyWith(color: white, fontWeight: FontWeight.w600),
                          ),
                  ),
                ],
              ),
            ],
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
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: r12.copyWith(fontWeight: FontWeight.w600, color: theme.textTheme.bodyMedium?.color),
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
            fillColor: isDark ? const Color(0xFF282926) : const Color(0xFFF9FAF7),
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.1) : slate[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.08) : slate[200]!),
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
