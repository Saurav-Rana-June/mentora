import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../widgets/others/custom.primary.appbar.dart';
import '../../widgets/others/custom.primary.card.dart';
import 'controllers/sleep.controller.dart';
import 'package:Mentora/data/model/sound.model.dart';
import 'package:Mentora/data/model/calm_music.model.dart';
import 'package:Mentora/data/model/story.model.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';
import 'package:Mentora/widgets/others/custom.horizontal.scrollable.filter.widget.dart';
import 'package:Mentora/widgets/others/custom.segmented.tab.widget.dart';
import 'package:Mentora/presentation/musicPlayer/music_player_view.dart';
import 'widgets/sleep_content_loading.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen>
    with SingleTickerProviderStateMixin {
  late final SleepController controller;
  late final TabController _tabController;
  late final Worker _tabWorker;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<SleepController>()
        ? Get.find<SleepController>()
        : Get.put(SleepController());

    _tabController = TabController(
      length: controller.tabs.length,
      vsync: this,
      initialIndex: controller.selectedTabIndex.value,
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        controller.selectedTabIndex.value = _tabController.index;
      }
    });

    _tabWorker = ever(controller.selectedTabIndex, (int index) {
      if (_tabController.index != index) {
        _tabController.animateTo(index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tabWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorLight,
        appBar: buildAppbar(context),
        body: buildBody(context),
      ),
    );
  }

  Column buildBody(BuildContext context) {
    return Column(
      children: [
        Spacing.s8.h,
        buildTabbarSection(context),
        Spacing.s20.h,
        Obx(() {
          if (controller.isLoading.value) {
            return Expanded(
              child: SleepContentLoading(
                selectedTabIndex: controller.selectedTabIndex.value,
              ),
            );
          }
          return Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.fetchSleepData(forceRefresh: true),
              child: _buildTabContent(context),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTabContent(BuildContext context) {
    switch (controller.selectedTabIndex.value) {
      case 0:
        return _buildSoundsContent(context);
      case 1:
        return _buildMusicContent(context);
      case 2:
        return _buildStoriesContent(context);
      default:
        return const SizedBox();
    }
  }

  Widget _buildStoriesContent(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: Spacing.s8.symmetric.horizontal),
      itemCount: controller.stories.length,
      itemBuilder: (context, index) {
        final story = controller.stories[index];
        return buildStoriesCard(context, story);
      },
    );
  }

  Widget _buildMusicContent(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: Spacing.s8.symmetric.horizontal),
      itemCount: controller.calmMusics.length,
      itemBuilder: (context, index) {
        final music = controller.calmMusics[index];
        return buildMusicCard(context, music);
      },
    );
  }

  Widget buildStoriesCard(BuildContext context, StoryModel story) {
    return buildMediaCard(
      context: context,
      title: story.title ?? '',
      category: "Story",
      duration: story.duration ?? '',
      imageUrl: story.imageUrl ?? '',
      onTap: () {
        Get.to(
          () => MusicPlayerView(
            audioUrl: story.audioUrl ?? '',
            title: story.title ?? '',
            category: "Bedtime Story",
            imageUrl: story.imageUrl ?? '',
            description: story.description ?? '',
            duration: story.duration ?? '',
          ),
          transition: Transition.rightToLeft,
        );
      },
    );
  }

  Widget buildMusicCard(BuildContext context, CalmMusicModel music) {
    return buildMediaCard(
      context: context,
      title: music.title ?? '',
      category: "Music",
      duration: music.duration ?? '',
      imageUrl: music.imageUrl ?? '',
      onTap: () {
        Get.to(
          () => MusicPlayerView(
            audioUrl: music.audioUrl ?? '',
            title: music.title ?? '',
            category: "Calm Music",
            imageUrl: music.imageUrl ?? '',
            description: music.description ?? '',
            duration: music.duration ?? '',
          ),
          transition: Transition.rightToLeft,
        );
      },
    );
  }

  Widget buildMediaCard({
    required BuildContext context,
    required String title,
    required String category,
    required String duration,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s16.value.w,
        vertical: Spacing.s8.value.h,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: CustomPrimaryCard(
          borderRadius: 16.r,
          padding: EdgeInsets.zero,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  bottomLeft: Radius.circular(16.r),
                ),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 94.h,
                  width: 94.h,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 94.h,
                    width: 94.h,
                    color: isDark ? slate[800] : slate[100],
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(primary),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 94.h,
                    width: 94.h,
                    color: isDark ? slate[800] : slate[100],
                    child: Icon(
                      Icons.image_not_supported,
                      size: 24.sp,
                      color: slate[400],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Spacing.s12.value.h,
                    horizontal: Spacing.s12.value.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: r16.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacing.s4.h,
                      Row(
                        children: [
                          Text(
                            category,
                            style: r12.copyWith(
                              color: primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacing.s8.w,
                          Container(
                            width: 3.w,
                            height: 3.w,
                            decoration: BoxDecoration(
                              color: isDark ? slate[500] : slate[300],
                              shape: BoxShape.circle,
                            ),
                          ),
                          Spacing.s8.w,
                          Icon(
                            Icons.access_time_rounded,
                            size: 12.sp,
                            color: Theme.of(context).textTheme.bodySmall!.color,
                          ),
                          Spacing.s4.w,
                          Text(
                            duration,
                            style: r12.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall!.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Spacing.s4.h,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.play_circle_fill_rounded,
                            size: 28.sp,
                            color: primary,
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
      ),
    );
  }

  Widget _buildSoundsContent(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          GridView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.s8.symmetric.horizontal,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.sounds.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: Spacing.s12.value.w,
              mainAxisSpacing: Spacing.s16.value.h,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              final sound = controller.sounds[index];
              return buildSoundTile(context, index, sound);
            },
          ),
        ],
      ),
    );
  }

  Widget buildSoundTile(BuildContext context, int index, SoundModel sound) {
    return Column(
      children: [
        Obx(
          () => InkWell(
            borderRadius: BorderRadius.circular(80),
            onTap: () {
              controller.selectedSoundIndex.value = index;
              Get.to(
                () => MusicPlayerView(
                  audioUrl: sound.audioUrl ?? '',
                  title: sound.title ?? '',
                  category: "Ambient Sound",
                  imageUrl:
                      "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
                  description:
                      "Relaxing ambient sound of ${sound.title ?? ''}.",
                  duration: "5:00",
                ),
                transition: Transition.rightToLeft,
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              height: 72.h,
              width: 72.h,
              decoration: BoxDecoration(
                color: controller.selectedSoundIndex.value == index
                    ? primary
                    : Theme.of(context).cardTheme.color,
                shape: BoxShape.circle,
                boxShadow: controller.selectedSoundIndex.value == index
                    ? [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                border: Border.all(
                  color: controller.selectedSoundIndex.value == index
                      ? primary
                      : Theme.of(context).cardColor,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  sound.emoji ?? '',
                  style: TextStyle(fontSize: 32.sp),
                ),
              ),
            ),
          ),
        ),
        Spacing.s8.h,
        Text(
          sound.title ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: r12.copyWith(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget buildCategorySelectorSection(BuildContext context) {
    return Obx(
      () => CustomHorizontalScrollableFilter<String>(
        items: controller.categories,
        selectedItem:
            controller.categories[controller.selectedIndexCategory.value],
        labelBuilder: (cat) => cat,
        onItemSelected: (cat) {
          controller.selectedIndexCategory.value = controller.categories
              .indexOf(cat);
        },
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s8.symmetric.horizontal,
        ),
      ),
    );
  }

  Widget buildTabbarSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final segmentTabs = controller.tabs.map((tabLabel) {
      return SegmentTab(
        label: tabLabel,
        color: primary,
        selectedTextColor: Colors.white,
        textColor: isDark ? slate[400] : slate[600],
      );
    }).toList();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
      ),
      child: CustomSegmentedTab(
        tabs: segmentTabs,
        controller: _tabController,
        height: 42.h,
        barDecoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(100),
        ),
        indicatorDecoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppbar(BuildContext context) {
    return CustomPrimaryAppBar(
      leading: const Center(child: CustomBackButton()),
      title: Text(
        "Sleep",
        style: h2.copyWith(
          color: Theme.of(context).textTheme.bodyLarge!.color,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: Spacing.s16.value.w),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                // Search functionality can be added here
              },
              child: Container(
                height: 40.h,
                width: 40.h,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    MyIcons.magnifyingGlass,
                    style: TextStyle(
                      fontFamily: 'FontAwesomeLight',
                      fontSize: 20.sp,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
