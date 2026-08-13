import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:Mentora/presentation/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/navigation/routes.dart';
import '../../infrastructure/theme/theme.dart';
import 'controllers/explore.controller.dart';

class ExploreScreen extends GetView<ExploreController> {
  const ExploreScreen({super.key});

  @override
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
                onTap: () {},
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s8.symmetric.horizontal,
            vertical: Spacing.s4.symmetric.horizontal,
          ),
          child: Row(
            children: [
              buildDiscoverFeatureTile(
                context,
                category: 'STRESS',
                icon: '\u{f119}', // Change icon :- face-frown
                title: 'Stress Management',
                duration: '11 mins',
              ),
              Spacing.s12.w,
              buildDiscoverFeatureTile(
                context,
                category: 'MOOD',
                icon: '\u{e027}', // Change icon :- rocket-launch
                title: 'Mood Boost Blueprint',
                duration: '25 mins',
              ),
              Spacing.s12.w,
              buildDiscoverFeatureTile(
                context,
                category: 'ANXIETY',
                icon: '\u{e36a}', // Change icon :- face-anxious-sweat
                title: 'Anxiety Reducing',
                duration: '45 mins',
              ),
              Spacing.s12.w,
              buildDiscoverFeatureTile(
                context,
                category: 'BREATH',
                icon: '\u{e480}', // Change icon :- face-exhaling
                title: 'Wim Hoff Technique',
                duration: '10 mins',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDiscoverFeatureTile(
    BuildContext context, {
    required String category,
    required String icon,
    required String title,
    required String duration,
  }) {
    return InkWell(
      onTap: () {},
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
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                onTap: () {},
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
          Spacing.s8.h,
          buildVideoTile(
            context,
            category: "STRESS MANAGEMENT",
            title: "10-Minute Morning Yoga Flow for Beginners",
            duration: "10 mins",
            author: "Coach Jessica",
          ),
          buildVideoTile(
            context,
            category: "SLEEP SCIENCE",
            title: "Deep Sleep Guided Visualization & Breathing",
            duration: "25 mins",
            author: "Dr. Sarah Cole",
          ),
        ],
      ),
    );
  }

  Widget buildVideoTile(
    BuildContext context, {
    required String title,
    required String category,
    required String duration,
    required String author,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: CustomPrimaryCard(
        padding: EdgeInsets.all(Spacing.s8.symmetric.horizontal),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 100.w,
                    height: 75.h,
                    child: Image.asset(
                      "assets/images/banner.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 32.h,
                  width: 32.h,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
              ],
            ),
            Spacing.s12.w,
            Expanded(
              child: SizedBox(
                height: 75.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: r10.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: Text(
                          title,
                          style: r14.copyWith(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
                          "$duration • by $author",
                          style: r10.copyWith(
                            color: Theme.of(context).textTheme.bodySmall!.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
