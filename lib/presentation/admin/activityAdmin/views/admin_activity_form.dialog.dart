import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/model/activity.model.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import '../controllers/admin_activity.controller.dart';

class AdminActivityFormDialog extends StatefulWidget {
  final ActivityModel? activity;

  const AdminActivityFormDialog({super.key, this.activity});

  static Future<bool?> show({
    required BuildContext context,
    ActivityModel? activity,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AdminActivityFormDialog(activity: activity),
    );
  }

  @override
  State<AdminActivityFormDialog> createState() => _AdminActivityFormDialogState();
}

class _AdminActivityFormDialogState extends State<AdminActivityFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<AdminActivityController>();

  late final TextEditingController _titleController;
  late final TextEditingController _captionController;
  late final TextEditingController _iconController;
  late final TextEditingController _durationController;
  late final TextEditingController _tagsController;

  String _selectedCategory = 'breathing';
  bool _isSafetyPriority = false;
  bool _isActive = true;
  bool _isLoading = false;

  final List<String> _categoryOptions = [
    'breathing',
    'meditation',
    'journaling',
    'sleep',
    'movement',
  ];

  @override
  void initState() {
    super.initState();
    final a = widget.activity;
    _titleController = TextEditingController(text: a?.title ?? '');
    _captionController = TextEditingController(text: a?.caption ?? '');
    _iconController = TextEditingController(text: a?.icon ?? 'box');
    _durationController = TextEditingController(text: a?.duration ?? '5 min');
    _tagsController = TextEditingController(text: (a?.tags ?? ['goal:reduce_stress']).join(', '));
    _selectedCategory = a?.category ?? 'breathing';
    _isSafetyPriority = a?.isSafetyPriority ?? false;
    _isActive = a?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _captionController.dispose();
    _iconController.dispose();
    _durationController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final tagsList = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    final body = {
      'title': _titleController.text.trim(),
      'caption': _captionController.text.trim(),
      'icon': _iconController.text.trim(),
      'duration': _durationController.text.trim(),
      'category': _selectedCategory,
      'tags': tagsList,
      'isSafetyPriority': _isSafetyPriority,
      'isActive': _isActive,
    };

    bool success;
    if (widget.activity != null) {
      success = await _controller.updateActivity(widget.activity!.id, body);
    } else {
      success = await _controller.createActivity(body);
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
    final isEditing = widget.activity != null;

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
                    isEditing ? 'Edit Activity Plan' : 'Add Activity to Catalog',
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
                        label: 'Activity Title *',
                        controller: _titleController,
                        hint: 'e.g. Box Breathing, Deep Sleep Soundscape',
                        validator: (v) => v == null || v.isEmpty ? 'Title is required' : null,
                      ),
                      Spacing.s12.h,
                      _buildTextField(
                        label: 'Caption / Subtitle *',
                        controller: _captionController,
                        hint: 'e.g. Deep breathing pattern to clear your mind',
                        validator: (v) => v == null || v.isEmpty ? 'Caption is required' : null,
                      ),
                      Spacing.s12.h,
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Category *',
                                  style: r12.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.textTheme.bodyMedium?.color,
                                  ),
                                ),
                                Spacing.s4.h,
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF282926) : const Color(0xFFF9FAF7),
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: isDark ? Colors.white.withValues(alpha: 0.08) : slate[200]!,
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedCategory,
                                      isExpanded: true,
                                      items: _categoryOptions.map((cat) {
                                        return DropdownMenuItem<String>(
                                          value: cat,
                                          child: Text(
                                            cat.capitalizeFirst ?? cat,
                                            style: r14.copyWith(color: theme.textTheme.bodyLarge?.color),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) setState(() => _selectedCategory = val);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacing.s12.w,
                          Expanded(
                            child: _buildTextField(
                              label: 'Icon Identifier *',
                              controller: _iconController,
                              hint: 'e.g. box, lotus, moon, book',
                              validator: (v) => v == null || v.isEmpty ? 'Icon required' : null,
                            ),
                          ),
                          Spacing.s12.w,
                          Expanded(
                            child: _buildTextField(
                              label: 'Duration *',
                              controller: _durationController,
                              hint: 'e.g. 5 min',
                              validator: (v) => v == null || v.isEmpty ? 'Duration required' : null,
                            ),
                          ),
                        ],
                      ),
                      Spacing.s12.h,
                      _buildTextField(
                        label: 'Wellness Tags (Comma Separated)',
                        controller: _tagsController,
                        hint: 'goal:reduce_stress, mood:anxious, goal:better_sleep',
                      ),
                      Spacing.s12.h,
                      SwitchListTile(
                        value: _isSafetyPriority,
                        onChanged: (val) => setState(() => _isSafetyPriority = val),
                        title: Text(
                          'Crisis Safety Priority',
                          style: r14.copyWith(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          'If true, automatically scheduled for users reporting severe distress moods',
                          style: r12.copyWith(color: theme.textTheme.bodySmall?.color),
                        ),
                        activeTrackColor: dangerColor.withValues(alpha: 0.5),
                        activeThumbColor: dangerColor,
                        contentPadding: EdgeInsets.zero,
                      ),
                      SwitchListTile(
                        value: _isActive,
                        onChanged: (val) => setState(() => _isActive = val),
                        title: Text(
                          'Active in Recommendation Engine',
                          style: r14.copyWith(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          'Available to be generated into daily plan timeline cards',
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
                            isEditing ? 'Save Changes' : 'Add Activity',
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
