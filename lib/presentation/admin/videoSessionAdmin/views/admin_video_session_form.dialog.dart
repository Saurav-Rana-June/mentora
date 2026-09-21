import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/model/video_session.model.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import '../controllers/admin_video_session.controller.dart';

class AdminVideoSessionFormDialog extends StatefulWidget {
  final VideoSessionModel? session;

  const AdminVideoSessionFormDialog({super.key, this.session});

  static Future<bool?> show({
    required BuildContext context,
    VideoSessionModel? session,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AdminVideoSessionFormDialog(session: session),
    );
  }

  @override
  State<AdminVideoSessionFormDialog> createState() => _AdminVideoSessionFormDialogState();
}

class _AdminVideoSessionFormDialogState extends State<AdminVideoSessionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<AdminVideoSessionController>();

  late final TextEditingController _titleController;
  late final TextEditingController _categoryController;
  late final TextEditingController _durationController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _videoLinkController;
  late final TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final s = widget.session;
    _titleController = TextEditingController(text: s?.title ?? '');
    _categoryController = TextEditingController(text: s?.category ?? 'Stress Management');
    _durationController = TextEditingController(text: s?.duration ?? '10 mins');
    _imageUrlController = TextEditingController(
      text: s?.imageUrl ??
          'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=400&q=80',
    );
    _videoLinkController = TextEditingController(
      text: s?.videoUrl ??
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    );
    _descriptionController = TextEditingController(
      text: s?.description ??
          'Wake up your body and mind with this gentle 10-minute flow. Perfect for beginners to build flexibility, strength, and morning mindfulness.',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _durationController.dispose();
    _imageUrlController.dispose();
    _videoLinkController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    bool success;
    if (widget.session != null) {
      success = await _controller.updateSession(
        id: widget.session!.id,
        title: _titleController.text.trim(),
        category: _categoryController.text.trim(),
        duration: _durationController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        videoLink: _videoLinkController.text.trim(),
        description: _descriptionController.text.trim(),
      );
    } else {
      success = await _controller.createSession(
        title: _titleController.text.trim(),
        category: _categoryController.text.trim(),
        duration: _durationController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        videoLink: _videoLinkController.text.trim(),
        description: _descriptionController.text.trim(),
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
    final isEditing = widget.session != null;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1E1F1D) : white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        width: 520.w,
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
                    isEditing ? 'Edit Video Session' : 'Add Video Session',
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
                      _buildTextField(
                        label: 'Session Title *',
                        controller: _titleController,
                        hint: 'e.g. 10-Minute Morning Yoga Flow',
                        validator: (v) => v == null || v.isEmpty ? 'Title is required' : null,
                      ),
                      Spacing.s12.h,
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              label: 'Category *',
                              controller: _categoryController,
                              hint: 'Stress Management, Sleep, Focus',
                              validator: (v) => v == null || v.isEmpty ? 'Category required' : null,
                            ),
                          ),
                          Spacing.s12.w,
                          Expanded(
                            child: _buildTextField(
                              label: 'Duration *',
                              controller: _durationController,
                              hint: 'e.g. 10 mins',
                              validator: (v) => v == null || v.isEmpty ? 'Duration required' : null,
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
                        label: 'Video Stream URL / Link *',
                        controller: _videoLinkController,
                        hint: 'https://...',
                        validator: (v) => v == null || v.isEmpty ? 'Video URL required' : null,
                      ),
                      Spacing.s12.h,
                      _buildTextField(
                        label: 'Description',
                        controller: _descriptionController,
                        hint: 'Overview description of this video session...',
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
                            isEditing ? 'Save Changes' : 'Add Session',
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
