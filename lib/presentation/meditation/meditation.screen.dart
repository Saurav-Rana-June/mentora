import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        top: false, // SliverAppBar handles top safe area
        child: Obx(() {
          if (controller.isLoading.value) {
            return buildLoadingView(context);
          }
          return buildBody(context);
        }),
      ),
    );
  }

  // Loading skeleton view decomposition
  Widget buildLoadingView(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: Theme.of(context).primaryColorLight,
          elevation: 0,
          leading: const Center(child: BackButton()),
          title: Text(
            "Meditation",
            style: h2.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        const Expanded(child: MeditationLoading()),
      ],
    );
  }

  // Core content layout decomposition using CustomScrollView
  Widget buildBody(BuildContext context) {
    final searchFocusNode = FocusNode();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // App Bar Header
        MeditationHeader(
          onSearchTap: () {
            searchFocusNode.requestFocus();
          },
        ),

        // Search Bar, Filter Chips & Featured Section
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Input
              MeditationSearchBar(
                focusNode: searchFocusNode,
                onChanged: (val) => controller.updateSearchQuery(val),
              ),
              Spacing.s8.h,

              // Horizontal Category Chips
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

        // Vertical Scrollable List
        Obx(() => buildAllMeditationsList(context)),

        // Bottom Safe Padding spacing
        SliverToBoxAdapter(
          child: Spacing.s32.h,
        ),
      ],
    );
  }

  // Decompose Featured horizontal scroll segment
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
                    Get.toNamed(
                      Routes.MEDITATION_PLAYER,
                      arguments: session,
                    );
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

  // Decompose All Meditations vertical list segment
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
                Get.toNamed(
                  Routes.MEDITATION_PLAYER,
                  arguments: session,
                );
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
