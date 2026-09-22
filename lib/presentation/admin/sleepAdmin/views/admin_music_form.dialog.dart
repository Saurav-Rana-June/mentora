import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/model/calm_music.model.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import '../controllers/admin_sleep.controller.dart';

class AdminMusicFormDialog extends StatefulWidget {
  final CalmMusicModel? music;

  const AdminMusicFormDialog({super.key, this.music});

  static Future<bool?> show({
    required BuildContext context,
    CalmMusicModel? music,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AdminMusicFormDialog(music: music),
    );
  }

  @override
  State<AdminMusicFormDialog> createState() => _AdminMusicFormDialogState();
}

class _AdminMusicFormDialogState extends State<AdminMusicFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<AdminSleepController>();

  late final TextEditingController _titleController;
  late final TextEditingController _categoryController;
  late final TextEditingController _durationController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _audioUrlController;
  late final TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final m = widget.music;
    _titleController = TextEditingController(text: m?.title ?? '');
    _categoryController = TextEditingController(text: m?.category ?? 'Music');
    _durationController = TextEditingController(text: m?.duration ?? '10 min');
    _imageUrlController = TextEditingController(
      text: m?.imageUrl ??
          'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5',
    );
    _audioUrlController = TextEditingController(
      text: m?.audioUrl ??
          'https://www.epidemicsound.com/sound-effects/tracks/ea49cfb0-a12e-47d5-9e08-8bd8feda41f8',
    );
    _descriptionController = TextEditingController(
      text: m?.description ?? 'Relax your mind and drift off with this soothing music track.',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _durationController.dispose();
    _imageUrlController.dispose();
    _audioUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    bool success;
    if (widget.music != null) {
      success = await _controller.updateMusic(
        id: widget.music!.id ?? 0,
        title: _titleController.text.trim(),
        category: _categoryController.text.trim(),
        duration: _durationController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        audioUrl: _audioUrlController.text.trim(),
        description: _descriptionController.text.trim(),
      );
    } else {
      success = await _controller.createMusic(
        title: _titleController.text.trim(),
        category: _categoryController.text.trim(),
        duration: _durationController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        audioUrl: _audioUrlController.text.trim(),
        description: _descriptionController.text.trim(),
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
    final isEditing = widget.music != null;

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
                    isEditing ? 'Edit Sleep Music Track' : 'Add Sleep Music Track',
                    style: h3.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.textTheme.headlineLarge?.color,
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
                    children: [
                      _buildTextField(
                        label: 'Track Title *',
                        controller: _titleController,
                        hint: 'e.g. Deep Sleep Meditation',
                        validator: (v) => v == null || v.isEmpty ? 'Title is required' : null,
                      ),
                      Spacing.s12.h,
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              label: 'Category',
                              controller: _categoryController,
                              hint: 'Music, Ambient, Piano',
                            ),
                          ),
                          Spacing.s12.w,
                          Expanded(
                            child: _buildTextField(
                              label: 'Duration *',
                              controller: _durationController,
                              hint: 'e.g. 15 min',
                              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      Spacing.s12.h,
                      _buildTextField(
                        label: 'Cover Image URL *',
                        controller: _imageUrlController,
                        hint: 'https://...',
                        validator: (v) => v == null || v.isEmpty ? 'Image URL required' : null,
                      ),
                      Spacing.s12.h,
                      _buildTextField(
                        label: 'Audio Stream URL *',
                        controller: _audioUrlController,
                        hint: 'https://...',
                        validator: (v) => v == null || v.isEmpty ? 'Audio URL required' : null,
                      ),
                      Spacing.s12.h,
                      _buildTextField(
                        label: 'Description',
                        controller: _descriptionController,
                        hint: 'Brief description of the music track...',
                        maxLines: 2,
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
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
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
                            isEditing ? 'Save Changes' : 'Add Track',
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
          validator: validator,
          style: r14.copyWith(color: theme.textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: r14.copyWith(color: slate[400]),
            filled: true,
            fillColor: isDark ? const Color(0xFF282926) : const Color(0xFFF9FAF7),
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
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
