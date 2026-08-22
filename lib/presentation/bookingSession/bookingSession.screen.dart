import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../infrastructure/theme/theme.dart';
import '../../widgets/buttons/custom_primary_button.widget.dart';
import '../../widgets/buttons/custom_outline_button.widget.dart';
import '../../widgets/others/custom.primary.bottombar.dart';
import 'controllers/booking_session_controller.dart';
import 'views/choose_session_view.dart';
import 'views/session_type_view.dart';
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
        Spacing.s16.h,
        Obx(() => buildStepIndicator(context, controller.currentStep.value)),
        Spacing.s12.h,
        Expanded(
          child: Obx(() {
            switch (controller.currentStep.value) {
              case 0:
                return const ChooseSessionView();
              case 1:
                return const SessionTypeView();
              case 2:
                return const SessionDetailsView();
              case 3:
                return const ReviewBookingView();
              case 4:
                return const BookingSuccessView();
              default:
                return const ChooseSessionView();
            }
          }),
        ),
      ],
    );
  }

  Widget buildStepIndicator(BuildContext context, int currentStep) {
    if (currentStep >= 4) return const SizedBox.shrink();

    final steps = ["Time", "Type", "Details", "Review"];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        // Background Connecting Lines
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: 32.r, // Centered vertically with 32.r height circles
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),
              ...List.generate(steps.length - 1, (index) {
                final isLineCompleted = index < currentStep;
                return Expanded(
                  flex: 2,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: isLineCompleted
                          ? primary
                          : (isDark ? slate[700] : slate[200]),
                      borderRadius: BorderRadius.circular(1.5.h),
                    ),
                  ),
                );
              }),
              const Spacer(flex: 1),
            ],
          ),
        ),

        // Steps (Circles & Labels)
        Row(
          children: List.generate(steps.length, (index) {
            final isCompleted = index < currentStep;
            final isActive = index == currentStep;

            return Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Circle Indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 32.r,
                    height: 32.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? primary
                          : isActive
                          ? theme.cardTheme.color
                          : (isDark ? slate[800] : slate[50]),
                      border: Border.all(
                        color: isCompleted || isActive
                            ? primary
                            : (isDark ? slate[700]! : slate[300]!),
                        width: isActive ? 2 : 1.5,
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: primary.withValues(alpha: 0.25),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: isCompleted
                            ? Icon(
                                Icons.check_rounded,
                                key: const ValueKey("check"),
                                size: 18.r,
                                color: Colors.white,
                              )
                            : isActive
                            ? Container(
                                key: const ValueKey("active"),
                                width: 20.r,
                                height: 20.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primary,
                                ),
                                child: Center(
                                  child: Text(
                                    (index + 1).toString(),
                                    style: r10.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : Text(
                                (index + 1).toString(),
                                key: const ValueKey("upcoming"),
                                style: r12.copyWith(
                                  color: isDark ? slate[400] : slate[500],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                  Spacing.s8.h,

                  // Label
                  Text(
                    steps[index],
                    style: r12.copyWith(
                      color: isActive
                          ? primary
                          : isCompleted
                          ? (isDark ? slate[200] : slate[700])
                          : (isDark ? slate[500] : slate[400]),
                      fontWeight: isActive
                          ? FontWeight.w700
                          : isCompleted
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget? buildBottomCTA(BuildContext context) {
    return Obx(() {
      final step = controller.currentStep.value;
      if (step >= 4)
        return const SizedBox.shrink(); // Success screen has its own bottom buttons

      bool isEnabled = false;
      String buttonText = "Continue";

      if (step == 0) {
        isEnabled =
            controller.selectedDate.value != null &&
            controller.selectedTimeSlot.value != null;
      } else if (step == 1) {
        isEnabled = controller.selectedSessionType.value.isNotEmpty;
      } else if (step == 2) {
        isEnabled = true; // Notes is optional, skip/continue always allowed
      } else if (step == 3) {
        isEnabled = true;
        buttonText = "Confirm Booking";
      }

      final isLight = Theme.of(context).brightness == Brightness.light;
      final continueButton = CustomPrimaryButton(
        text: buttonText,
        isLoading: controller.isLoading.value,
        backgroundColor: primary,
        textColor: Colors.white,
        height: 42.h,
        borderRadius: 26.r,
        onPressed: isEnabled
            ? () {
                if (step == 3) {
                  controller.bookSession();
                } else {
                  controller.nextStep();
                }
              }
            : null,
      );

      return CustomPrimaryBottomBar(
        backgroundColor: Theme.of(context).cardTheme.color,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s8.symmetric.horizontal,
          vertical: Spacing.s8.symmetric.vertical,
        ),
        child: step > 0
            ? Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomOutlineButton(
                      label: "Back",
                      onTap: () {
                        controller.previousStep();
                      },
                      height: 42.h,
                      borderRadius: 26.r,
                      borderColor: isLight ? primary : slate[600],
                      textColor: isLight ? primary : Colors.white70,
                    ),
                  ),
                  Spacing.s16.w,
                  Expanded(flex: 2, child: continueButton),
                ],
              )
            : continueButton,
      );
    });
  }
}
