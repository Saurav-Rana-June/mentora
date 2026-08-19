import 'package:Mentora/presentation/videoSession/controllers/video_session.controller.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/navigation/routes.dart';
import '../../infrastructure/theme/theme.dart';
import 'controllers/explore.controller.dart';
import 'package:Mentora/presentation/musicPlayer/music_player_view.dart';
import 'package:Mentora/presentation/meditation/controllers/meditation.controller.dart';
import 'package:Mentora/data/model/video_session.model.dart';
import 'package:Mentora/presentation/videoSession/widgets/video_card.dart';

class ExploreScreen extends GetView<ExploreController> {
  ExploreScreen({super.key});

  @override
  final controller = Get.put(ExploreController());

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: buildAppbar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // buildWelcomeHeader(context),
            buildTopFeatureSection(context),
            Spacing.s12.h,
            buildDiscoverMeditation(context),
            Spacing.s16.h,
            buildVideoSection(context),
            Spacing.s20.h,
          ],
        ),
      ),
    );
  }

  Widget buildWelcomeHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
        vertical: Spacing.s8.symmetric.vertical,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hello, Mindful One",
            style: r14.copyWith(
              color: Theme.of(context).textTheme.bodyMedium!.color,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacing.s4.h,
          Text(
            "Discover Peace & Clarity",
            style: h2.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Padding buildTopFeatureSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
        vertical: Spacing.s8.symmetric.vertical,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: buildFeatureTile(
                  context,
                  icon: '\u{f5bb}',
                  title: 'Meditation',
                  subtitle: 'Calm your mind',
                  onTap: () => Get.toNamed(Routes.MEDITATION),
                ),
              ),
              Spacing.s12.w,
              Expanded(
                child: buildFeatureTile(
                  context,
                  icon: '\u{e480}',
                  title: 'Breathing',
                  subtitle: 'Find your focus',
                  onTap: () => Get.toNamed(Routes.BREATHING),
                ),
              ),
            ],
          ),
          Spacing.s12.h,
          Row(
            children: [
              Expanded(
                child: buildFeatureTile(
                  context,
                  icon: '\u{f236}',
                  title: 'Sleep',
                  subtitle: 'Sleep deeply',
                  onTap: () => Get.toNamed(Routes.SLEEP),
                ),
              ),
              Spacing.s12.w,
              Expanded(
                child: buildFeatureTile(
                  context,
                  icon: '\u{f328}',
                  title: 'Journaling',
                  subtitle: 'Reflect on today',
                  onTap: () => Get.toNamed(Routes.JOURNALING),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFeatureTile(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(16),
      child: CustomPrimaryCard(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s12.symmetric.horizontal,
          vertical: Spacing.s12.symmetric.vertical,
        ),
        child: Column(
          children: [
            Container(
              height: 50.h,
              width: 50.h,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  icon,
                  style: TextStyle(
                    fontFamily: 'FontAwesomeSolid',
                    fontSize: 24.sp,
                    color: primary,
                  ),
                ),
              ),
            ),
            Spacing.s12.h,
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: r14.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: r12.copyWith(
                    color: Theme.of(context).textTheme.bodySmall!.color,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDiscoverMeditation(BuildContext context) {
    final globalController = controller.globalController;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s8.symmetric.horizontal,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Discover Meditations",
                style: r18.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.MEDITATION);
                },
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(
                    "View All",
                    style: r14.copyWith(
                      color: primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Spacing.s8.h,
        Obx(() {
          if (globalController.isLoadingFeaturedMeditations.value) {
            return const ExploreMeditationLoading();
          }

          final list = globalController.featuredMeditations;
          if (list.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.s8.symmetric.horizontal,
              ),
              child: Text(
                "No featured meditations found.",
                style: r14.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.s8.symmetric.horizontal,
              vertical: Spacing.s4.symmetric.horizontal,
            ),
            child: Row(
              children: list.map((item) {
                return Padding(
                  padding: EdgeInsets.only(right: Spacing.s12.value.w),
                  child: buildDiscoverFeatureTile(
                    context,
                    category: (item.category ?? 'General').toUpperCase(),
                    icon: _getCategoryIcon(item.category),
                    title: item.title ?? 'Meditation Session',
                    duration: item.duration ?? '10 min',
                    onTap: () {
                      final meditationController =
                          Get.isRegistered<MeditationController>()
                          ? Get.find<MeditationController>()
                          : Get.put(MeditationController());
                      Get.to(
                        () => MusicPlayerView(
                          audioUrl: item.soundTrack ?? '',
                          title: item.title ?? '',
                          category: item.category ?? '',
                          imageUrl: item.imageUrl ?? '',
                          description: item.description ?? '',
                          duration: item.duration ?? '',
                          isFavorited: meditationController.getIsFavoritedRx(
                            item.id?.toString() ?? '',
                          ),
                          onFavoriteTap: () => meditationController
                              .toggleFavorite(item.id?.toString() ?? ''),
                        ),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  String _getCategoryIcon(String? category) {
    if (category == null) return '\u{f111}'; // default circle
    final lower = category.toLowerCase();
    if (lower.contains('stress')) {
      return '\u{f119}'; // face-frown
    } else if (lower.contains('mood') || lower.contains('esteem')) {
      return '\u{e027}'; // rocket-launch
    } else if (lower.contains('anxiety') ||
        lower.contains('grief') ||
        lower.contains('anger')) {
      return '\u{e36a}'; // face-anxious-sweat
    } else if (lower.contains('breath')) {
      return '\u{e480}'; // face-exhaling
    } else if (lower.contains('sleep')) {
      return '\u{f236}'; // bed
    } else if (lower.contains('focus')) {
      return '\u{f11e}'; // target/bullseye
    } else {
      return '\u{f02d}'; // book/journal default
    }
  }

  Widget buildDiscoverFeatureTile(
    BuildContext context, {
    required String category,
    required String icon,
    required String title,
    required String duration,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: CustomPrimaryCard(
        padding: EdgeInsets.all(Spacing.s12.symmetric.horizontal),
        child: SizedBox(
          width: 180.w,
          height: 125.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.s8.symmetric.horizontal,
                      vertical: Spacing.s4.symmetric.horizontal,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: r10.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 11.sp,
                        color: Theme.of(context).textTheme.bodySmall!.color,
                      ),
                      Spacing.s4.w,
                      Text(
                        duration,
                        style: r10.copyWith(
                          color: Theme.of(context).textTheme.bodySmall!.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacing.s8.h,
              Expanded(
                child: Text(
                  title,
                  style: r14.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 28.h,
                        width: 28.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            icon,
                            style: TextStyle(
                              fontFamily: 'FontAwesomeSolid',
                              fontSize: 14.sp,
                              color: primary,
                            ),
                          ),
                        ),
                      ),
                      Spacing.s8.w,
                      Text(
                        "Guided",
                        style: r10.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 28.h,
                    width: 28.h,
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(Icons.play_arrow, color: white, size: 16.sp),
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

  Widget buildVideoSection(BuildContext context) {
    final videoSessionController = Get.isRegistered<VideoSessionController>()
        ? Get.find<VideoSessionController>()
        : Get.put(VideoSessionController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Spacing.s16.value.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Video Sessions",
                style: r18.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.VIDEO_SESSION);
                },
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(
                    "View All",
                    style: r14.copyWith(
                      color: primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Spacing.s8.h,
        Obx(() {
          if (videoSessionController.isLoading.value &&
              videoSessionController.videoSessions.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
            );
          }
          final list = videoSessionController.videoSessions;
          if (list.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.s16.value.w,
                vertical: 12,
              ),
              child: Text(
                "No video sessions found.",
                style: r14.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
            );
          }
          final displayList = list.take(2).toList();
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: displayList.map((session) {
              return VideoCard(session: session);
            }).toList(),
          );
        }),
      ],
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColorLight,
      surfaceTintColor: Colors.transparent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 25,
            width: 25,
            child: Image.asset('assets/logos/logo.png', fit: BoxFit.fill),
          ),
          Expanded(
            child: Row(
              children: [
                Spacing.s40.w,
                Spacing.s40.w,
                Spacing.s16.w,
                Text(
                  "Explore",
                  textAlign: TextAlign.center,
                  style: h2.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }
}

class ExploreMeditationLoading extends StatefulWidget {
  const ExploreMeditationLoading({super.key});

  @override
  State<ExploreMeditationLoading> createState() =>
      _ExploreMeditationLoadingState();
}

class _ExploreMeditationLoadingState extends State<ExploreMeditationLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(
      begin: 0.35,
      end: 0.75,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final skeletonColor = isDark ? slate[700]! : slate[200]!;

    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.s8.symmetric.horizontal,
              vertical: Spacing.s4.symmetric.horizontal,
            ),
            child: Row(
              children: List.generate(3, (index) {
                return Padding(
                  padding: EdgeInsets.only(right: Spacing.s12.value.w),
                  child: Container(
                    width: 180.w,
                    height: 125.h,
                    decoration: BoxDecoration(
                      color: skeletonColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
