import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:my_icons/icons.dart' show MyIcons;
import 'package:my_spacing/my_spacing.dart';
import 'package:my_spacing/spacing.enum.dart';

import '../../widgets/buttons/custom_back_button.widet.dart';
import '../../widgets/others/custom.primary.card.dart';
import '../chatExperts/views/chat_experts_history.view.dart';
import 'controllers/favorite.controller.dart';

class FavoriteScreen extends GetView<FavoriteController> {
  FavoriteScreen({super.key});

  @override
  final controller = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: buildAppbar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildCategorySelectorSection(context),
            buildMeditationsFeature(context),
            buildBreathingFeature(context),
            buildArticleSection(context),
          ],
        ),
      ),
    );
  }

  Padding buildArticleSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Articles",
                textAlign: TextAlign.center,
                style: r18.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "View All",
                style: r14.copyWith(
                  color: primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Spacing.s8.h,

          buildArticleTile(context),
          buildArticleTile(context),
        ],
      ),
    );
  }

  Column buildArticleTile(BuildContext context) {
    return Column(
      children: [
        CustomPrimaryCard(
          child: Row(
            children: [
              SizedBox(
                width: 100,
                height: 80,
                child: Image.asset(
                  "assets/images/banner.png",
                  fit: BoxFit.fill,
                ),
              ),
              Spacing.s12.w,
              Expanded(
                child: SizedBox(
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                              style: r14.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge!.color,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Spacing.s16.w,

                          Text(
                            '\u{f142}', // Change Icon :-  ellipsis-vertical
                            style: TextStyle(
                              fontFamily: 'FontAwesomeLight',
                              fontSize: 20,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.color,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "3 mins read",
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
            ],
          ),
        ),
        Spacing.s8.h,
      ],
    );
  }

  Column buildBreathingFeature(BuildContext context) {
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
                "Breathing",
                textAlign: TextAlign.center,
                style: r18.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "View All",
                style: r14.copyWith(
                  color: primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // Spacing.s4.h,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s8.symmetric.horizontal,
            vertical: Spacing.s4.symmetric.horizontal,
          ),
          child: Row(
            children: [
              buildFeatureTile(
                context,
                '\u{f6c4}', // Change icon :- cloud-sun
                'Deep Breathing',
                '10 mins',
              ),
              Spacing.s8.w,
              buildFeatureTile(
                context,
                '\u{f5c8}', // Change icon :-face-tired
                'Box Breathing Method',
                '12 mins',
              ),
              Spacing.s8.w,
              buildFeatureTile(
                context,
                '\u{f186}', // Change icon :- moon
                '4-7-8 Breathing',
                '8 mins',
              ),
              Spacing.s8.w,
              buildFeatureTile(
                context,
                '\u{f0f4}', // Change icon :- mug-saucer
                'Alternate Nostril Breathing',
                '15 mins',
              ),
            ],
          ),
        ),
        Spacing.s20.h,
      ],
    );
  }

  Column buildMeditationsFeature(BuildContext context) {
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
                "Meditations",
                textAlign: TextAlign.center,
                style: r18.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "View All",
                style: r14.copyWith(
                  color: primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // Spacing.s4.h,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s8.symmetric.horizontal,
            vertical: Spacing.s4.symmetric.horizontal,
          ),
          child: Row(
            children: [
              buildFeatureTile(
                context,
                '\u{f119}', // Change icon :- face-frown
                'Stress Management',
                '11 mins',
              ),
              Spacing.s8.w,
              buildFeatureTile(
                context,
                '\u{e027}', // Change icon :- rocket-launch
                'Mood Boost Blueprint',
                '25 mins',
              ),
              Spacing.s8.w,
              buildFeatureTile(
                context,
                '\u{e36a}', // Change icon :- face-anxious-sweat
                'Anxiety Reducing Meditation',
                '45 mins',
              ),
              Spacing.s8.w,
              buildFeatureTile(
                context,
                '\u{f5dc}', //  Change icon :- brain
                'Mindfulness Focus Session',
                '20 mins',
              ),
            ],
          ),
        ),
        Spacing.s20.h,
      ],
    );
  }

  InkWell buildFeatureTile(
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

  Column buildCategorySelectorSection(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s8.symmetric.horizontal,
            // vertical: Spacing.s4.symmetric.vertical,
          ),
          child: Row(
            children: List.generate(controller.categories.length, (index) {
              final bool isSelected = controller.selectedIndex.value == index;

              return Obx(
                () => GestureDetector(
                  onTap: () {
                    controller.selectedIndex.value = index;
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : Theme.of(context).textTheme.bodySmall!.color!
                                  .withValues(alpha: 0.5),
                        width: .8,
                      ),
                    ),
                    child: Text(
                      controller.categories[index],
                      style: r14.copyWith(
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyMedium!.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Spacing.s20.h,
      ],
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomBackButton(icon: MyIcons.chevronLeft),

          Text(
            "Favorites",
            textAlign: TextAlign.center,
            style: h3.copyWith(
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
              onTap: () {
                Get.to(
                  () => ChatExpertHistoryView(),
                  transition: Transition.rightToLeft,
                );
              },
              child: SizedBox(
                height: 30.h,
                width: 30.h,
                child: Center(
                  child: Text(
                    MyIcons.magnifyingGlass,
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
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).primaryColorLight,
    );
  }
}
