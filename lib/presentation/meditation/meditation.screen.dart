import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/navigation/routes.dart';

import 'controllers/meditation.controller.dart';
import 'widgets/meditation_header.dart';
import 'widgets/meditation_search_bar.dart';
import 'widgets/meditation_filter_chips.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        top: false, // SliverAppBar handles top safe area
        child: Obx(() {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Consistent pinned App Bar across loading and loaded states
              MeditationHeader(
                onSearchTap: () {
                  _searchFocusNode.requestFocus();
                },
              ),

              if (controller.isLoading.value)
                const SliverFillRemaining(
                  child: MeditationLoading(),
                )
              else ...[
                // Search Input & Category Filters
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MeditationSearchBar(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onChanged: (val) => controller.updateSearchQuery(val),
                      ),
                      Spacing.s8.h,

                      // Category Pill Filter
                      Obx(() => MeditationFilterChips(
                            selectedCategory: controller.selectedCategory.value,
                            onCategorySelected: (cat) => controller.changeCategory(cat),
                          )),
                      Spacing.s16.h,

                      // Horizontally Scrolling Featured Carousel
                      Obx(() => buildFeaturedSection(context)),
                    ],
                  ),
                ),

                // Vertical List Section Title
                SliverToBoxAdapter(
                  child: Obx(() {
                    if (controller.filteredSessions.isNotEmpty) {
                      return const MeditationSectionTitle(title: "All Meditations");
                    }
                    return const SizedBox.shrink();
                  }),
                ),

                // Vertical List of Sessions
                Obx(() => buildAllMeditationsList(context)),

                // Bottom Safe Spacing
                SliverToBoxAdapter(child: Spacing.s32.h),
              ],
            ],
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
        Spacing.s16.h,
      ],
    );
  }

  // Decompose Vertical List Section
  Widget buildAllMeditationsList(BuildContext context) {
    final sessionsList = controller.filteredSessions;

    if (sessionsList.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(top: 40.h),
          child: const MeditationEmptyView(),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final session = sessionsList[index];
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
        },
        childCount: sessionsList.length,
      ),
    );
  }
}
