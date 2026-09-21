import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/data/model/journal_question.model.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import '../controllers/admin_journaling.controller.dart';

class AdminJournalQuestionFormDialog extends StatefulWidget {
  final JournalQuestionModel? question;

  const AdminJournalQuestionFormDialog({super.key, this.question});

  static Future<bool?> show({
    required BuildContext context,
    JournalQuestionModel? question,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AdminJournalQuestionFormDialog(question: question),
    );
  }

  @override
  State<AdminJournalQuestionFormDialog> createState() => _AdminJournalQuestionFormDialogState();
}

class _AdminJournalQuestionFormDialogState extends State<AdminJournalQuestionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<AdminJournalingController>();

  late final TextEditingController _textController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.question?.questionText ?? '');
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    bool success;
    if (widget.question != null) {
      success = await _controller.updateQuestion(
        widget.question!.id,
        _textController.text.trim(),
      );
    } else {
      success = await _controller.createQuestion(
        _textController.text.trim(),
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
    final isEditing = widget.question != null;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1E1F1D) : white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        width: 480.w,
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
                    isEditing ? 'Edit Prompt Question' : 'Add Journal Prompt',
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
              Text(
                'Question Text *',
                style: r12.copyWith(fontWeight: FontWeight.w600, color: theme.textTheme.bodyMedium?.color),
              ),
              Spacing.s4.h,
              TextFormField(
                controller: _textController,
                maxLines: 3,
                validator: (v) => v == null || v.trim().isEmpty ? 'Question text is required' : null,
                style: r14.copyWith(color: theme.textTheme.bodyLarge?.color),
                decoration: InputDecoration(
                  hintText: 'e.g. What is one thing you can forgive yourself for today?',
                  hintStyle: r14.copyWith(color: slate[400]),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF282926) : const Color(0xFFF9FAF7),
                  contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
                            isEditing ? 'Save Changes' : 'Add Question',
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
}
