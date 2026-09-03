import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../infrastructure/theme/theme.dart';
import '../fields/custom_textfield.widget.dart';
import 'custom_bottomsheet.widget.dart';

class EditMessageBottomsheet extends StatefulWidget {
  final String initialText;
  final Function(String) onSave;

  const EditMessageBottomsheet({
    super.key,
    required this.initialText,
    required this.onSave,
  });

  @override
  State<EditMessageBottomsheet> createState() => _EditMessageBottomsheetState();
}

class _EditMessageBottomsheetState extends State<EditMessageBottomsheet> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: CustomBottomsheet(
        title: "Edit Message",
        titleStyle: h3.copyWith(
          color: theme.textTheme.bodyLarge?.color,
          fontWeight: FontWeight.w600,
        ),
        description: "Edit your message and send an updated response.",
        footer: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey,
                  side: BorderSide(color: primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'Cancel',
                  style: r16.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  final text = _textController.text.trim();
                  if (text.isNotEmpty) {
                    Get.back();
                    widget.onSave(text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
                child: Text(
                  'Update & Send',
                  style: r16.copyWith(color: white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
        child: Column(
          children: [
            CustomTextFormField(
              controller: _textController,
              hintText: "Enter your message...",
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              minLines: 2,
              borderWidth: 0.8,
              borderColor:
                  theme.dividerTheme.color ?? primary.withValues(alpha: 0.2),
              fillColor: theme.cardTheme.color,
              contentPadding: EdgeInsets.symmetric(
                horizontal: Spacing.s8.symmetric.horizontal,
                vertical: Spacing.s8.symmetric.vertical,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
