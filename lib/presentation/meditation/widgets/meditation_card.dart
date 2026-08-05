import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'meditation_session.dart';

class MeditationCard extends StatelessWidget {
  final MeditationSession session;
  final bool isFavorited;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const MeditationCard({
    super.key,
    required this.session,
    this.isFavorited = false,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s16.value.w,
        vertical: Spacing.s8.value.h,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: CustomPrimaryCard(
          borderRadius: 16.r,
          padding: EdgeInsets.all(Spacing.s12.symmetric.horizontal),
          child: Row(
            children: [
              // Rounded Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: CachedNetworkImage(
                  imageUrl: session.imageUrl,
                  height: 70.h,
                  width: 70.h,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 70.h,
                    width: 70.h,
                    color: isDark ? slate[800] : slate[100],
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 70.h,
                    width: 70.h,
                    color: isDark ? slate[800] : slate[100],
                    child: Icon(Icons.image_not_supported, size: 24.sp, color: slate[400]),
                  ),
                ),
              ),
              Spacing.s16.w,

              // Session Metadata
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      session.title,
                      style: r16.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacing.s4.h,
                    Row(
                      children: [
                        Text(
                          session.category,
                          style: r12.copyWith(
                            color: primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacing.s8.w,
                        Container(
                          width: 3.w,
                          height: 3.w,
                          decoration: BoxDecoration(
                            color: isDark ? slate[500] : slate[300],
                            shape: BoxShape.circle,
                          ),
                        ),
                        Spacing.s8.w,
                        Icon(
                          Icons.access_time_rounded,
                          size: 12.sp,
                          color: Theme.of(context).textTheme.bodySmall!.color,
                        ),
                        Spacing.s4.w,
                        Text(
                          session.duration,
                          style: r12.copyWith(
                            color: Theme.of(context).textTheme.bodySmall!.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacing.s12.w,

              // Action Buttons: Favorite & Chevron
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: onFavoriteTap,
                    child: Padding(
                      padding: EdgeInsets.all(Spacing.s8.value),
                      child: Text(
                        isFavorited ? '\u{f004}' : '\u{f004}', // heart icon
                        style: TextStyle(
                          fontFamily: isFavorited ? 'FontAwesomeSolid' : 'FontAwesomeLight',
                          fontSize: 18.sp,
                          color: isFavorited ? red : (isDark ? slate[400] : slate[300]),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '\u{f054}', // chevron right icon
                    style: TextStyle(
                      fontFamily: 'FontAwesomeLight',
                      fontSize: 14.sp,
                      color: isDark ? slate[500] : slate[300],
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
