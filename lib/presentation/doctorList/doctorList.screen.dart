import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../infrastructure/theme/theme.dart';
import '../../widgets/buttons/custom_back_button.widet.dart';
import '../../widgets/others/custom.searchbar.widget.dart';
import '../../widgets/others/custom.circular.progressbar.dart';
import 'controllers/doctor_list_controller.dart';
import 'widgets/doctor_selection_card.dart';
import 'widgets/doctor_list_loading.dart';

class DoctorListScreen extends GetView<DoctorListController> {
  DoctorListScreen({super.key});

  @override
  final controller = Get.put(DoctorListController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: theme.primaryColorLight,
        appBar: buildAppbar(context),
        body: buildBody(context),
      ),
    );
  }

  PreferredSizeWidget buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColorLight,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: const Center(child: CustomBackButton()),
      title: Text(
        "Choose Therapist",
        style: h2.copyWith(
          color: Theme.of(context).textTheme.bodyLarge!.color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () => controller.fetchTherapists(forceRefresh: true),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s8.symmetric.horizontal,
        ),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: controller.scrollController,
          slivers: [
            SliverToBoxAdapter(child: Spacing.s8.h),
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: theme.primaryColorLight,
              surfaceTintColor: Colors.transparent,
              floating: true,
              snap: true,
              pinned: false,
              elevation: 0,
              titleSpacing: 0,
              toolbarHeight: 66.h,
              title: Padding(
                padding: EdgeInsets.only(bottom: Spacing.s8.symmetric.vertical),
                child: CustomSearchBar(
                  hintText: "Search therapists...",
                  onChanged: (val) => controller.searchQuery.value = val,
                ),
              ),
            ),
            Obx(() {
              final filtered = controller.filteredTherapists;

              if (filtered.isEmpty) {
                if (controller.isLoading.value) {
                  return const SliverToBoxAdapter(child: DoctorListLoading());
                }
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🔍', style: TextStyle(fontSize: 40.sp)),
                        Spacing.s12.h,
                        Text(
                          "No therapists found",
                          style: r16.copyWith(
                            color: theme.textTheme.bodyLarge!.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacing.s4.h,
                        Text(
                          "Try searching for another name or specialty.",
                          style: r12.copyWith(
                            color: theme.textTheme.bodySmall!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == filtered.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Spacing.s4.symmetric.vertical,
                        ),
                        child: Center(
                          child: CustomCircularProgressBar(
                            percentage: 0.8,
                            size: 24.r,
                            strokeWidth: 3.r,
                            showPercentageText: false,
                            progressColor: theme.primaryColor,
                            backgroundColor: theme.dividerColor.withValues(alpha: 0.1),
                          ),
                        ),
                      );
                    }
                    final expert = filtered[index];
                    return DoctorSelectionCard(
                      expert: expert,
                      onTap: () => controller.selectDoctor(expert),
                    );
                  },
                  childCount:
                      filtered.length + (controller.isLoadMore.value ? 1 : 0),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
