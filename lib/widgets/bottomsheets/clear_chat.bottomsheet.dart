import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../infrastructure/theme/theme.dart';

class ClearChatBottomsheet extends StatelessWidget {
  final VoidCallback onConfirm;

  const ClearChatBottomsheet({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Text(
              "Clear Chat",
              textAlign: TextAlign.center,
              style: h3.copyWith(
                color: dangerColor,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              'Sure you want to clear the chat?\nThis action cannot be undone.',
              textAlign: TextAlign.center,
              style: r16.copyWith(
                color: Theme.of(context).textTheme.bodyLarge!.color!,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 24),

            // Buttons
            Row(
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
                    child: Text(
                      'Yes, Clear Chat',
                      style: r16.copyWith(color: white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
