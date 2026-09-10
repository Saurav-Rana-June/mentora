import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';

class MusicPlayerArtwork extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String description;

  const MusicPlayerArtwork({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circular Artwork with glowing drop shadow
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer Glow
              Container(
                height: 220.h,
                width: 220.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: isDark ? 0.15 : 0.25),
                      blurRadius: 35,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),

              // Image Card
              Container(
                height: 200.h,
                width: 200.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                     imageUrl: imageUrl,
                     fit: BoxFit.cover,
                     placeholder: (context, url) => Container(
                       color: isDark ? slate[800] : slate[100],
                       child: const Center(
                         child: CircularProgressIndicator(
                           strokeWidth: 3,
                           valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                         ),
                       ),
                     ),
                     errorWidget: (context, url, error) => Container(
                       color: isDark ? slate[800] : slate[100],
                       child: Icon(Icons.music_note_rounded, size: 50.sp, color: slate[400]),
                     ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Spacing.s32.h,

        // Subtitle Badge
        if (subtitle.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.s12.symmetric.horizontal,
              vertical: Spacing.s4.symmetric.vertical,
            ),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              subtitle.toUpperCase(),
              style: r10.copyWith(
                color: primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
          ),
        if (subtitle.isNotEmpty) Spacing.s12.h,

        // Session Title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Spacing.s24.value.w),
          child: Text(
            title,
            style: h2.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Spacing.s8.h,

        // Description
        if (description.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Spacing.s32.value.w),
            child: Text(
              description,
              style: r14.copyWith(
                color: Theme.of(context).textTheme.bodyMedium!.color,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}
