import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../widgets/others/custom.primary.card.dart';
import 'controllers/sleep.controller.dart';
import 'package:Mentora/presentation/widgets/loaders/loader.dart';

class SleepScreen extends GetView<SleepController> {
  SleepScreen({super.key});

  @override
  final controller = Get.put(SleepController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: buildAppbar(context),
      body: buildBody(context),
    );
  }

  Column buildBody(BuildContext context) {
    return Column(
      children: [
        buildTabbarSection(),
        Obx(() {
          switch (controller.selectedTabIndex.value) {
            case 0:
              return buildSoundsSection(context);
            case 1:
              return buildMusicSection(context);
            case 2:
              return buildStoriesSection(context);
            default:
              return SizedBox();
          }
        }),
      ],
    );
  }

  Expanded buildStoriesSection(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s8.symmetric.horizontal,
          vertical: Spacing.s4.symmetric.horizontal,
        ),
        itemCount: controller.stories.length,
        itemBuilder: (context, index) {
          final story = controller.stories[index];
          return buildStoriesCard(context, story);
        },
      ),
    );
  }

  Expanded buildMusicSection(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s8.symmetric.horizontal,
          vertical: Spacing.s4.symmetric.horizontal,
        ),
        itemCount: controller.calmMusics.length,
        itemBuilder: (context, index) {
          final music = controller.calmMusics[index];
          return buildMusicCard(context, music);
        },
      ),
    );
  }

  Widget buildStoriesCard(BuildContext context, Story story) {
    return Column(
      children: [
        CustomPrimaryCard(
          child: Row(
            children: [
              SizedBox(
                width: 100,
                height: 80,
                child: CachedNetworkImage(
                  imageUrl: story.imageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade300,
                    ),
                    child: const SizedBox(
                      width: 20,
                      height: 20,
                      child: Loader(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade200,
                    ),
                    child: const Icon(Icons.image_not_supported),
                  ),
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
                              story.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: r14.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge!.color,
                              ),
                            ),
                          ),
                          Spacing.s16.w,
                          Text(
                            '\u{f142}',
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
                        story.duration,
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

  Widget buildMusicCard(BuildContext context, CalmMusic music) {
    return Column(
      children: [
        CustomPrimaryCard(
          child: Row(
            children: [
              SizedBox(
                width: 100,
                height: 80,
                child: CachedNetworkImage(
                  imageUrl: music.imageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade300,
                    ),
                    child: const SizedBox(
                      width: 20,
                      height: 20,
                      child: Loader(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade200,
                    ),
                    child: const Icon(Icons.image_not_supported),
                  ),
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
                              music.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: r14.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge!.color,
                              ),
                            ),
                          ),
                          Spacing.s16.w,
                          Text(
                            '\u{f142}',
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
                        music.duration,
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

  Expanded buildSoundsSection(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildCategorySelectorSection(context),
            GridView.builder(
              padding: const EdgeInsets.only(top: 16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.sounds.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                final sound = controller.sounds[index];
                return buildSoundTile(context, index, sound.emoji, sound.title);
              },
            ),
          ],
        ),
      ),
    );
  }

  Column buildSoundTile(
    BuildContext context,
    int index,
    String icon,
    String title,
  ) {
    return Column(
      children: [
        Obx(
          () => InkWell(
            borderRadius: BorderRadius.circular(75),
            onTap: () {
              controller.selectedSoundIndex.value = index;
            },
            child: Container(
              height: 75,
              width: 75,
              decoration: BoxDecoration(
                color: controller.selectedSoundIndex.value == index
                    ? primary
                    : primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  icon,
                  style: TextStyle(
                    // fontFamily: 'FontAwesomeSolid',
                    fontSize: 36,
                    color: primary,
                  ),
                ),
              ),
            ),
          ),
        ),
        Spacing.s8.h,
        Text(
          title,
          style: r14.copyWith(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Column buildCategorySelectorSection(BuildContext context) {
    return Column(
      children: [
        Spacing.s8.h,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s8.symmetric.horizontal,
          ),
          child: Row(
            children: List.generate(controller.categories.length, (index) {
              final bool isSelected =
                  controller.selectedIndexCategory.value == index;

              return Obx(
                () => GestureDetector(
                  onTap: () {
                    controller.selectedIndexCategory.value = index;
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
        // Spacing.s20.h,
      ],
    );
  }

  Column buildTabbarSection() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: Spacing.s8.symmetric.horizontal,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: primary.withValues(alpha: 0.15),
          ),
          child: Obx(
            () => Row(
              children: List.generate(
                controller.tabs.length,
                (index) => Expanded(
                  child: InkWell(
                    onTap: () {
                      controller.selectedTabIndex.value = index;
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller.selectedTabIndex.value == index
                            ? primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: Spacing.s12.symmetric.horizontal,
                        vertical: Spacing.s4.symmetric.horizontal,
                      ),
                      child: Center(
                        child: Text(
                          controller.tabs[index],
                          textAlign: TextAlign.center,
                          style: r16.copyWith(
                            color: controller.selectedTabIndex.value == index
                                ? white
                                : primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Spacing.s8.h,
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
            "Sleep",
            textAlign: TextAlign.center,
            style: h2.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w600,
            ),
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
