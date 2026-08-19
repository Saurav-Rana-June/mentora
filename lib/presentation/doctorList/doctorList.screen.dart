import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../infrastructure/theme/theme.dart';
import '../../widgets/buttons/custom_back_button.widet.dart';
import '../../widgets/others/custom.searchbar.widget.dart';
import 'controllers/doctor_list_controller.dart';
import 'widgets/doctor_selection_card.dart';

class DoctorListScreen extends GetView<DoctorListController> {
  DoctorListScreen({super.key});

  @override
  final controller = Get.put(DoctorListController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColorLight,
      appBar: buildAppbar(context),
      body: buildBody(context),
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

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSearchBar(
            hintText: "Search therapists...",
            onChanged: (val) => controller.searchQuery.value = val,
          ),
          Spacing.s8.h,
          // Therapists List
          Expanded(
            child: Obx(() {
              final filtered = controller.filteredTherapists;

              if (filtered.isEmpty) {
                return Center(
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
                );
              }

              return ListView.builder(
                itemCount: filtered.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final expert = filtered[index];
                  return DoctorSelectionCard(
                    expert: expert,
                    onTap: () => controller.selectDoctor(expert),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
