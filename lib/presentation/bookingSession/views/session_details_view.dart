import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../../infrastructure/theme/theme.dart';
import '../controllers/booking_session_controller.dart';

class SessionDetailsView extends GetView<BookingSessionController> {
  const SessionDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textController = TextEditingController(
      text: controller.sessionNotes.value,
    );

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header info
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.s4.symmetric.horizontal,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tell your therapist what's on your mind",
                  style: h2.copyWith(
                    color: theme.textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacing.s8.h,
                Text(
                  "You can share what you'd like help with or focus on during this session. This is optional.",
                  style: r14.copyWith(
                    color: theme.textTheme.bodySmall!.color,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Spacing.s24.h,

          // Text Field for note
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.s4.symmetric.horizontal,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: textController,
                  maxLines: 6,
                  minLines: 4,
                  maxLength: 500,
                  onChanged: (val) => controller.sessionNotes.value = val,
                  style: r14.copyWith(color: theme.textTheme.bodyLarge!.color),
                  inputFormatters: [LengthLimitingTextInputFormatter(500)],
                  decoration: InputDecoration(
                    hintText: "Tell us what’s on your mind...",
                    hintStyle: TextStyle(color: slate[400]),
                    fillColor: theme.cardTheme.color,
                    counterText:
                        "", // Hide default counter to design a premium one below
                  ),
                ),
                Spacing.s8.h,
                Obx(() {
                  return Text(
                    "${controller.sessionNotes.value.length}/500 characters",
                    style: r12.copyWith(
                      color: theme.textTheme.bodySmall!.color,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }),
              ],
            ),
          ),
          Spacing.s32.h,

          // Reassurance Box
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: Spacing.s4.symmetric.horizontal,
            ),
            padding: EdgeInsets.all(Spacing.s12.symmetric.horizontal),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: primary.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.shield_outlined, size: 20.r, color: primary),
                Spacing.s12.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Private & Secure",
                        style: r14.copyWith(
                          color: theme.textTheme.bodyLarge!.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacing.s4.h,
                      Text(
                        "Your shared details are private and will only be shared with your therapist before the session starts.",
                        style: r12.copyWith(
                          color: theme.textTheme.bodyMedium!.color!.withValues(
                            alpha: 0.8,
                          ),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Spacing.s24.h,
        ],
      ),
    );
  }
}
