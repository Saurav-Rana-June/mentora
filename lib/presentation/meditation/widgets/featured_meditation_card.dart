import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/data/model/meditation_session.model.dart';

class FeaturedMeditationCard extends StatelessWidget {
  final MeditationSessionModel session;
  final bool isFavorited;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const FeaturedMeditationCard({
    super.key,
    required this.session,
    this.isFavorited = false,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.w,
      margin: EdgeInsets.only(right: Spacing.s16.value.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: CachedNetworkImage(
                     imageUrl: session.imageUrl ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Theme.of(context).cardTheme.color,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Theme.of(context).cardTheme.color,
                      child: Icon(Icons.image_not_supported, size: 40.sp, color: slate[400]),
                    ),
                  ),
                ),

                // Gradient Overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.1),
                          Colors.black.withValues(alpha: 0.3),
                          Colors.black.withValues(alpha: 0.75),
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                ),

                // Category Badge (Top Left)
                Positioned(
                  top: Spacing.s12.value.h,
                  left: Spacing.s12.value.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.s12.value.w,
                      vertical: Spacing.s4.value.h,
                    ),
                    decoration: BoxDecoration(
                      color: white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: white.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      session.category ?? '',
                      style: r10.copyWith(
                        color: white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                // Favorite Icon (Top Right)
                Positioned(
                  top: Spacing.s12.value.h,
                  right: Spacing.s12.value.w,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      padding: EdgeInsets.all(Spacing.s8.value),
                      decoration: BoxDecoration(
                        color: white.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: white.withValues(alpha: 0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        isFavorited ? '\u{f004}' : '\u{f004}', // heart icon unicode
                        style: TextStyle(
                          fontFamily: isFavorited ? 'FontAwesomeSolid' : 'FontAwesomeLight',
                          fontSize: 14.sp,
                          color: isFavorited ? red : white,
                        ),
                      ),
                    ),
                  ),
                ),

                // Text Content (Bottom Left)
                Positioned(
                  bottom: Spacing.s16.value.h,
                  left: Spacing.s16.value.w,
                  right: Spacing.s16.value.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        session.title ?? '',
                        style: r18.copyWith(
                          color: white,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacing.s8.h,
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14.sp,
                            color: white.withValues(alpha: 0.8),
                          ),
                          Spacing.s4.w,
                          Text(
                            session.duration ?? '',
                            style: r12.copyWith(
                              color: white.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
