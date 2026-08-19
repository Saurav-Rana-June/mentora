import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/presentation/chatExperts/controllers/chat_experts.controller.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';

class DoctorSelectionCard extends StatelessWidget {
  final Expert expert;
  final bool isSelected;
  final VoidCallback onTap;

  const DoctorSelectionCard({
    super.key,
    required this.expert,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: EdgeInsets.only(bottom: Spacing.s12.symmetric.horizontal),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? primary : Colors.transparent,
            width: 2.w,
          ),
        ),
        child: CustomPrimaryCard(
          borderRadius: 14.r,
          padding: EdgeInsets.all(Spacing.s12.symmetric.horizontal),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? primary
                        : primary.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: CircleAvatar(
                  radius: 28.r,
                  backgroundImage: NetworkImage(expert.image ?? ''),
                  backgroundColor: theme.primaryColorLight,
                ),
              ),
              Spacing.s12.w,

              // Info details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expert.name ?? 'Therapist',
                      style: r16.copyWith(
                        color: theme.textTheme.bodyLarge!.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacing.s4.h,
                    Text(
                      expert.speciality ?? 'Mental Health Professional',
                      style: r14.copyWith(
                        color: theme.textTheme.bodySmall!.color,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacing.s8.h,
                    Row(
                      children: [
                        Icon(
                          Icons.workspace_premium_outlined,
                          size: 14.r,
                          color: primary,
                        ),
                        Spacing.s4.w,
                        Text(
                          "8+ years exp",
                          style: r12.copyWith(
                            color: theme.textTheme.bodyMedium!.color!
                                .withValues(alpha: 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacing.s12.w,
                        Icon(Icons.star_rounded, size: 14.r, color: orange),
                        Spacing.s4.w,
                        Text(
                          "4.9 (120 reviews)",
                          style: r12.copyWith(
                            color: theme.textTheme.bodyMedium!.color!
                                .withValues(alpha: 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Spacing.s8.h,
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        "Next available slot: Today • 5:00 PM",
                        style: r12.copyWith(
                          color: primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
