import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../infrastructure/theme/theme.dart';
import '../../widgets/others/custom.primary.card.dart';
import 'controllers/sessions.controller.dart';

class SessionsScreen extends GetView<SessionsController> {
  SessionsScreen({super.key});

  @override
  final controller = Get.put(SessionsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: buildAppbar(context),
      body: buildBody(context),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColorLight,
      surfaceTintColor: Colors.transparent,
      title: Text(
        "Sessions",
        style: h2.copyWith(
          color: Theme.of(context).textTheme.bodyLarge!.color,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        Spacing.s8.h,
        buildTabbarSection(context),
        Spacing.s12.h,
        Expanded(
          child: Obx(() {
            final isUpcoming = controller.isUpcomingSelected.value;
            final sessionsList = isUpcoming
                ? controller.upcomingSessions
                : controller.completedSessions;

            return buildSessionList(context, sessionsList, isUpcoming: isUpcoming);
          }),
        ),
      ],
    );
  }

  Widget buildTabbarSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Spacing.s12.symmetric.horizontal,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: primary.withValues(alpha: 0.15),
      ),
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          Expanded(
            child: buildTabButton(
              context: context,
              label: "Upcoming",
              isSelected: true,
            ),
          ),
          Expanded(
            child: buildTabButton(
              context: context,
              label: "Completed",
              isSelected: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTabButton({
    required BuildContext context,
    required String label,
    required bool isSelected,
  }) {
    return Obx(() {
      final active = controller.isUpcomingSelected.value == isSelected;
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.toggleTab(isSelected),
          borderRadius: BorderRadius.circular(30),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: active ? primary : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Center(
              child: Text(
                label,
                style: r14.copyWith(
                  color: active ? white : primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget buildSessionList(
    BuildContext context,
    List<SessionModel> sessions, {
    required bool isUpcoming,
  }) {
    if (sessions.isEmpty) {
      return buildEmptyState(
        context,
        isUpcoming
            ? "No upcoming sessions scheduled."
            : "No completed sessions yet.",
      );
    }
    return ListView.builder(
      itemCount: sessions.length,
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s12.symmetric.horizontal,
        vertical: Spacing.s4.symmetric.horizontal,
      ),
      itemBuilder: (context, index) {
        final session = sessions[index];
        return buildSessionTile(context, session);
      },
    );
  }

  Widget buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '\u{f073}', // calendar icon
            style: TextStyle(
              fontFamily: 'FontAwesomeLight',
              fontSize: 50,
              color: slate[400],
            ),
          ),
          Spacing.s12.h,
          Text(
            message,
            style: r16.copyWith(
              color: Theme.of(context).textTheme.bodySmall!.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSessionTile(BuildContext context, SessionModel session) {
    final isCompleted = session.status == "Completed";
    final badgeColor = isCompleted ? successColor : primary;

    return Padding(
      padding: EdgeInsets.only(bottom: Spacing.s12.symmetric.horizontal),
      child: CustomPrimaryCard(
        padding: EdgeInsets.all(Spacing.s12.symmetric.horizontal),
        borderRadius: 12,
        child: Row(
          children: [
            CircleAvatar(
              radius: 28.r,
              backgroundImage: NetworkImage(session.imageUrl),
              backgroundColor: Theme.of(context).primaryColorLight,
            ),
            Spacing.s12.w,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.expertName,
                    style: r16.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacing.s4.h,
                  Text(
                    session.specialty,
                    style: r14.copyWith(
                      color: Theme.of(context).textTheme.bodySmall!.color,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Spacing.s8.h,
                  Row(
                    children: [
                      Text(
                        '\u{f073}', // calendar-alt
                        style: TextStyle(
                          fontFamily: 'FontAwesomeRegular',
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall!.color,
                        ),
                      ),
                      Spacing.s4.w,
                      Expanded(
                        child: Text(
                          session.dateTime,
                          style: r12.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacing.s12.w,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    session.status,
                    style: r12.copyWith(
                      color: badgeColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Spacing.s8.h,
                Row(
                  children: [
                    Text(
                      session.callType == "Video Call"
                          ? '\u{f03d}' // video
                          : '\u{f095}', // phone
                      style: TextStyle(
                        fontFamily: 'FontAwesomeSolid',
                        fontSize: 12,
                        color: primary,
                      ),
                    ),
                    Spacing.s4.w,
                    Text(
                      session.callType,
                      style: r12.copyWith(
                        color: Theme.of(context).textTheme.bodySmall!.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Get.snackbar(
          "Booking Flow",
          "Session booking flow coming soon!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primary,
          colorText: white,
          margin: EdgeInsets.all(Spacing.s16.symmetric.horizontal),
          borderRadius: 12,
        );
      },
      backgroundColor: primary,
      child: Text(
        '\u{f067}', // plus icon
        style: TextStyle(
          fontFamily: 'FontAwesomeSolid',
          fontSize: 20,
          color: white,
        ),
      ),
    );
  }
}
