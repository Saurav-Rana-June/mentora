import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/buttons/custom_back_button.widet.dart';
import 'package:Mentora/widgets/others/custom.primary.appbar.dart';
import 'package:Mentora/widgets/others/custom.searchbar.widget.dart';
import 'package:Mentora/widgets/others/custom.horizontal.scrollable.filter.widget.dart';
import 'package:Mentora/widgets/others/custom.screen.wrapper.dart';
import 'controllers/video_session.controller.dart';
import 'widgets/video_card.dart';
import 'widgets/video_content_loading.dart';

class VideoSessionScreen extends GetView<VideoSessionController> {
  VideoSessionScreen({super.key});

  @override
  final controller = Get.put(VideoSessionController());

  final FocusNode _searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return CustomScreenWrapper(
      appBar: buildAppbar(context),
      body: buildBody(context),
    );
  }

  PreferredSizeWidget buildAppbar(BuildContext context) {
    return CustomPrimaryAppBar(
      leading: const Center(child: CustomBackButton()),
      title: Text(
        "Video Sessions",
        style: h2.copyWith(
          color: Theme.of(context).textTheme.bodyLarge!.color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          controller.updateSearchQuery('');
          controller.searchController.clear();
          controller.selectCategory('All');
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
              Spacing.s8.h,
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.s8.symmetric.horizontal,
                ),
                child: buildSearchBar(context),
              ),
              Spacing.s16.h,
              buildCategories(context),
              Spacing.s12.h,
              buildVideoList(context),
              Spacing.s24.h,
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchBar(BuildContext context) {
    return CustomSearchBar(
      controller: controller.searchController,
      focusNode: _searchFocusNode,
      onChanged: (val) => controller.updateSearchQuery(val),
      hintText: "Search video sessions...",
    );
  }

  Widget buildCategories(BuildContext context) {
    return Obx(() {
      return CustomHorizontalScrollableFilter<String>(
        items: controller.categories,
        selectedItem: controller.selectedCategory.value,
        labelBuilder: (cat) => cat,
        onItemSelected: (cat) => controller.selectCategory(cat),
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s8.symmetric.horizontal,
        ),
      );
    });
  }

  Widget buildVideoList(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.videoSessions.isEmpty) {
        return const VideoContentLoading();
      }
      final sessions = controller.filteredSessions;
      if (sessions.isEmpty) {
        return buildEmptyState(context);
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: Spacing.s8.symmetric.vertical),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          return VideoCard(session: session);
        },
      );
    });
  }

  Widget buildEmptyState(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Spacing.s40.value.h),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 70.h,
              width: 70.h,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.video_library_outlined,
                  size: 32.sp,
                  color: primary,
                ),
              ),
            ),
            Spacing.s16.h,
            Text(
              "No video sessions found",
              style: r16.copyWith(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacing.s4.h,
            Text(
              "Try searching for something else.",
              style: r14.copyWith(
                color: Theme.of(context).textTheme.bodySmall!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
