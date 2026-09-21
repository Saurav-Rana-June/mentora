import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/model/meditation_session.model.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import '../controllers/admin_meditation.controller.dart';

class AdminMeditationFormDialog extends StatefulWidget {
  final MeditationSessionModel? meditation;

  const AdminMeditationFormDialog({super.key, this.meditation});

  static Future<bool?> show({
    required BuildContext context,
    MeditationSessionModel? meditation,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AdminMeditationFormDialog(meditation: meditation),
    );
  }

  @override
  State<AdminMeditationFormDialog> createState() => _AdminMeditationFormDialogState();
}

class _AdminMeditationFormDialogState extends State<AdminMeditationFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<AdminMeditationsController>();

  late final TextEditingController _titleController;
  late final TextEditingController _categoryController;
  late final TextEditingController _durationController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _soundTrackController;
  late final TextEditingController _descriptionController;
  bool _isFeatured = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final m = widget.meditation;
    _titleController = TextEditingController(text: m?.title ?? '');
    _categoryController = TextEditingController(text: m?.category ?? 'Stress Relief');
    _durationController = TextEditingController(text: m?.duration ?? '10 min');
    _imageUrlController = TextEditingController(
      text: m?.imageUrl ??
          'https://images.unsplash.com/photo-1506126613408-eca07ce68773?q=80&w=600',
    );
    _soundTrackController = TextEditingController(
      text: m?.soundTrack ?? 'https://soundcloud.com/meditation-music/cadunia',
    );
    _descriptionController = TextEditingController(
      text: m?.description ??
          'Take a deep breath and let go of external distractions. Find a comfortable position and focus on the flow of your breath.',
    );
    _isFeatured = m?.isFeatured ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _durationController.dispose();
    _imageUrlController.dispose();
    _soundTrackController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    bool success;

    if (widget.meditation != null) {
      success = await _controller.updateMeditation(
        id: widget.meditation!.id ?? 0,
        title: _titleController.text.trim(),
        category: _categoryController.text.trim(),
        duration: _durationController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        isFeatured: _isFeatured,
        description: _descriptionController.text.trim(),
        soundTrack: _soundTrackController.text.trim(),
      );
    } else {
      success = await _controller.createMeditation(
        title: _titleController.text.trim(),
        category: _categoryController.text.trim(),
        duration: _durationController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        isFeatured: _isFeatured,
        description: _descriptionController.text.trim(),
        soundTrack: _soundTrackController.text.trim(),
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
    final isEditing = widget.meditation != null;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1E1F1D) : white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        width: 540.w,
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
                    isEditing ? 'Edit Guided Meditation' : 'Add New Guided Meditation',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        context,
                        label: 'Title *',
                        controller: _titleController,
                        hint: 'e.g. Morning Clarity & Focus',
                        validator: (v) => v == null || v.isEmpty ? 'Title is required' : null,
                      ),
                      Spacing.s12.h,
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              context,
                              label: 'Category *',
                              controller: _categoryController,
                              hint: 'e.g. Focus, Sleep, Stress Relief',
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Category is required' : null,
                            ),
                          ),
                          Spacing.s12.w,
                          Expanded(
                            child: _buildTextField(
                              context,
                              label: 'Duration *',
                              controller: _durationController,
                              hint: 'e.g. 10 min',
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Duration is required' : null,
                            ),
                          ),
                        ],
                      ),
                      Spacing.s12.h,
                      _buildTextField(
                        context,
                        label: 'Image URL *',
                        controller: _imageUrlController,
                        hint: 'https://...',
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Image URL is required' : null,
                      ),
                      Spacing.s12.h,
                      _buildTextField(
                        context,
                        label: 'Soundtrack Audio URL',
                        controller: _soundTrackController,
                        hint: 'https://...',
                      ),
                      Spacing.s12.h,
                      _buildTextField(
                        context,
                        label: 'Description',
                        controller: _descriptionController,
                        hint: 'Overview description of the session...',
                        maxLines: 3,
                      ),
                      Spacing.s12.h,
                      SwitchListTile(
                        value: _isFeatured,
                        onChanged: (val) => setState(() => _isFeatured = val),
                        title: Text(
                          'Mark as Featured Session',
                          style: r14.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        subtitle: Text(
                          'Featured sessions will appear highlighted on the home/explore tabs',
                          style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                        ),
                        activeTrackColor: primary.withValues(alpha: 0.5),
                        activeThumbColor: primary,
                        contentPadding: EdgeInsets.zero,
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
                    child: Text(
                      'Cancel',
                      style: r14.copyWith(color: theme.textTheme.bodyMedium?.color),
                    ),
                  ),
                  Spacing.s12.w,
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
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
                            isEditing ? 'Save Changes' : 'Create Meditation',
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
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
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
          validator: validator,
          style: r14.copyWith(color: theme.textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: r14.copyWith(color: slate[400]),
            filled: true,
            fillColor: isDark ? const Color(0xFF282926) : const Color(0xFFF9FAF7),
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: isDark ? Colors.white.withValues(alpha: 0.1) : slate[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: isDark ? Colors.white.withValues(alpha: 0.08) : slate[200]!,
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
