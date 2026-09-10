import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';

class MeditationEmptyView extends StatelessWidget {
  final String title;
  final String description;

  const MeditationEmptyView({
    super.key,
    this.title = "No Meditations Found",
    this.description = "We couldn't find any sessions matching your query. Try checking your spelling or selection, or switch categories.",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s32.value.w,
        vertical: Spacing.s40.value.h,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Zen Meditation Illustration Placeholder
            Container(
              height: 140.h,
              width: 140.h,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer animated-like calm ring
                  Container(
                    height: 110.h,
                    width: 110.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primary.withValues(alpha: 0.15),
                        width: 1.5,
                      ),
                    ),
                  ),
                  // Middle ring
                  Container(
                    height: 80.h,
                    width: 80.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primary.withValues(alpha: 0.25),
                        width: 1,
                      ),
                    ),
                  ),
                  // Inner solid circle with icon
                  Container(
                    height: 50.h,
                    width: 50.h,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '\u{f5bb}', // meditation icon
                        style: TextStyle(
                          fontFamily: 'FontAwesomeSolid',
                          fontSize: 22.sp,
                          color: primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacing.s24.h,

            // Header text
            Text(
              title,
              style: h2.copyWith(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            Spacing.s12.h,

            // Description text
            Text(
              description,
              style: r14.copyWith(
                color: Theme.of(context).textTheme.bodyMedium!.color,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
