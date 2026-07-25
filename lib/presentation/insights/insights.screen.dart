import 'package:Mentora/presentation/home/controllers/home.controller.dart';
import 'package:Mentora/widgets/others/custom.circular.progressbar.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../infrastructure/theme/theme.dart';
import 'controllers/insights.controller.dart';

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
      margin: EdgeInsets.only(bottom: Spacing.s16.symmetric.horizontal),
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
                () => ToggleButtons(
                  isSelected: [
                    controller.selectedGrowthTab.value == 0,
                    controller.selectedGrowthTab.value == 1,
                  ],
                  onPressed: controller.toggleGrowthTab,
                  borderRadius: BorderRadius.circular(20),
                  fillColor: primary,
                  selectedColor: Colors.white,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  constraints: const BoxConstraints(
                    minHeight: 30,
                    minWidth: 60,
                  ),
                  children: [
                    Text(
                      '\u{f624}', // gauge icon
                      style: TextStyle(
                        fontFamily: 'FontAwesomeSolid',
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '\u{e0e7}', // chart-radar icon
                      style: TextStyle(
                        fontFamily: 'FontAwesomeSolid',
                        fontSize: 18,
                      ),
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
              return buildGrowthDetailedView(context);
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
                () => ToggleButtons(
                  isSelected: [
                    controller.selectedMoodTab.value == 0,
                    controller.selectedMoodTab.value == 1,
                  ],
                  onPressed: controller.toggleMoodTab,
                  borderRadius: BorderRadius.circular(20),
                  fillColor: primary,
                  selectedColor: Colors.white,
                  color: theme.textTheme.bodyLarge!.color,
                  borderColor: Colors.grey.shade300,
                  selectedBorderColor: primary,
                  constraints: const BoxConstraints(
                    minHeight: 30,
                    minWidth: 60,
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        "Weekly",
                        style: r12.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        "Monthly",
                        style: r12.copyWith(fontWeight: FontWeight.w600),
                      ),
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
            final historyLength = homeController.checkInDates.length;
            if (historyLength < 3) {
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
                              checkInMoods: homeController.checkInMoods,
                              primaryColor: primary,
                              textColor:
                                  theme.textTheme.bodySmall!.color ??
                                  slate[500]!,
                            )
                          : InsightsMoodBarChartPainter(
                              checkInMoods: homeController.checkInMoods,
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
    final dominant = controller.getDominantMood(homeController);
    final consistency = controller.getCheckInConsistency(homeController);
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
                  dominant,
                  style: r14.copyWith(
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
                  style: r14.copyWith(
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
