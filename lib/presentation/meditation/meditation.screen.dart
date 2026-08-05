import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/navigation/routes.dart';

import 'controllers/meditation.controller.dart';
import 'widgets/meditation_header.dart';
import 'package:Mentora/widgets/others/custom.searchbar.widget.dart';
import 'package:Mentora/widgets/others/custom.horizontal.scrollable.filter.widget.dart';
import 'widgets/meditation_section_title.dart';
import 'widgets/featured_meditation_card.dart';
import 'widgets/meditation_card.dart';
import 'widgets/meditation_empty_view.dart';
import 'widgets/meditation_loading.dart';

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
      appBar: MeditationHeader(
        onSearchTap: () {
          _searchFocusNode.requestFocus();
        },
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const MeditationLoading();
          }

          return SingleChildScrollView(
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
                    items: _categories,
                    selectedItem: controller.selectedCategory.value,
                    labelBuilder: (cat) => cat,
                    onItemSelected: (cat) => controller.changeCategory(cat),
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.s16.value.w,
                    ),
                  ),
                ),
                Spacing.s12.h,

                // Horizontally Scrolling Featured Carousel
                Obx(() => buildFeaturedSection(context)),

                // Vertical List Section Title
                Obx(() {
                  if (controller.filteredSessions.isNotEmpty) {
                    return const MeditationSectionTitle(
                      title: "All Meditations",
                    );
                  }
                  return const SizedBox.shrink();
                }),

                // Vertical List of Sessions
                Obx(() => buildAllMeditationsList(context)),

                // Bottom Safe Spacing
                Spacing.s32.h,
              ],
            ),
          );
        }),
      ),
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
            padding: EdgeInsets.symmetric(horizontal: Spacing.s16.value.w),
            itemCount: featuredList.length,
            itemBuilder: (context, index) {
              final session = featuredList[index];
              return Obx(() {
                final isFav = controller.favoritedIds.contains(session.id);
                return FeaturedMeditationCard(
                  session: session,
                  isFavorited: isFav,
                  onTap: () {
                    Get.toNamed(Routes.MEDITATION_PLAYER, arguments: session);
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
        padding: EdgeInsets.only(top: 40.h),
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
              Get.toNamed(Routes.MEDITATION_PLAYER, arguments: session);
            },
            onFavoriteTap: () => controller.toggleFavorite(session.id),
          );
        });
      }).toList(),
    );
  }
}
