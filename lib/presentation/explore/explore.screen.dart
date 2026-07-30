import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:Mentora/presentation/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';

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
          children: [
            buildTopFeatureSection(context),
            buildDiscoverMeditation(context),
            buildVideoSection(context),
          ],
        ),
      ),
    );
  }

  Padding buildVideoSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
        vertical: Spacing.s4.symmetric.horizontal,
      ),
      child: Column(
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

          buildVideoTile(context),
          buildVideoTile(context),
        ],
      ),
    );
  }

  Column buildVideoTile(BuildContext context) {
    return Column(
      children: [
        CustomPrimaryCard(
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 80,
                    child: Image.asset(
                      "assets/images/banner.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Text(
                    '\u{f144}', // Change icon :- circle-play
                    style: TextStyle(
                      fontFamily: 'FontAwesomeSolid',
                      fontSize: 30,
                      color: primary,
                    ),
                  ),
                ],
              ),
              Spacing.s12.w,
              Expanded(
                child: SizedBox(
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                        style: r14.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "Stress Management",
                        style: r14.copyWith(
                          color: Theme.of(context).textTheme.bodySmall!.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Spacing.s8.h,
      ],
    );
  }

  Column buildDiscoverMeditation(BuildContext context) {
    return Column(
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
        Spacing.s4.h,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s8.symmetric.horizontal,
            vertical: Spacing.s4.symmetric.horizontal,
          ),
          child: Row(
            children: [
              buildDiscoverFeatureTile(
                context,
                '\u{f119}', // Change icon :- face-frown
                'Stress Management',
                '11 mins',
              ),
              Spacing.s8.w,
              buildDiscoverFeatureTile(
                context,
                '\u{e027}', // Change icon :- rocket-launch
                'Mood Boost Blueprint',
                '25 mins',
              ),
              Spacing.s8.w,
              buildDiscoverFeatureTile(
                context,
                '\u{e36a}', // Change icon :- face-anxious-sweat
                'Anxiety Reducing Meditation',
                '45 mins',
              ),
              Spacing.s8.w,
              buildDiscoverFeatureTile(
                context,
                '\u{e480}', // Change icon :- face-exhaling
                'Wim Hoff Technique',
                '10 mins',
              ),
            ],
          ),
        ),
      ],
    );
  }

  InkWell buildDiscoverFeatureTile(
    BuildContext context,
    String icon,
    String title,
    String caption,
  ) {
    return InkWell(
      onTap: () {},
      child: CustomPrimaryCard(
        child: SizedBox(
          width: Get.width / 4.2,
          child: Column(
            children: [
              Text(
                icon,
                style: TextStyle(
                  fontFamily: 'FontAwesomeSolid',
                  fontSize: 45,
                  color: primary,
                ),
              ),
              Spacing.s4.h,
              Text(
                title,
                style: r14.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                caption,
                textAlign: TextAlign.center,
                style: r14.copyWith(
                  color: Theme.of(context).textTheme.bodySmall!.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildTopFeatureSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
        vertical: Spacing.s4.symmetric.horizontal,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildFeatureTile(
                context,
                '\u{f5bb}',
                'Meditations',
              ), // Change Icon :- person-meditating
              buildFeatureTile(
                context,
                '\u{e480}',
                'Breathing',
              ), // Change Icon :- face-exhaling
              buildFeatureTile(
                context,
                '\u{f1ea}',
                'Articles',
              ), // Change Icon :- newspaper
            ],
          ),
          Spacing.s8.h,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildFeatureTile(
                context,
                '\u{e4f3}',
                'Tests',
              ), // Change Icon :- flask-vial
              buildFeatureTile(
                context,
                '\u{f37e}',
                'Smart Journey',
              ), // Change Icon :- browser
              buildFeatureTile(
                context,
                '\u{f328}',
                'Notepad',
              ), // Change Icon :- clipboard
            ],
          ),
          Spacing.s8.h,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildFeatureTile(
                context,
                '\u{f4b4}',
                'Affirmations',
              ), // Change Icon :- comment-smile
              buildFeatureTile(
                context,
                '\u{e234}',
                'Quotes',
              ), // Change Icon :- quotes
              buildFeatureTile(
                context,
                '\u{f0eb}',
                'Tips',
              ), // Change Icon :- lightbulb
            ],
          ),
          Spacing.s20.h,
        ],
      ),
    );
  }

  InkWell buildFeatureTile(BuildContext context, String icon, String title) {
    return InkWell(
      onTap: () {},
      child: CustomPrimaryCard(
        child: SizedBox(
          width: Get.width / 5,
          child: Column(
            children: [
              Text(
                icon,
                style: TextStyle(
                  fontFamily: 'FontAwesomeSolid',
                  fontSize: 33,
                  color: primary,
                ),
              ),
              Text(
                title,
                style: r14.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
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
          Row(
            children: [
              Spacing.s24.w,
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

          Row(
            children: [
              Text(
                MyIcons.magnifyingGlass,
                style: TextStyle(
                  fontFamily: 'FontAwesomeLight',
                  fontSize: 20,
                  color: primary,
                ),
              ),
              Spacing.s16.w,

              Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  splashColor: primary.withValues(alpha: 0.3),
                  onTap: () {
                    Get.to(
                      () => FavoriteScreen(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  child: SizedBox(
                    height: 30.h,
                    width: 30.h,
                    child: Center(
                      child: Text(
                        MyIcons.heart,
                        style: TextStyle(
                          fontFamily: 'FontAwesomeLight',
                          fontSize: 20,
                          color: primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }
}
