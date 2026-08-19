import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/presentation/chatExperts/controllers/chat_experts.controller.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';

class SessionTypeSelector extends StatelessWidget {
  final Expert expert;
  final String selectedType;
  final ValueChanged<String> onTypeSelected;

  const SessionTypeSelector({
    super.key,
    required this.expert,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final videoAvailable = expert.videoCallFeature != false;
    final voiceAvailable = expert.callFeature != false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s4.symmetric.horizontal,
          ),
          child: Text(
            "Session Type",
            style: r16.copyWith(
              color: theme.textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Spacing.s12.h,
        Row(
          children: [
            // Video option
            Expanded(
              child: _buildTypeButton(
                context: context,
                type: "Video Call",
                label: "Video Call",
                icon: Icons.videocam_outlined,
                isAvailable: videoAvailable,
                isSelected: selectedType == "Video Call",
              ),
            ),
            Spacing.s12.w,
            // Voice option
            Expanded(
              child: _buildTypeButton(
                context: context,
                type: "Voice Call",
                label: "Voice Call",
                icon: Icons.phone_outlined,
                isAvailable: voiceAvailable,
                isSelected: selectedType == "Voice Call",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeButton({
    required BuildContext context,
    required String type,
    required String label,
    required IconData icon,
    required bool isAvailable,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final active = isSelected && isAvailable;

    return InkWell(
      onTap: isAvailable ? () => onTypeSelected(type) : null,
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: active
              ? primary
              : isAvailable
              ? primary.withValues(alpha: 0.05)
              : Colors.grey.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: active
                ? primary
                : isAvailable
                ? theme.dividerColor.withValues(alpha: 0.1)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24.r,
              color: active
                  ? white
                  : isAvailable
                  ? primary
                  : theme.textTheme.bodySmall!.color!.withValues(alpha: 0.4),
            ),
            Spacing.s8.h,
            Text(
              label,
              style: r14.copyWith(
                color: active
                    ? white
                    : isAvailable
                    ? theme.textTheme.bodyMedium!.color
                    : theme.textTheme.bodySmall!.color!.withValues(alpha: 0.4),
                fontWeight: FontWeight.w600,
              ),
            ),
            if (!isAvailable) ...[
              SizedBox(height: 2.h),
              Text(
                "Unavailable",
                style: r10.copyWith(
                  color: theme.textTheme.bodySmall!.color!.withValues(
                    alpha: 0.4,
                  ),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
