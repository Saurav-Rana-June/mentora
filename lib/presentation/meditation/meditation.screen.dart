import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/presentation/musicPlayer/music_player_view.dart';

import 'controllers/meditation.controller.dart';
import 'widgets/meditation_header.dart';
import 'package:Mentora/widgets/others/custom.searchbar.widget.dart';
import 'package:Mentora/widgets/others/custom.horizontal.scrollable.filter.widget.dart';
import 'widgets/meditation_section_title.dart';
import 'widgets/featured_meditation_card.dart';
import 'widgets/meditation_card.dart';
import 'widgets/meditation_empty_view.dart';
import 'widgets/meditation_loading.dart';
import 'widgets/meditation_content_loading.dart';

class MeditationScreen extends GetView<MeditationController> {
  MeditationScreen({super.key});

  @override
  final controller = Get.put(MeditationController());

  // Instantiate controller and focus nodes once at class level to optimize performance
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  static const List<String> _categories = [
    'All',
    'Sleep',
    'Stress Relief',
    'Anxiety',
    'Focus',
    'Self-Esteem',
    'Kindness',
    'Gratitude',
    'Anger',
    'Grief',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: buildAppbar(context),
      body: buildBody(context),
    );
  }

  PreferredSizeWidget buildAppbar(BuildContext context) {
    return MeditationHeader(
      onSearchTap: () {
        _searchFocusNode.requestFocus();
      },
    );
  }

  SafeArea buildBody(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        final isInitialLoad =
            controller.isLoading.value &&
            controller.allSessionsList.isEmpty &&
            controller.featuredSessionsList.isEmpty;

        if (isInitialLoad) {
          return const MeditationLoading();
        }

        return RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              controller.fetchFilters(forceRefresh: true),
              controller.fetchSessions(forceRefresh: true),
            ]);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Input
                CustomSearchBar(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: (val) => controller.updateSearchQuery(val),
                  hintText: "Search meditations...",
                ),
                Spacing.s8.h,

                // Category Pill Filter
                Obx(
                  () => CustomHorizontalScrollableFilter<String>(
                    items: controller.categoriesList.isNotEmpty
                        ? controller.categoriesList
                        : _categories,
                    selectedItem: controller.selectedCategory.value,
                    labelBuilder: (cat) => cat,
                    onItemSelected: (cat) => controller.changeCategory(cat),
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.s8.symmetric.horizontal,
                    ),
                  ),
                ),
                Spacing.s12.h,

                // Content Area
                Obx(() {
                  if (controller.isLoading.value) {
                    return const MeditationContentLoading();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Horizontally Scrolling Featured Carousel
                      buildFeaturedSection(context),

                      // Vertical List Section Title
                      if (controller.filteredSessions.isNotEmpty)
                        const MeditationSectionTitle(title: "All Meditations"),

                      // Vertical List of Sessions
                      buildAllMeditationsList(context),
                    ],
                  );
                }),

                // Bottom Safe Spacing
                Spacing.s32.h,
              ],
            ),
          ),
        );
      }),
    );
  }

  // Decompose Featured Section
  Widget buildFeaturedSection(BuildContext context) {
    final featuredList = controller.featuredSessions;
    if (featuredList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const MeditationSectionTitle(title: "Featured"),
        SizedBox(
          height: 180.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.s8.symmetric.horizontal,
            ),
            itemCount: featuredList.length,
            itemBuilder: (context, index) {
              final session = featuredList[index];
              return Obx(() {
                final isFav = controller.favoritedIds.contains(session.id);
                return FeaturedMeditationCard(
                  session: session,
                  isFavorited: isFav,
                  onTap: () {
                    Get.to(
                      () => MusicPlayerView(
                        audioUrl: session.soundTrack,
                        title: session.title,
                        category: session.category,
                        imageUrl: session.imageUrl,
                        description: session.description,
                        duration: session.duration,
                        isFavorited: controller.getIsFavoritedRx(session.id),
                        onFavoriteTap: () =>
                            controller.toggleFavorite(session.id),
                      ),
                      transition: Transition.rightToLeft,
                    );
                  },
                  onFavoriteTap: () => controller.toggleFavorite(session.id),
                );
              });
            },
          ),
        ),
        Spacing.s12.h,
      ],
    );
  }

  // Decompose Vertical List Section
  Widget buildAllMeditationsList(BuildContext context) {
    final sessionsList = controller.filteredSessions;

    if (sessionsList.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: Spacing.s40.symmetric.vertical),
        child: const MeditationEmptyView(),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: sessionsList.map((session) {
        return Obx(() {
          final isFav = controller.favoritedIds.contains(session.id);
          return MeditationCard(
            session: session,
            isFavorited: isFav,
            onTap: () {
              Get.to(
                () => MusicPlayerView(
                  audioUrl: session.soundTrack,
                  title: session.title,
                  category: session.category,
                  imageUrl: session.imageUrl,
                  description: session.description,
                  duration: session.duration,
                  isFavorited: controller.getIsFavoritedRx(session.id),
                  onFavoriteTap: () => controller.toggleFavorite(session.id),
                ),
                transition: Transition.rightToLeft,
              );
            },
            onFavoriteTap: () => controller.toggleFavorite(session.id),
          );
        });
      }).toList(),
    );
  }
}
