import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/chatExperts/controllers/chat_experts.controller.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:Mentora/widgets/others/custom.pill.widget.dart';
import 'package:Mentora/widgets/others/custom.divider.dart';
import 'package:Mentora/infrastructure/navigation/routes.dart';
import 'all_reviews.view.dart';

class DoctorDetailsView extends StatefulWidget {
  final Expert expert;

  const DoctorDetailsView({super.key, required this.expert});

  @override
  State<DoctorDetailsView> createState() => _DoctorDetailsViewState();
}

class _DoctorDetailsViewState extends State<DoctorDetailsView> {
  final List<String> _tags = [
    "Anxiety & Stress",
    "Cognitive Behavioral (CBT)",
    "Mindfulness",
    "Depression",
    "Self-Esteem",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final String bio =
        "Dr. ${widget.expert.name ?? 'Therapist'} is a highly dedicated ${widget.expert.speciality ?? 'Mental Health Professional'} specialized in supporting individuals with emotional resilience, mood improvements, and trauma healing. With over 8 years of experience, Dr. ${widget.expert.name ?? 'Therapist'} provides a compassionate, non-judgmental space for exploration, self-discovery, and personal growth.";

    return Scaffold(
      backgroundColor: theme.primaryColorLight,
      appBar: buildAppbar(context),
      body: buildBody(context, theme, isDark, bio),
      bottomNavigationBar: buildBottomCTA(context, theme, isDark),
    );
  }

  PreferredSizeWidget buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColorLight,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: const Center(child: CustomBackButton()),
      title: Text(
        "Therapist Profile",
        style: h2.copyWith(
          color: Theme.of(context).textTheme.bodyLarge!.color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildBody(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String bio,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
        vertical: Spacing.s8.symmetric.horizontal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor Info Card Header
          buildDoctorInfoCard(context, theme, isDark),
          Spacing.s24.h,

          // Bio Section
          buildBioSection(context, theme, bio),
          Spacing.s24.h,

          // Specialties Section
          buildSpecialtiesSection(context, theme, isDark),
          Spacing.s24.h,

          // Reviews Section
          buildReviewsSection(context, theme, isDark),
          Spacing.s24.h,
        ],
      ),
    );
  }

  Widget buildBioSection(BuildContext context, ThemeData theme, String bio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About Me",
          style: r18.copyWith(
            color: theme.textTheme.bodyLarge!.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacing.s8.h,
        Text(
          bio,
          style: r14.copyWith(
            color: theme.textTheme.bodyMedium!.color,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget buildSpecialtiesSection(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Specialities",
          style: r18.copyWith(
            color: theme.textTheme.bodyLarge!.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacing.s12.h,
        Wrap(
          spacing: Spacing.s4.symmetric.horizontal,
          runSpacing: Spacing.s4.symmetric.horizontal,
          children: _tags.map((tag) {
            return CustomPill(label: tag, isSelected: false, onTap: () {});
          }).toList(),
        ),
      ],
    );
  }

  Widget buildDoctorInfoCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return CustomPrimaryCard(
      borderRadius: 16.r,
      padding: EdgeInsets.all(Spacing.s12.symmetric.horizontal),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar with online status
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
                      radius: 38.r,
                      backgroundImage: NetworkImage(widget.expert.image ?? ''),
                      backgroundColor: theme.primaryColorLight,
                    ),
                  ),
                  Positioned(
                    bottom: 4.r,
                    right: 6.r,
                    child: Container(
                      width: 13.r,
                      height: 13.r,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50), // Alive green indicator
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? slate[900]! : Colors.white,
                          width: 2.r,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacing.s16.w,

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.expert.name ?? 'Therapist',
                      style: r20.copyWith(
                        color: theme.textTheme.bodyLarge!.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacing.s4.h,
                    Text(
                      widget.expert.speciality ?? 'Mental Health Professional',
                      style: r14.copyWith(
                        color: theme.textTheme.bodySmall!.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacing.s16.h,
          const CustomDivider(),
          Spacing.s16.h,

          // Stats Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildStatItem(context, "4.9 ★", "120+ Reviews"),
              buildStatItem(context, "8+ Yrs", "Experience"),
              buildStatItem(context, "500+", "Patients"),
            ],
          ),
          Spacing.s16.h,
          const CustomDivider(), Spacing.s16.h,

          // Quick Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildActionButton(
                context,
                Icons.chat_bubble_outline_rounded,
                "Chat",
                true,
              ),
              buildActionButton(
                context,
                Icons.phone_outlined,
                "Voice",
                widget.expert.callFeature == true,
              ),
              buildActionButton(
                context,
                Icons.videocam_outlined,
                "Video",
                widget.expert.videoCallFeature == true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildStatItem(BuildContext context, String value, String label) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: r16.copyWith(
            color: theme.textTheme.bodyLarge!.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.s4.h,
        Text(
          label,
          style: r12.copyWith(
            color: theme.textTheme.bodySmall!.color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    bool isEnabled,
  ) {
    final theme = Theme.of(context);
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.4,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled
              ? () {
                  Get.snackbar(
                    label,
                    "Initiating $label with Dr. ${widget.expert.name}...",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: theme.brightness == Brightness.dark
                        ? slate[800]
                        : Colors.white,
                    colorText: theme.textTheme.bodyLarge?.color,
                    margin: EdgeInsets.all(Spacing.s16.symmetric.horizontal),
                  );
                }
              : null,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: 80.w,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: isEnabled
                  ? primary.withValues(alpha: 0.08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isEnabled
                    ? primary.withValues(alpha: 0.15)
                    : theme.dividerColor.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isEnabled ? primary : theme.textTheme.bodySmall!.color,
                  size: 20.r,
                ),
                Spacing.s4.h,
                Text(
                  label,
                  style: r12.copyWith(
                    color: isEnabled
                        ? theme.textTheme.bodyLarge!.color
                        : theme.textTheme.bodySmall!.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBottomCTA(BuildContext context, ThemeData theme, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
        vertical: Spacing.s8.symmetric.horizontal,
      ),
      decoration: BoxDecoration(
        color: theme.primaryColorLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Price",
                  style: r12.copyWith(color: theme.textTheme.bodySmall!.color),
                ),
                Spacing.s4.h,
                Text(
                  "\$95.00/hr",
                  style: h2.copyWith(
                    color: theme.textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Spacing.s24.w,
            Expanded(
              child: CustomPrimaryButton(
                text: "Book Session",
                height: 48.h,
                borderRadius: 14.r,
                backgroundColor: primary,
                textStyle: r16.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                onPressed: () {
                  Get.toNamed(Routes.BOOKING_SESSION, arguments: widget.expert);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReviewsSection(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    final showSeeAll = _reviews.length > 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Reviews (120+)",
              style: r18.copyWith(
                color: theme.textTheme.bodyLarge!.color,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (showSeeAll)
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => AllReviewsView(reviews: _reviews),
                    transition: Transition.rightToLeft,
                  );
                },
                child: Text(
                  "See All",
                  style: r14.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        Spacing.s16.h,
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _reviews.length > 5 ? 5 : _reviews.length,
          separatorBuilder: (context, index) => Spacing.s12.h,
          itemBuilder: (context, index) {
            final review = _reviews[index];
            return CustomPrimaryCard(
              borderRadius: 12.r,
              padding: EdgeInsets.all(Spacing.s12.symmetric.horizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18.r,
                        backgroundImage: NetworkImage(review.avatarUrl),
                        backgroundColor: theme.primaryColorLight,
                      ),
                      Spacing.s12.w,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.name,
                              style: r14.copyWith(
                                color: theme.textTheme.bodyLarge!.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Spacing.s4.h,
                            Text(
                              review.date,
                              style: r12.copyWith(
                                color: theme.textTheme.bodySmall!.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: List.generate(5, (starIndex) {
                          return Icon(
                            Icons.star_rounded,
                            size: 14.r,
                            color: starIndex < review.rating.floor()
                                ? orange
                                : theme.dividerColor.withValues(alpha: 0.2),
                          );
                        }),
                      ),
                    ],
                  ),
                  Spacing.s8.h,
                  Text(
                    review.comment,
                    style: r12.copyWith(
                      color: theme.textTheme.bodyMedium!.color,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class MockReview {
  final String name;
  final String date;
  final double rating;
  final String comment;
  final String avatarUrl;

  MockReview({
    required this.name,
    required this.date,
    required this.rating,
    required this.comment,
    required this.avatarUrl,
  });
}

final List<MockReview> _reviews = [
  MockReview(
    name: "Sarah Jenkins",
    date: "2 days ago",
    rating: 5.0,
    comment:
        "An incredibly warm and understanding therapist. She helped me look at my stress from a completely different perspective.",
    avatarUrl: "https://randomuser.me/api/portraits/women/45.jpg",
  ),
  MockReview(
    name: "Emma Watson",
    date: "3 days ago",
    rating: 5.0,
    comment:
        "I really appreciated the mindfulness techniques we practiced. It has helped me stay grounded during hectic work hours.",
    avatarUrl: "https://randomuser.me/api/portraits/women/12.jpg",
  ),
  MockReview(
    name: "Michael Chang",
    date: "1 week ago",
    rating: 4.8,
    comment:
        "Very professional and focused. The sessions feel structured and I feel like I'm making real progress.",
    avatarUrl: "https://randomuser.me/api/portraits/men/32.jpg",
  ),
  MockReview(
    name: "David Miller",
    date: "2 weeks ago",
    rating: 4.9,
    comment:
        "Very insightful and patient listener. Highly recommend to anyone dealing with relationship issues or stress management.",
    avatarUrl: "https://randomuser.me/api/portraits/men/44.jpg",
  ),
  MockReview(
    name: "Sophia Martinez",
    date: "1 month ago",
    rating: 5.0,
    comment:
        "Dr. Butcher has an amazing way of explaining cognitive behavioral therapy. The exercises are practical and easy to follow.",
    avatarUrl: "https://randomuser.me/api/portraits/women/28.jpg",
  ),
  MockReview(
    name: "John Davis",
    date: "1 month ago",
    rating: 4.5,
    comment:
        "Very helpful sessions. I got good strategies for handling workload stress.",
    avatarUrl: "https://randomuser.me/api/portraits/men/85.jpg",
  ),
];
