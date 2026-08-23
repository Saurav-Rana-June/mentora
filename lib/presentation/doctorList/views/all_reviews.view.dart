import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';
import 'package:Mentora/widgets/others/custom.primary.appbar.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'doctor_details.view.dart'; // import MockReview and _reviews

class AllReviewsView extends StatelessWidget {
  final List<MockReview> reviews;

  const AllReviewsView({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColorLight,
      appBar: buildAppbar(context),
      body: buildBody(context, theme),
    );
  }

  PreferredSizeWidget buildAppbar(BuildContext context) {
    return CustomPrimaryAppBar(
      leading: const Center(child: CustomBackButton()),
      title: Text(
        "All Reviews",
        style: h2.copyWith(
          color: Theme.of(context).textTheme.bodyLarge!.color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context, ThemeData theme) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
        vertical: Spacing.s8.symmetric.horizontal,
      ),
      itemCount: reviews.length,
      separatorBuilder: (context, index) => Spacing.s12.h,
      itemBuilder: (context, index) {
        final review = reviews[index];
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
    );
  }
}
