import 'dart:math';
import 'package:Mentora/presentation/home/controllers/home.controller.dart';
import 'package:Mentora/widgets/others/custom.circular.progressbar.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:Mentora/widgets/others/custom.toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../infrastructure/theme/theme.dart';
import 'controllers/insights.controller.dart';
import 'package:Mentora/controllers/global.controller.dart';

class GrowthAreaModel {
  final String title;
  final double progress;
  final String tip;
  final IconData icon;

  GrowthAreaModel({
    required this.title,
    required this.progress,
    required this.tip,
    required this.icon,
  });
}

class InsightsScreen extends GetView<InsightsController> {
  InsightsScreen({super.key});

  @override
  final controller = Get.put(InsightsController());

  final List<GrowthAreaModel> growthAreasList = [
    GrowthAreaModel(
      title: "Mental Health",
      progress: 0.7,
      tip: "Reflect on today's positives using your personal journal.",
      icon: Icons.favorite_outline,
    ),
    GrowthAreaModel(
      title: "Growth Mindset",
      progress: 0.5,
      tip:
          "Choose one challenge today and approach it as a learning opportunity.",
      icon: Icons.psychology_outlined,
    ),
    GrowthAreaModel(
      title: "Relationships",
      progress: 0.9,
      tip:
          "Reach out to your trusted contact or a close friend to stay connected.",
      icon: Icons.people_outline,
    ),
    GrowthAreaModel(
      title: "Personal Development",
      progress: 0.7,
      tip:
          "Spend 10 minutes reading an educational or self-development article.",
      icon: Icons.menu_book_outlined,
    ),
    GrowthAreaModel(
      title: "Self-awareness",
      progress: 0.5,
      tip:
          "Sit quietly for a minute and check-in on how you are feeling physically and emotionally.",
      icon: Icons.self_improvement_outlined,
    ),
    GrowthAreaModel(
      title: "Stress Management",
      progress: 0.9,
      tip:
          "Try a 5-minute Box Breathing exercise to regulate your stress levels.",
      icon: Icons.air_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: buildAppbar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s8.symmetric.horizontal,
          vertical: Spacing.s4.symmetric.horizontal,
        ),
        child: Column(
          children: [
            Obx(() => buildPersonalizedCoachingCard(context, homeController)),
            buildGrowthAreaCard(context),
            Spacing.s20.h,
            buildMoodTrackerCard(context, homeController),
            Spacing.s12.h,
          ],
        ),
      ),
    );
  }

  Widget buildPersonalizedCoachingCard(
    BuildContext context,
    HomeController homeController,
  ) {
    final theme = Theme.of(context);
    final consistency = controller.getCheckInConsistency(homeController);
    final dominant = controller.getDominantMood(homeController);

    String title = "Consistency is Key!";
    String description =
        "Excellent job! You are building a powerful habit of self-awareness. Try out a new meditation class today.";
    String icon = '\u{f058}'; // circle-check solid

    if (consistency < 0.5) {
      title = "Let's Check In More Often!";
      description =
          "Daily check-ins help us paint a clearer picture of your emotional trends. Try setting a reminder!";
      icon = '\u{f073}'; // calendar solid
    } else if (dominant == "Not Good" || dominant == "Angry") {
      title = "Mindful Healing Support";
      description =
          "We noticed your mood has been a bit low lately. Consider exploring the Stress Management sessions.";
      icon = '\u{f06c}'; // leaf solid
    }

    return Container(
      margin: EdgeInsets.only(bottom: Spacing.s12.symmetric.horizontal),
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s12.symmetric.horizontal,
        vertical: Spacing.s12.symmetric.horizontal,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            primary.withValues(alpha: 0.2),
            primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: primary.withValues(alpha: 0.25), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Text(
              icon,
              style: TextStyle(
                fontFamily: 'FontAwesomeSolid',
                fontSize: 20,
                color: primary,
              ),
            ),
          ),
          Spacing.s20.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: r16.copyWith(
                    color: theme.textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacing.s4.h,
                Text(
                  description,
                  style: r14.copyWith(
                    color: theme.textTheme.bodyMedium!.color!.withValues(
                      alpha: 0.85,
                    ),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGrowthAreaCard(BuildContext context) {
    return CustomPrimaryCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Growth Area",
                textAlign: TextAlign.center,
                style: r18.copyWith(fontWeight: FontWeight.w600),
              ),
              Obx(
                () => CustomToggle(
                  selectedIndex: controller.selectedGrowthTab.value,
                  onChanged: controller.toggleGrowthTab,
                  width: 100.w,
                  unselectedColor: primary,
                  children: const [
                    Text(
                      '\u{f624}', // gauge icon
                      style: TextStyle(fontFamily: 'FontAwesomeSolid'),
                    ),
                    Text(
                      '\u{e0e7}', // chart-radar icon
                      style: TextStyle(fontFamily: 'FontAwesomeSolid'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacing.s4.h,
          const Divider(),
          Spacing.s16.h,
          Obx(() {
            if (controller.selectedGrowthTab.value == 0) {
              return buildGrowthGridView(context);
            } else {
              return Column(
                children: [
                  SizedBox(
                    height: 200.h,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: GrowthRadarChartPainter(
                        growthAreas: growthAreasList,
                        primaryColor: primary,
                        textColor:
                            Theme.of(context).textTheme.bodyLarge!.color ??
                            slate[900]!,
                      ),
                    ),
                  ),
                  Spacing.s20.h,
                  buildGrowthDetailedView(context),
                ],
              );
            }
          }),
        ],
      ),
    );
  }

  Widget buildGrowthGridView(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildGrowthProgressIndicators(
              context,
              growthAreasList[0].progress,
              growthAreasList[0].title,
            ),
            buildGrowthProgressIndicators(
              context,
              growthAreasList[1].progress,
              growthAreasList[1].title,
            ),
            buildGrowthProgressIndicators(
              context,
              growthAreasList[2].progress,
              growthAreasList[2].title,
            ),
          ],
        ),
        Spacing.s16.h,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildGrowthProgressIndicators(
              context,
              growthAreasList[3].progress,
              growthAreasList[3].title,
            ),
            buildGrowthProgressIndicators(
              context,
              growthAreasList[4].progress,
              growthAreasList[4].title,
            ),
            buildGrowthProgressIndicators(
              context,
              growthAreasList[5].progress,
              growthAreasList[5].title,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildGrowthDetailedView(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: growthAreasList.map((area) {
        return Container(
          margin: EdgeInsets.only(bottom: Spacing.s12.symmetric.horizontal),
          padding: EdgeInsets.all(Spacing.s12.symmetric.horizontal),
          decoration: BoxDecoration(
            color: theme.primaryColorLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: slate[100]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(area.icon, color: primary, size: 20),
                      Spacing.s8.w,
                      Text(
                        area.title,
                        style: r14.copyWith(
                          color: theme.textTheme.bodyLarge!.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${(area.progress * 100).toInt()}%",
                    style: r14.copyWith(
                      color: primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Spacing.s8.h,
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: area.progress,
                  minHeight: 6.h,
                  backgroundColor: slate[100],
                  valueColor: AlwaysStoppedAnimation<Color>(primary),
                ),
              ),
              Spacing.s8.h,
              Text(
                area.tip,
                style: r12.copyWith(
                  color: theme.textTheme.bodyMedium!.color!.withValues(
                    alpha: 0.8,
                  ),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget buildGrowthProgressIndicators(
    BuildContext context,
    double percentage,
    String title,
  ) {
    return Column(
      children: [
        CustomCircularProgressBar(
          percentage: percentage,
          size: Get.height / 9.5,
          strokeWidth: 8,
          backgroundColor: slate[100]!,
          progressColor: primary,
          textStyle: r16.copyWith(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontWeight: FontWeight.bold,
          ),
          onComplete: () {},
        ),
        Spacing.s8.h,
        SizedBox(
          width: Get.height / 9.5,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: r12.copyWith(
              color: Theme.of(context).textTheme.bodyMedium!.color,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget buildMoodTrackerCard(
    BuildContext context,
    HomeController homeController,
  ) {
    final theme = Theme.of(context);
    return CustomPrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Mood Tracker",
                textAlign: TextAlign.center,
                style: r18.copyWith(
                  color: theme.textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Obx(
                () => CustomToggle(
                  selectedIndex: controller.selectedMoodTab.value,
                  onChanged: controller.toggleMoodTab,
                  width: 140.w,
                  unselectedColor: primary,
                  children: const [Text("Weekly"), Text("Monthly")],
                ),
              ),
            ],
          ),
          Spacing.s4.h,
          const Divider(),
          Spacing.s16.h,
          Obx(() {
            final globalController = Get.find<GlobalController>();

            if (globalController.isLoadingMoodTracker.value) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 36.h),
                  child: CircularProgressIndicator(
                    color: primary,
                    strokeWidth: 2.5,
                  ),
                ),
              );
            }

            final stats = controller.selectedMoodTab.value == 0
                ? globalController.weeklyMoodStats.value
                : globalController.monthlyMoodStats.value;

            final apiMoods =
                stats?.data
                    ?.map((d) => d.feeling)
                    .whereType<String>()
                    .toList() ??
                [];

            if (apiMoods.isEmpty) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 36.h),
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
                      style: r14.copyWith(
                        color: theme.textTheme.bodySmall!.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  SizedBox(
                    height: 150.h,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: controller.selectedMoodTab.value == 0
                          ? InsightsMoodLineChartPainter(
                              checkInMoods: apiMoods,
                              primaryColor: primary,
                              textColor:
                                  theme.textTheme.bodySmall!.color ??
                                  slate[500]!,
                            )
                          : InsightsMoodBarChartPainter(
                              checkInMoods: apiMoods,
                              primaryColor: primary,
                              textColor:
                                  theme.textTheme.bodySmall!.color ??
                                  slate[500]!,
                            ),
                    ),
                  ),
                  Spacing.s20.h,
                  buildMoodStatsRow(context, homeController),
                ],
              );
            }
          }),
          Spacing.s12.h,
        ],
      ),
    );
  }

  Widget buildMoodStatsRow(
    BuildContext context,
    HomeController homeController,
  ) {
    final theme = Theme.of(context);
    final globalController = Get.find<GlobalController>();
    final isWeekly = controller.selectedMoodTab.value == 0;
    final stats = isWeekly
        ? globalController.weeklyMoodStats.value
        : globalController.monthlyMoodStats.value;

    final dominant = stats?.dominantMood ?? 'No data yet';
    final consistency = stats?.consistency ?? 0.0;
    final consistencyPercentage = "${(consistency * 100).toInt()}%";

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(Spacing.s12.symmetric.horizontal),
            decoration: BoxDecoration(
              color: theme.primaryColorLight.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: slate[100]!),
            ),
            child: Column(
              children: [
                Text(
                  "Dominant Mood",
                  style: r12.copyWith(color: theme.textTheme.bodySmall!.color),
                ),
                Spacing.s4.h,
                Text(
                  dominant == 'Very Good' ? 'V. Good' : dominant,
                  style: r20.copyWith(
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Spacing.s12.w,
        Expanded(
          child: Container(
            padding: EdgeInsets.all(Spacing.s12.symmetric.horizontal),
            decoration: BoxDecoration(
              color: theme.primaryColorLight.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: slate[100]!),
            ),
            child: Column(
              children: [
                Text(
                  "Consistency",
                  style: r12.copyWith(color: theme.textTheme.bodySmall!.color),
                ),
                Spacing.s4.h,
                Text(
                  consistencyPercentage,
                  style: r20.copyWith(
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColorLight,
      surfaceTintColor: Colors.transparent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 25,
            width: 25,
            child: Image.asset('assets/logos/logo.png', fit: BoxFit.fill),
          ),
          Text(
            "Insights",
            textAlign: TextAlign.center,
            style: h2.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              splashColor: primary.withValues(alpha: 0.3),
              onTap: () {},
              child: SizedBox(
                height: 30.h,
                width: 30.h,
                child: Center(
                  child: Text(
                    '\u{f142}', // ellipsis-vertical icon
                    style: TextStyle(
                      fontFamily: 'FontAwesomeLight',
                      fontSize: 20,
                      color: slate[500],
                    ),
                  ),
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
}

class InsightsMoodLineChartPainter extends CustomPainter {
  final List<String> checkInMoods;
  final Color primaryColor;
  final Color textColor;

  InsightsMoodLineChartPainter({
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
    final double padding = 15;

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
      double score = 3.0;
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
      canvas.drawCircle(point, 6.0, dotPaint);
      canvas.drawCircle(point, 6.0, dotBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant InsightsMoodLineChartPainter oldDelegate) {
    return oldDelegate.checkInMoods != checkInMoods;
  }
}

class InsightsMoodBarChartPainter extends CustomPainter {
  final List<String> checkInMoods;
  final Color primaryColor;
  final Color textColor;

  InsightsMoodBarChartPainter({
    required this.checkInMoods,
    required this.primaryColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (checkInMoods.isEmpty) return;

    final moods = checkInMoods.length > 30
        ? checkInMoods.sublist(checkInMoods.length - 30)
        : checkInMoods;

    final Map<String, int> counts = {
      'Great': 0,
      'Good': 0,
      'Normal': 0,
      'Low': 0,
      'Angry': 0,
    };

    for (var m in moods) {
      switch (m) {
        case 'Very Good':
        case 'Very Happy':
          counts['Great'] = counts['Great']! + 1;
          break;
        case 'Good':
        case 'Happy':
          counts['Good'] = counts['Good']! + 1;
          break;
        case 'Normal':
          counts['Normal'] = counts['Normal']! + 1;
          break;
        case 'Not Good':
          counts['Low'] = counts['Low']! + 1;
          break;
        case 'Angry':
          counts['Angry'] = counts['Angry']! + 1;
          break;
      }
    }

    final keys = ['Angry', 'Low', 'Normal', 'Good', 'Great'];
    int maxVal = counts.values.reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) maxVal = 1;

    final double width = size.width;
    final double height = size.height;
    final double padding = 20;

    final double chartWidth = width - 2 * padding;
    final double chartHeight = height - 2 * padding;

    final double barSpacing = chartWidth / (keys.length * 2);
    final double barWidth = chartWidth / keys.length - barSpacing;

    final paint = Paint()..style = PaintingStyle.fill;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < keys.length; i++) {
      final key = keys[i];
      final count = counts[key]!;

      final double x = padding + i * (barWidth + barSpacing) + barSpacing / 2;
      final double barValHeight = (count / maxVal) * chartHeight;
      final double y = height - padding - barValHeight;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTRB(x, y, x + barWidth, height - padding),
        const Radius.circular(6),
      );

      paint.shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [primaryColor, primaryColor.withValues(alpha: 0.4)],
      ).createShader(Rect.fromLTRB(x, y, x + barWidth, height - padding));

      canvas.drawRRect(rect, paint);

      if (count > 0) {
        textPainter.text = TextSpan(
          text: '$count',
          style: TextStyle(
            color: textColor,
            fontSize: 9.sp,
            fontWeight: FontWeight.bold,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x + (barWidth - textPainter.width) / 2, y - 12.h),
        );
      }

      textPainter.text = TextSpan(
        text: key,
        style: TextStyle(
          color: textColor.withValues(alpha: 0.6),
          fontSize: 9.sp,
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x + (barWidth - textPainter.width) / 2, height - padding + 4.h),
      );
    }
  }

  @override
  bool shouldRepaint(covariant InsightsMoodBarChartPainter oldDelegate) {
    return oldDelegate.checkInMoods != checkInMoods;
  }
}

class GrowthRadarChartPainter extends CustomPainter {
  final List<GrowthAreaModel> growthAreas;
  final Color primaryColor;
  final Color textColor;

  GrowthRadarChartPainter({
    required this.growthAreas,
    required this.primaryColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (growthAreas.isEmpty) return;

    final double width = size.width;
    final double height = size.height;
    final center = Offset(width / 2, height / 2);
    final double maxRadius = (height / 2) - 25.h;

    final int sides = growthAreas.length;
    final double angleStep = (2 * pi) / sides;

    final gridPaint = Paint()
      ..color = textColor.withValues(alpha: 0.08)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final int levels = 5;
    for (int l = 1; l <= levels; l++) {
      final double r = maxRadius * (l / levels);
      final path = Path();
      for (int i = 0; i < sides; i++) {
        final double angle = i * angleStep - pi / 2;
        final double x = center.dx + r * cos(angle);
        final double y = center.dy + r * sin(angle);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    for (int i = 0; i < sides; i++) {
      final double angle = i * angleStep - pi / 2;
      final double x = center.dx + maxRadius * cos(angle);
      final double y = center.dy + maxRadius * sin(angle);
      canvas.drawLine(center, Offset(x, y), gridPaint);
    }

    final progressPath = Path();
    final points = <Offset>[];

    for (int i = 0; i < sides; i++) {
      final double progress = growthAreas[i].progress;
      final double r = maxRadius * progress;
      final double angle = i * angleStep - pi / 2;
      final double x = center.dx + r * cos(angle);
      final double y = center.dy + r * sin(angle);
      points.add(Offset(x, y));

      if (i == 0) {
        progressPath.moveTo(x, y);
      } else {
        progressPath.lineTo(x, y);
      }
    }
    progressPath.close();

    final fillPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;
    canvas.drawPath(progressPath, fillPaint);

    final borderPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawPath(progressPath, borderPaint);

    final dotPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    final dotBorderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (var point in points) {
      canvas.drawCircle(point, 4.0, dotPaint);
      canvas.drawCircle(point, 4.0, dotBorderPaint);
    }

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < sides; i++) {
      final double angle = i * angleStep - pi / 2;
      final double labelRadius = maxRadius + 10.w;

      final double x = center.dx + labelRadius * cos(angle);
      final double y = center.dy + labelRadius * sin(angle);

      final labelText = growthAreas[i].title;

      textPainter.text = TextSpan(
        text: labelText,
        style: TextStyle(
          color: textColor.withValues(alpha: 0.7),
          fontSize: 8.sp,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();

      double paintX = x - (textPainter.width / 2);
      double paintY = y - (textPainter.height / 2);

      if (cos(angle) < -0.1) {
        paintX = x - textPainter.width - 2.w;
      } else if (cos(angle) > 0.1) {
        paintX = x + 2.w;
      }

      if (sin(angle) < -0.1) {
        paintY = y - textPainter.height;
      } else if (sin(angle) > 0.1) {
        paintY = y + 2.h;
      }

      textPainter.paint(canvas, Offset(paintX, paintY));
    }
  }

  @override
  bool shouldRepaint(covariant GrowthRadarChartPainter oldDelegate) {
    return oldDelegate.growthAreas != growthAreas;
  }
}
