import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/moodCheckin/controllers/mood_checkin.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:my_spacing/spacing.enum.dart';

class AddNotesView extends GetView<MoodCheckinController> {
  const AddNotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s12.symmetric.horizontal,
        vertical: Spacing.s4.symmetric.horizontal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Add Notes",
                textAlign: TextAlign.center,
                style: h2.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.headlineMedium!.color,
                ),
              ),
            ],
          ),
          Spacing.s20.h,

          Text(
            "Notes (optional)",
            style: r14.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacing.s8.h,
          TextFormField(
            controller: controller.notesController,
            textAlignVertical: TextAlignVertical.center,
            style: r16.copyWith(fontWeight: FontWeight.w400),
            maxLines: 8,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: Spacing.s8.symmetric.horizontal,
                vertical: Spacing.s8.symmetric.vertical,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).cardTheme.color,
            ),
          ),
        ],
      ),
    );
  }
}
