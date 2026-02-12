import 'package:Mentora/widgets/others/custom.circular.progressbar.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../infrastructure/theme/theme.dart';
import 'controllers/insights.controller.dart';

class InsightsScreen extends GetView<InsightsController> {
  InsightsScreen({super.key});

  @override
  final controller = Get.put(InsightsController());

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
            buildGrowthArea(context),
            Spacing.s24.h,
            CustomPrimaryCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Mood Tracker",
                        textAlign: TextAlign.center,
                        style: r18.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      // Toggle Buttons
                      ToggleButtons(
                        isSelected: [
                          controller.selectedIndex.value == 0,
                          controller.selectedIndex.value == 1,
                        ],
                        onPressed: controller.toggleGrowthArea,
                        borderRadius: BorderRadius.circular(20),
                        fillColor: primary,
                        color: Colors.white,
                        borderColor: Colors.grey.shade300,
                        selectedBorderColor: primary,
                        constraints: const BoxConstraints(
                          minHeight: 30,
                          minWidth: 60,
                        ),
                        children: [
                          Text(
                            "Weekly",
                            style: r12.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge!.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Monthly",
                            style: r12.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge!.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacing.s12.h,
                  Divider(),
                  Spacing.s12.h,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomPrimaryCard buildGrowthArea(BuildContext context) {
    return CustomPrimaryCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Growth Area",
                textAlign: TextAlign.center,
                style: r18.copyWith(fontWeight: FontWeight.w600),
              ),

              // Toggle Buttons
              ToggleButtons(
                isSelected: [
                  controller.selectedIndex.value == 0,
                  controller.selectedIndex.value == 1,
                ],
                onPressed: controller.toggleGrowthArea,
                borderRadius: BorderRadius.circular(20),
                fillColor: primary,
                selectedColor: Colors.white,
                color: Theme.of(context).textTheme.bodyLarge!.color,
                constraints: const BoxConstraints(minHeight: 30, minWidth: 60),
                children: [
                  Text(
                    '\u{f624}', // Change icon :- gauge
                    style: TextStyle(
                      fontFamily: 'FontAwesomeSolid',
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '\u{e0e7}', // Change icon :- chart-radar
                    style: TextStyle(
                      fontFamily: 'FontAwesomeSolid',
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Spacing.s12.h,
          Divider(),
          Spacing.s12.h,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildGrowthProgressIndicators(context, 0.7, "Mental Health"),
              buildGrowthProgressIndicators(context, 0.5, "Growth Mindset"),

              buildGrowthProgressIndicators(context, 0.9, "Relationships"),
            ],
          ),
          Spacing.s12.h,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildGrowthProgressIndicators(
                context,
                0.7,
                "Personal Development",
              ),
              buildGrowthProgressIndicators(context, 0.5, "Self-awareness"),

              buildGrowthProgressIndicators(context, 0.9, "Stress Management"),
            ],
          ),
        ],
      ),
    );
  }

  Column buildGrowthProgressIndicators(
    BuildContext context,
    double percentage,
    String title,
  ) {
    return Column(
      children: [
        CustomCircularProgressBar(
          percentage: percentage,
          size: Get.height / 9,
          strokeWidth: 10,
          backgroundColor: slate[100]!,
          progressColor: primary,
          textStyle: r16.copyWith(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontWeight: FontWeight.bold,
          ),
          onComplete: () {},
        ),
        Spacing.s4.h,
        SizedBox(
          width: Get.height / 9,
          child: Text(
            title,
            style: r12.copyWith(
              color: Theme.of(context).textTheme.bodyMedium!.color,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
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
          Text(
            "Insights",
            textAlign: TextAlign.center,
            style: h2.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w600,
            ),
          ),

          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              splashColor: primary.withValues(alpha: 0.3),
              onTap: () {},
              child: SizedBox(
                height: 30.h,
                width: 30.h,
                child: Center(
                  child: Text(
                    '\u{f142}', // Change Icon :-  ellipsis-vertical
                    style: TextStyle(
                      fontFamily: 'FontAwesomeLight',
                      fontSize: 20,
                      color: slate[500],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }
}
