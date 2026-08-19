import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/presentation/chatExperts/controllers/chat_experts.controller.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';

class DoctorSelectionCard extends StatelessWidget {
  final Expert expert;
  final VoidCallback onTap;

  const DoctorSelectionCard({
    super.key,
    required this.expert,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: Spacing.s12.symmetric.horizontal),
        child: CustomPrimaryCard(
          borderRadius: 16.r,
          padding: EdgeInsets.all(Spacing.s12.symmetric.horizontal),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with Online Badge
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primary.withValues(alpha: 0.15),
                        width: 1.5,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 28.r,
                      backgroundImage: NetworkImage(expert.image ?? ''),
                      backgroundColor: theme.primaryColorLight,
                    ),
                  ),
                  Positioned(
                    bottom: 2.r,
                    right: 2.r,
                    child: Container(
                      width: 11.r,
                      height: 11.r,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50), // Alive green indicator
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? slate[800]! : Colors.white,
                          width: 2.r,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacing.s12.w,

              // Info Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                expert.speciality ??
                                    'Mental Health Professional',
                                style: r14.copyWith(
                                  color: theme.textTheme.bodySmall!.color,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacing.s8.w,
                        // Call features icons
                        Row(
                          children: [
                            if (expert.videoCallFeature == true) ...[
                              Container(
                                padding: EdgeInsets.all(6.r),
                                decoration: BoxDecoration(
                                  color: primary.withValues(alpha: 0.06),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.videocam_outlined,
                                  size: 15.r,
                                  color: primary,
                                ),
                              ),
                              Spacing.s4.w,
                            ],
                            if (expert.callFeature == true) ...[
                              Container(
                                padding: EdgeInsets.all(6.r),
                                decoration: BoxDecoration(
                                  color: primary.withValues(alpha: 0.06),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.phone_outlined,
                                  size: 15.r,
                                  color: primary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    Spacing.s8.h,

                    // Rating & Experience chips row
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: theme.dividerColor.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 14.r,
                                color: orange,
                              ),
                              Spacing.s4.w,
                              Text(
                                "4.9",
                                style: r12.copyWith(
                                  color: theme.textTheme.bodyMedium!.color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacing.s8.w,
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: theme.dividerColor.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.workspace_premium_outlined,
                                size: 14.r,
                                color: primary,
                              ),
                              Spacing.s4.w,
                              Text(
                                "8+ yrs exp",
                                style: r12.copyWith(
                                  color: theme.textTheme.bodyMedium!.color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Spacing.s10.h,

                    // Next Available Slot pill
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: primary.withValues(alpha: 0.12),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_filled_rounded,
                            size: 13.r,
                            color: primary,
                          ),
                          Spacing.s6.w,
                          Text(
                            "Next slot: Today • 5:00 PM",
                            style: r12.copyWith(
                              color: primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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
