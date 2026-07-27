import 'package:Mentora/controllers/bottom.nav.controller.dart';
import 'package:Mentora/infrastructure/navigation/routes.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/screens.dart';
import 'package:Mentora/widgets/others/custom.dashed.line.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';

import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});

  @override
  final controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: buildAppbar(context),
      body: buildBody(context),
    );
  }

  SingleChildScrollView buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
        vertical: Spacing.s4.symmetric.horizontal,
      ),
      child: Column(
        children: [
          buildTopBanner(),
          Spacing.s16.h,
          buildStreakAndProgressRow(context),
          Spacing.s16.h,
          buildMoodCheckinSection(context),
          Spacing.s16.h,
          buildConnectSection(context),
          Spacing.s16.h,
          buildMoodTrendsCard(context),
          Spacing.s16.h,
          buildTodayPlanSection(context),
        ],
      ),
    );
  }

  Widget buildStreakAndProgressRow(BuildContext context) {
    return Obx(() {
      final streak = controller.streakCount.value;
      final weeklyCount = controller.weeklyCheckInCount.value;
      return Row(
        children: [
          buildStatusCard(
            context: context,
            icon: '\u{f06d}', // fire icon
            iconColor: Colors.orange.shade800,
            iconBgColor: primary.withValues(alpha: 0.15),
            title: streak > 0 ? "$streak Days" : "0 Days",
            subtitle: "Active Streak 🔥",
          ),
          Spacing.s16.w,
          buildStatusCard(
            context: context,
            icon: '\u{f073}', // calendar icon
            iconColor: infoColor.withValues(alpha: 0.9),
            iconBgColor: primary.withValues(alpha: 0.15),
            title: "$weeklyCount / 7 Days",
            subtitle: "Weekly Progress",
          ),
        ],
      );
    });
  }

  Widget buildStatusCard({
    required BuildContext context,
    required String icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
  }) {
    return Expanded(
      child: CustomPrimaryCard(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                icon,
                style: TextStyle(
                  fontFamily: 'FontAwesomeSolid',
                  fontSize: 16.sp,
                  color: iconColor,
                ),
              ),
            ),
            Spacing.s12.w,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: r14.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: r10.copyWith(
                      color: Theme.of(context).textTheme.bodySmall!.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMoodTrendsCard(BuildContext context) {
    return Obx(() {
      final historyLength = controller.checkInDates.length;
      return GestureDetector(
        onTap: () {
          if (Get.isRegistered<BottamNavController>()) {
            Get.find<BottamNavController>().changeTabIndex(3);
          }
        },
        child: CustomPrimaryCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Mood Trends",
                    style: r18.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "View",
                        style: r12.copyWith(
                          color: primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacing.s8.w,
                      Text(
                        '\u{f054}', // angle-right
                        style: TextStyle(
                          fontFamily: 'FontAwesomeSolid',
                          fontSize: 10.sp,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacing.s12.h,
              if (historyLength < 3)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: slate[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text("🌟", style: TextStyle(fontSize: 24.sp)),
                      Spacing.s8.h,
                      Text(
                        "Check in a few more days to see your trends",
                        textAlign: TextAlign.center,
                        style: r12.copyWith(
                          color: Theme.of(context).textTheme.bodySmall!.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              else
                SizedBox(
                  height: 100.h,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: CustomPaint(
                      painter: MoodLineChartPainter(
                        checkInMoods: controller.checkInMoods,
                        primaryColor: primary,
                        textColor:
                            Theme.of(context).textTheme.bodySmall!.color ??
                            slate[500]!,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildTodayPlanSection(BuildContext context) {
    return Obx(() {
      final total = controller.plans.length;
      final completed = controller.plans.where((p) => p.isComplete).length;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your plan for today ($completed/$total)",
            textAlign: TextAlign.center,
            style: r18.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacing.s12.h,

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: total,
            itemBuilder: (context, index) {
              final plan = controller.plans[index];
              return buildTodayPlanTimelineTile(
                context,
                plan.title,
                plan.label,
                plan.caption,
                plan.icon,
                index == 0 ? true : false,
                index + 1 == total ? true : false,
                plan.isComplete,
                () {
                  controller.togglePlanCompletion(index);
                },
              );
            },
          ),
        ],
      );
    });
  }

  IntrinsicHeight buildTodayPlanTimelineTile(
    BuildContext context,
    String title,
    String label,
    String caption,
    String icon,
    bool isFirst,
    bool isLast,
    bool isComplete,
    Function()? onTap,
  ) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              CustomDashedLine(
                color: isFirst ? Colors.transparent : primary,
                width: 1.2,
              ),
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primary, width: 1.2),
                ),
                child: isComplete
                    ? Center(
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primary,
                          ),
                        ),
                      )
                    : SizedBox(),
              ),
              CustomDashedLine(
                color: isLast ? Colors.transparent : primary,
                width: 1.2,
              ),
            ],
          ),
          Spacing.s12.w,
          Expanded(
            child: Column(
              children: [
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: onTap,
                    child: CustomPrimaryCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title.toUpperCase(),
                                  style: r12.copyWith(
                                    color: primary,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                Spacing.s8.h,
                                Text(
                                  label,
                                  style: r16.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge!.color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Spacing.s4.h,
                                Text(
                                  caption,
                                  textAlign: TextAlign.center,
                                  style: r14.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodySmall!.color,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            icon,
                            style: TextStyle(
                              fontFamily: 'FontAwesomeSolid',
                              fontSize: 30.sp,
                              color: primary.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Spacing.s16.h,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildConnectSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: Get.width / 2.3,
          child: buildConnectTile(context, '\u{f544}', 'Chat with Mentora', () {
            Get.to(() => ChatAIScreen(), transition: Transition.rightToLeft);
          }), // Change Icon :- robot
        ),

        SizedBox(
          width: Get.width / 2.3,
          child: buildConnectTile(context, '\u{f0f0}', 'Talk with Experts', () {
            Get.to(
              () => ChatExpertsScreen(),
              transition: Transition.rightToLeft,
            );
          }), // Change Icon :- user-doctor
        ),
      ],
    );
  }

  Widget buildConnectTile(
    BuildContext context,
    String icon,
    String label,
    Function()? onTap,
  ) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: primary.withValues(alpha: .2),
        highlightColor: primary.withValues(alpha: .1),
        onTap: onTap,
        child: CustomPrimaryCard(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  icon,
                  style: TextStyle(
                    fontFamily: 'FontAwesomeSolid',
                    fontSize: 16.sp,
                    color: primary,
                  ),
                ),
              ),
              Spacing.s8.w,
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: r14.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMoodCheckinSection(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Get.toNamed(Routes.MOOD_CHECKIN);
      },
      child: CustomPrimaryCard(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "How do you feel today?",
                  textAlign: TextAlign.center,
                  style: r18.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Spacing.s12.h,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  "assets/moods/Angry Face.svg",
                  width: 45,
                  height: 45,
                ),
                SvgPicture.asset(
                  "assets/moods/Not Good Face.svg",
                  width: 45,
                  height: 45,
                ),
                SvgPicture.asset(
                  "assets/moods/Normal Face.svg",
                  width: 45,
                  height: 45,
                ),
                SvgPicture.asset(
                  "assets/moods/Happy Face.svg",
                  width: 45,
                  height: 45,
                ),
                SvgPicture.asset(
                  "assets/moods/Very Happy Face.svg",
                  width: 45,
                  height: 45,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTopBanner() {
    return Container(
      width: Get.width,
      height: Get.height / 4.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage("assets/images/banner.png"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColorLight,
      surfaceTintColor: Colors.transparent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: 25,
                width: 25,
                child: Image.asset('assets/logos/logo.png', fit: BoxFit.fill),
              ),
              Spacing.s12.w,
              Text(
                "Mentora",
                textAlign: TextAlign.center,
                style: h2.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          Row(
            children: [
              Text(
                MyIcons.magnifyingGlass,
                style: TextStyle(
                  fontFamily: 'FontAwesomeLight',
                  fontSize: 20,
                  color: slate[500],
                ),
              ),
              Spacing.s12.w,
              GestureDetector(
                onTap: () => Get.to(
                  () => AccountScreen(),
                  transition: Transition.rightToLeft,
                ),
                child: const CircleAvatar(
                  radius: 14,
                  backgroundImage: NetworkImage(
                    "https://austinfilm.s3.us-east-2.amazonaws.com/wp-content/uploads/2019/07/29115643/john-doe-jim-herrington-cropped-1024x675.jpg",
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }
}

class MoodLineChartPainter extends CustomPainter {
  final List<String> checkInMoods;
  final Color primaryColor;
  final Color textColor;

  MoodLineChartPainter({
    required this.checkInMoods,
    required this.primaryColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (checkInMoods.isEmpty) return;

    final moods = checkInMoods.length > 7
        ? checkInMoods.sublist(checkInMoods.length - 7)
        : checkInMoods;

    final double stepX =
        size.width / (moods.length - 1 == 0 ? 1 : moods.length - 1);
    final double height = size.height;
    final double padding = 12;

    // Draw horizontal dashed grid lines for mood levels
    final gridPaint = Paint()
      ..color = textColor.withValues(alpha: 0.1)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final double maxScoreY = padding;
    final double midScoreY = padding + 2.0 * (height - 2 * padding) / 4.0;
    final double minScoreY = padding + 4.0 * (height - 2 * padding) / 4.0;

    void drawDashedLine(double y) {
      double startX = 0;
      const dashWidth = 5.0;
      const dashSpace = 4.0;
      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, y),
          Offset(startX + dashWidth, y),
          gridPaint,
        );
        startX += dashWidth + dashSpace;
      }
    }

    drawDashedLine(maxScoreY);
    drawDashedLine(midScoreY);
    drawDashedLine(minScoreY);

    // Draw small text labels next to the grid lines
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    void drawLabel(String text, double y) {
      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(
          color: textColor.withValues(alpha: 0.4),
          fontSize: 8.sp,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(4.w, y - 12.h));
    }

    drawLabel("GREAT", maxScoreY);
    drawLabel("CALM", midScoreY);
    drawLabel("LOW", minScoreY);

    final points = <Offset>[];
    for (int i = 0; i < moods.length; i++) {
      double score = 3.0; // default normal
      switch (moods[i]) {
        case 'Very Good':
        case 'Very Happy':
          score = 5.0;
          break;
        case 'Good':
        case 'Happy':
          score = 4.0;
          break;
        case 'Normal':
          score = 3.0;
          break;
        case 'Not Good':
          score = 2.0;
          break;
        case 'Angry':
          score = 1.0;
          break;
      }

      final double y = padding + (5.0 - score) * (height - 2 * padding) / 4.0;
      final double x = i * stepX;
      points.add(Offset(x, y));
    }

    final path = Path();
    path.moveTo(points.first.dx, height);
    for (var point in points) {
      path.lineTo(point.dx, point.dy);
    }
    path.lineTo(points.last.dx, height);
    path.close();

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          primaryColor.withValues(alpha: 0.25),
          primaryColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTRB(0, 0, size.width, height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, gradientPaint);

    final linePaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      final p0 = points[i - 1];
      final p1 = points[i];
      final controlPoint1 = Offset(p0.dx + stepX / 2.0, p0.dy);
      final controlPoint2 = Offset(p1.dx - stepX / 2.0, p1.dy);
      linePath.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p1.dx,
        p1.dy,
      );
    }
    canvas.drawPath(linePath, linePaint);

    final dotPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    final dotBorderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (var point in points) {
      canvas.drawCircle(point, 5.0, dotPaint);
      canvas.drawCircle(point, 5.0, dotBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant MoodLineChartPainter oldDelegate) {
    return oldDelegate.checkInMoods != checkInMoods;
  }
}
