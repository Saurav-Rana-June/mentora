import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../infrastructure/theme/theme.dart';
import '../../widgets/buttons/custom_primary_button.widget.dart';
import 'controllers/booking_session_controller.dart';
import 'views/choose_session_view.dart';
import 'views/session_details_view.dart';
import 'views/review_booking_view.dart';
import 'views/booking_success_view.dart';

class BookingSessionScreen extends GetView<BookingSessionController> {
  BookingSessionScreen({super.key});

  @override
  final controller = Get.put(BookingSessionController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Handle android physical back button behavior
    return SafeArea(
      top: false,
      child: Obx(() {
        final step = controller.currentStep.value;

        return PopScope(
          canPop: step == 0 || step >= 3,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop && step > 0 && step < 3) {
              controller.previousStep();
            }
          },
          child: Scaffold(
            backgroundColor: theme.primaryColorLight,
            appBar: buildAppbar(context),
            body: buildBody(context),
            bottomNavigationBar: buildBottomCTA(context),
          ),
        );
      }),
    );
  }

  PreferredSizeWidget buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColorLight,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: Obx(() {
        final step = controller.currentStep.value;
        if (step >= 3)
          return const SizedBox.shrink(); // Hide back arrow on success

        return Center(
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              splashColor: primary.withValues(alpha: 0.3),
              onTap: () {
                if (step > 0) {
                  controller.previousStep();
                } else {
                  Get.back();
                }
              },
              child: Container(
                height: 40.h,
                width: 40.h,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    MyIcons.chevronLeft,
                    style: TextStyle(
                      fontFamily: 'FontAwesomeLight',
                      fontSize: 20,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
      title: Obx(() {
        final step = controller.currentStep.value;
        String title = "Book Session";
        if (step == 3) title = "Booking Confirmed";
        return Text(
          title,
          style: h2.copyWith(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontWeight: FontWeight.w600,
          ),
        );
      }),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        Obx(() => buildStepIndicator(context, controller.currentStep.value)),
        Spacing.s12.h,
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.s8.symmetric.horizontal,
            ),
            child: Obx(() {
              switch (controller.currentStep.value) {
                case 0:
                  return const ChooseSessionView();
                case 1:
                  return const SessionDetailsView();
                case 2:
                  return const ReviewBookingView();
                case 3:
                  return const BookingSuccessView();
                default:
                  return const ChooseSessionView();
              }
            }),
          ),
        ),
      ],
    );
  }

  Widget buildStepIndicator(BuildContext context, int currentStep) {
    if (currentStep >= 3) return const SizedBox.shrink();

    final steps = ["Time", "Details", "Review"];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Spacing.s16.value.w,
        vertical: Spacing.s12.value.h,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark ? slate[800] : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? slate[700]!
              : theme.dividerColor.withValues(alpha: 0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length, (index) {
          final isCompleted = index < currentStep;
          final isActive = index == currentStep;

          return Expanded(
            child: Row(
              children: [
                // Step pill container
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isActive
                        ? primary.withValues(alpha: 0.08)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Circle Indicator
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 24.r,
                        height: 24.r,
                        decoration: BoxDecoration(
                          color: isActive
                              ? primary
                              : isCompleted
                              ? primary.withValues(alpha: 0.15)
                              : (isDark ? slate[700] : slate[200]),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isActive
                                ? primary
                                : isCompleted
                                ? primary
                                : (isDark ? slate[600]! : slate[300]!),
                            width: 1.5,
                          ),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: primary.withValues(alpha: 0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: isCompleted
                              ? Icon(
                                  Icons.check_rounded,
                                  size: 14.r,
                                  color: primary,
                                )
                              : Text(
                                  (index + 1).toString(),
                                  style: r12.copyWith(
                                    color: isActive
                                        ? Colors.white
                                        : (isDark ? slate[300] : slate[600]),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      Spacing.s8.w,

                      // Label
                      Text(
                        steps[index],
                        style: r13.copyWith(
                          color: isActive
                              ? primary
                              : isCompleted
                              ? (isDark ? slate[200] : slate[700])
                              : (isDark ? slate[400] : slate[500]),
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Connecting progress line
                if (index < steps.length - 1) ...[
                  Spacing.s8.w,
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 2.h,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? primary
                            : (isDark ? slate[700] : slate[200]),
                        borderRadius: BorderRadius.circular(1.r),
                      ),
                    ),
                  ),
                  Spacing.s8.w,
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget? buildBottomCTA(BuildContext context) {
    return Obx(() {
      final step = controller.currentStep.value;
      if (step >= 3)
        return const SizedBox.shrink(); // Success screen has its own bottom buttons

      bool isEnabled = false;
      String buttonText = "Continue";

      if (step == 0) {
        isEnabled =
            controller.selectedDate.value != null &&
            controller.selectedTimeSlot.value != null;
      } else if (step == 1) {
        isEnabled = true; // Notes is optional, skip/continue always allowed
      } else if (step == 2) {
        isEnabled = true;
        buttonText = "Confirm Booking";
      }

      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s8.symmetric.horizontal,
          vertical: Spacing.s8.symmetric.vertical,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
        ),
        child: CustomPrimaryButton(
          text: buttonText,
          isLoading: controller.isLoading.value,
          onPressed: isEnabled
              ? () {
                  if (step == 2) {
                    controller.bookSession();
                  } else {
                    controller.nextStep();
                  }
                }
              : null,
        ),
      );
    });
  }
}
