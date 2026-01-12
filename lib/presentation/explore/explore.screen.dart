import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:flutter/material.dart';

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
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s8.symmetric.horizontal,
          vertical: Spacing.s4.symmetric.horizontal,
        ),
        child: Column(
          children: [
            Column(
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
              ],
            ),
          ],
        ),
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
                  color: slate[500],
                ),
              ),

              Spacing.s16.w,
              Text(
                MyIcons.heart,
                style: TextStyle(
                  fontFamily: 'FontAwesomeLight',
                  fontSize: 20,
                  color: slate[500],
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
