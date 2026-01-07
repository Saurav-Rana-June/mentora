import 'package:Mentora/infrastructure/navigation/routes.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/screens.dart';
import 'package:Mentora/widgets/others/custom.dashed.line.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:my_spacing/spacing.enum.dart';

import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});

  @override
  final controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: buildAppbar(context),
      body: buildBody(context),
    );
  }

  SingleChildScrollView buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
        vertical: Spacing.s4.symmetric.horizontal,
      ),
      child: Column(
        children: [
          buildTopBanner(),
          buildMoodCheckinSection(context),
          buildConnectSection(context),
          buildTodayPlanSection(context),
        ],
      ),
    );
  }

  Column buildTodayPlanSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your plan for today (0/5)",
          textAlign: TextAlign.center,
          style: r18.copyWith(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacing.s12.h,

        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: controller.plans.length,
          itemBuilder: (context, index) {
            final plan = controller.plans[index];
            return buildTodayPlanTimelineTile(
              context,
              plan.title,
              plan.label,
              plan.caption,
              plan.icon,
              index == 0 ? true : false,
              index + 1 == controller.plans.length ? true : false,
              plan.isComplete,
            );
          },
        ),
      ],
    );
  }

  IntrinsicHeight buildTodayPlanTimelineTile(
    BuildContext context,
    String title,
    String label,
    String caption,
    String icon,
    bool isFirst,
    bool isLast,
    bool isComplete,
  ) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              CustomDashedLine(
                color: isFirst ? Colors.transparent : primary,
                width: 1.2,
              ),
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primary, width: 1.2),
                ),
                child: isComplete
                    ? Center(
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primary,
                          ),
                        ),
                      )
                    : SizedBox(),
              ),
              CustomDashedLine(
                color: isLast ? Colors.transparent : primary,
                width: 1.2,
              ),
            ],
          ),
          Spacing.s12.w,
          Expanded(
            child: Column(
              children: [
                CustomPrimaryCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: r14.copyWith(
                                color: primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacing.s8.h,
                            Text(
                              label,
                              style: r16.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge!.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              caption,
                              textAlign: TextAlign.center,
                              style: r14.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall!.color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        icon, // Change Icon :- person-meditating
                        style: TextStyle(
                          fontFamily: 'FontAwesomeSolid',
                          fontSize: 50,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacing.s16.h,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column buildConnectSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: Get.width / 2.3,
              child: buildConnectTile(
                context,
                '\u{f544}',
                'Chat with Mentora',
                () {
                  Get.to(
                    () => ChatAIScreen(),
                    transition: Transition.rightToLeft,
                  );
                },
              ), // Change Icon :- robot
            ),

            SizedBox(
              width: Get.width / 2.3,
              child: buildConnectTile(
                context,
                '\u{f0f0}',
                'Talk with Experts',
                () {
                  Get.to(
                    () => ChatExpertsScreen(),
                    transition: Transition.rightToLeft,
                  );
                },
              ), // Change Icon :- user-doctor
            ),
          ],
        ),
        Spacing.s20.h,
      ],
    );
  }

  Material buildConnectTile(
    BuildContext context,
    String icon,
    String label,
    Function()? onTap,
  ) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: primary.withValues(alpha: .2),
        highlightColor: primary.withValues(alpha: .1),
        onTap: onTap,
        child: CustomPrimaryCard(
          child: Row(
            children: [
              Text(
                icon,
                style: TextStyle(
                  fontFamily: 'FontAwesomeSolid',
                  fontSize: 35,
                  color: primary,
                ),
              ),
              Spacing.s8.w,
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: r16.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column buildMoodCheckinSection(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Get.toNamed(Routes.MOOD_CHECKIN);
          },
          child: CustomPrimaryCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "How do you feel today?",
                      textAlign: TextAlign.center,
                      style: r18.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Spacing.s12.h,

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      "assets/moods/Angry Face.svg",
                      width: 45,
                      height: 45,
                    ),
                    SvgPicture.asset(
                      "assets/moods/Not Good Face.svg",
                      width: 45,
                      height: 45,
                    ),
                    SvgPicture.asset(
                      "assets/moods/Normal Face.svg",
                      width: 45,
                      height: 45,
                    ),
                    SvgPicture.asset(
                      "assets/moods/Happy Face.svg",
                      width: 45,
                      height: 45,
                    ),
                    SvgPicture.asset(
                      "assets/moods/Very Happy Face.svg",
                      width: 45,
                      height: 45,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Spacing.s20.h,
      ],
    );
  }

  Column buildTopBanner() {
    return Column(
      children: [
        Container(
          width: Get.width,
          height: Get.height / 4.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage("assets/images/banner.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Spacing.s20.h,
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
          Row(
            children: [
              SizedBox(
                height: 25,
                width: 25,
                child: Image.asset('assets/logos/logo.png', fit: BoxFit.fill),
              ),
              Spacing.s12.w,
              Text(
                "Mentora",
                textAlign: TextAlign.center,
                style: h2.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          Text(
            MyIcons.magnifyingGlass,
            style: TextStyle(
              fontFamily: 'FontAwesomeLight',
              fontSize: 20,
              color: slate[500],
            ),
          ),
        ],
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }
}
