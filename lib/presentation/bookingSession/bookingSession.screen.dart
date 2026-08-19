import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../infrastructure/theme/theme.dart';
import '../../widgets/buttons/custom_primary_button.widget.dart';
import 'controllers/booking_session_controller.dart';
import 'views/choose_doctor_view.dart';
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
          canPop: step == 0 || step >= 4,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop && step > 0 && step < 4) {
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
        if (step >= 4)
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
        if (step == 4) title = "Booking Confirmed";
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
                  return const ChooseDoctorView();
                case 1:
                  return const ChooseSessionView();
                case 2:
                  return const SessionDetailsView();
                case 3:
                  return const ReviewBookingView();
                case 4:
                  return const BookingSuccessView();
                default:
                  return const ChooseDoctorView();
              }
            }),
          ),
        ),
      ],
    );
  }

  Widget buildStepIndicator(BuildContext context, int currentStep) {
    if (currentStep >= 4) return const SizedBox.shrink();

    final steps = ["Doctor", "Time", "Details", "Review"];
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: theme.primaryColorLight,
      child: Row(
        children: List.generate(steps.length, (index) {
          final isCompleted = index < currentStep;
          final isActive = index == currentStep;

          return Expanded(
            child: Row(
              children: [
                // Step Circle
                Container(
                  width: 22.r,
                  height: 22.r,
                  decoration: BoxDecoration(
                    color: isActive
                        ? primary
                        : isCompleted
                        ? primary.withValues(alpha: 0.12)
                        : theme.dividerColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? Icon(Icons.check, size: 12.r, color: primary)
                        : Text(
                            (index + 1).toString(),
                            style: r10.copyWith(
                              color: isActive
                                  ? Colors.white
                                  : theme.textTheme.bodySmall!.color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
                Spacing.s8.w,

                // Step Name
                Text(
                  steps[index],
                  style: r12.copyWith(
                    color: isActive
                        ? primary
                        : theme.textTheme.bodySmall!.color,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),

                // Connecting Line
                if (index < steps.length - 1) ...[
                  Spacing.s8.w,
                  Expanded(
                    child: Container(
                      height: 1.h,
                      color: isCompleted
                          ? primary.withValues(alpha: 0.4)
                          : theme.dividerColor.withValues(alpha: 0.1),
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
      if (step >= 4)
        return const SizedBox.shrink(); // Succes screen has its own bottom buttons

      bool isEnabled = false;
      String buttonText = "Continue";

      if (step == 0) {
        isEnabled = controller.selectedDoctor.value != null;
      } else if (step == 1) {
        isEnabled =
            controller.selectedDate.value != null &&
            controller.selectedTimeSlot.value != null;
      } else if (step == 2) {
        isEnabled = true; // Notes is optional, skip/continue always allowed
      } else if (step == 3) {
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
                  if (step == 3) {
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
