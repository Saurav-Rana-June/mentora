import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../../infrastructure/theme/theme.dart';
import '../controllers/booking_session_controller.dart';
import '../widgets/doctor_selection_card.dart';

class ChooseDoctorView extends GetView<BookingSessionController> {
  const ChooseDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & subtitle
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s4.symmetric.horizontal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Choose your therapist",
                style: h2.copyWith(
                  color: theme.textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacing.s8.h,
              Text(
                "Find someone who feels right for you.",
                style: r14.copyWith(
                  color: theme.textTheme.bodySmall!.color,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Spacing.s16.h,

        // Search Input
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s4.symmetric.horizontal,
          ),
          child: TextField(
            onChanged: (val) => controller.searchQuery.value = val,
            style: r14.copyWith(color: theme.textTheme.bodyLarge!.color),
            decoration: InputDecoration(
              hintText: "Search therapists...",
              prefixIcon: Icon(Icons.search, size: 20.r, color: slate[400]),
              suffixIcon: Obx(() {
                if (controller.searchQuery.value.isNotEmpty) {
                  return IconButton(
                    icon: Icon(Icons.clear, size: 18.r, color: slate[400]),
                    onPressed: () {
                      controller.searchQuery.value = "";
                      FocusScope.of(context).unfocus();
                    },
                  );
                }
                return const SizedBox.shrink();
              }),
            ),
          ),
        ),
        Spacing.s20.h,

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
                return Obx(() {
                  final isSelected =
                      controller.selectedDoctor.value?.name == expert.name;
                  return DoctorSelectionCard(
                    expert: expert,
                    isSelected: isSelected,
                    onTap: () => controller.selectDoctor(expert),
                  );
                });
              },
            );
          }),
        ),
      ],
    );
  }
}
