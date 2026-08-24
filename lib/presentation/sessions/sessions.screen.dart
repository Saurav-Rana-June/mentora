import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/theme/theme.dart';
import '../../widgets/others/custom.primary.appbar.dart';
import '../../widgets/others/custom.primary.card.dart';
import '../../widgets/others/custom.divider.dart';
import '../../widgets/others/custom.screen.wrapper.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'controllers/sessions.controller.dart';

class SessionsScreen extends GetView<SessionsController> {
  SessionsScreen({super.key});

  @override
  final controller = Get.put(SessionsController());

  @override
  Widget build(BuildContext context) {
    return CustomScreenWrapper(
      appBar: buildAppbar(context),
      body: buildBody(context),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  PreferredSizeWidget buildAppbar(BuildContext context) {
    return CustomPrimaryAppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 25,
            width: 25,
            child: Image.asset('assets/logos/logo.png', fit: BoxFit.fill),
          ),
          Text(
            "Sessions",
            textAlign: TextAlign.center,
            style: h2.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 25,
            width: 25,
            child: Center(
              child: Text(
                MyIcons.magnifyingGlass,
                style: TextStyle(
                  fontFamily: 'FontAwesomeLight',
                  fontSize: 20,
                  color: slate[500],
                ),
              ),
            ),
          ),
        ],
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
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final isUpcoming = controller.isUpcomingSelected.value;
            final sessionsList = isUpcoming
                ? controller.upcomingSessions
                : controller.completedSessions;

            return buildSessionList(
              context,
              sessionsList,
              isUpcoming: isUpcoming,
            );
          }),
        ),
      ],
    );
  }

  Widget buildTabbarSection(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Spacing.s8.symmetric.horizontal),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: primary.withValues(alpha: 0.08),
        border: Border.all(
          color: theme.dividerTheme.color ?? primary.withValues(alpha: 0.08),
          width: 0.8,
        ),
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
      return RefreshIndicator(
        onRefresh: () => controller.fetchSessions(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.6,
            child: buildEmptyState(
              context,
              isUpcoming
                  ? "No upcoming sessions scheduled."
                  : "No completed sessions yet.",
            ),
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () => controller.fetchSessions(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: sessions.length,
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s8.symmetric.horizontal,
          vertical: Spacing.s4.symmetric.horizontal,
        ),
        itemBuilder: (context, index) {
          final session = sessions[index];
          return buildSessionTile(context, session);
        },
      ),
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
    final theme = Theme.of(context);
    final isCompleted = session.status == "Completed";

    final Color badgeColor;
    switch (session.status.toLowerCase()) {
      case 'completed':
        badgeColor = successColor;
        break;
      case 'confirmed':
        badgeColor = infoColor;
        break;
      case 'scheduled':
        badgeColor = warningColor;
        break;
      case 'cancelled':
      case 'canceled':
      case 'declined':
        badgeColor = dangerColor;
        break;
      default:
        badgeColor = primary;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: Spacing.s12.symmetric.horizontal),
      child: CustomPrimaryCard(
        padding: EdgeInsets.all(Spacing.s12.symmetric.horizontal),
        borderRadius: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Call Type and Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Call Type Info
                Row(
                  children: [
                    Icon(
                      session.callType == "Video Call"
                          ? Icons.videocam_outlined
                          : Icons.phone_outlined,
                      size: 18,
                      color: primary,
                    ),
                    Spacing.s8.w,
                    Text(
                      session.callType,
                      style: r12.copyWith(
                        color: theme.textTheme.bodyMedium!.color!.withValues(
                          alpha: 0.8,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: badgeColor.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6.r,
                        height: 6.r,
                        decoration: BoxDecoration(
                          color: badgeColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Spacing.s8.w,
                      Text(
                        session.status,
                        style: r12.copyWith(
                          color: badgeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Spacing.s12.h,
            const CustomDivider(),
            Spacing.s16.h,

            // Middle Row: Avatar and Details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primary.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 28.r,
                    backgroundImage: NetworkImage(session.imageUrl),
                    backgroundColor: theme.primaryColorLight,
                  ),
                ),
                Spacing.s16.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.expertName,
                        style: r16.copyWith(
                          color: theme.textTheme.bodyLarge!.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacing.s4.h,
                      Text(
                        session.specialty,
                        style: r14.copyWith(
                          color: theme.textTheme.bodySmall!.color,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Spacing.s8.h,
                      Row(
                        children: [
                          Text(
                            '\u{f073}', // calendar icon
                            style: TextStyle(
                              fontFamily: 'FontAwesomeRegular',
                              fontSize: 12,
                              color: primary,
                            ),
                          ),
                          Spacing.s8.w,
                          Expanded(
                            child: Text(
                              session.dateTime,
                              style: r12.copyWith(
                                color: theme.textTheme.bodyMedium!.color!
                                    .withValues(alpha: 0.85),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (!isCompleted) ...[
              Spacing.s20.h,
              CustomPrimaryButton(
                text: "Join Session",
                borderRadius: 100,
                height: 45.h,
                backgroundColor: primary,
                suffixIcon: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: Colors.white,
                ),
                textStyle: r14.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                onPressed: () {},
              ),
            ],
          ],
        ),
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Get.toNamed(Routes.DOCTOR_LIST);
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
