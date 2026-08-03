import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../infrastructure/theme/theme.dart';
import 'custom_bottomsheet.widget.dart';

class ClearChatBottomsheet extends StatelessWidget {
  final VoidCallback onConfirm;

  const ClearChatBottomsheet({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return CustomBottomsheet(
      title: "Clear Chat",
      titleStyle: h3.copyWith(color: dangerColor, fontWeight: FontWeight.w600),
      description:
          'Sure you want to clear the chat?\nThis action cannot be undone.',
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
                Get.back();
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
              ),
              child: Text('Yes, Clear Chat', style: r16.copyWith(color: white)),
            ),
          ),
        ],
      ),
    );
  }
}
