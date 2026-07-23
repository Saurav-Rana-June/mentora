import 'package:Mentora/presentation/home/controllers/home.controller.dart';
import 'package:Mentora/widgets/others/custom.circular.progressbar.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../infrastructure/theme/theme.dart';
import 'controllers/insights.controller.dart';

class InsightsScreen extends GetView<InsightsController> {
  InsightsScreen({super.key});

  @override
  final controller = Get.put(InsightsController());

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
            buildGrowthArea(context),
            Spacing.s24.h,
            CustomPrimaryCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Mood Tracker",
                        textAlign: TextAlign.center,
                        style: r18.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      // Toggle Buttons
                      ToggleButtons(
                        isSelected: [
                          controller.selectedIndex.value == 0,
                          controller.selectedIndex.value == 1,
                        ],
                        onPressed: controller.toggleGrowthArea,
                        borderRadius: BorderRadius.circular(20),
                        fillColor: primary,
                        color: Colors.white,
                        borderColor: Colors.grey.shade300,
                        selectedBorderColor: primary,
                        constraints: const BoxConstraints(
                          minHeight: 30,
                          minWidth: 60,
                        ),
                        children: [
                          Text(
                            "Weekly",
                            style: r12.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge!.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Monthly",
                            style: r12.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge!.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacing.s12.h,
                  Divider(),
                  Spacing.s12.h,
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
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall!.color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: 140.h,
                        width: double.infinity,
                        child: CustomPaint(
                          painter: InsightsMoodLineChartPainter(
                            checkInMoods: homeController.checkInMoods,
                            primaryColor: primary,
                            textColor:
                                Theme.of(context).textTheme.bodySmall!.color ??
                                slate[500]!,
                          ),
                        ),
                      );
                    }
                  }),
                  Spacing.s12.h,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomPrimaryCard buildGrowthArea(BuildContext context) {
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

              // Toggle Buttons
              ToggleButtons(
                isSelected: [
                  controller.selectedIndex.value == 0,
                  controller.selectedIndex.value == 1,
                ],
                onPressed: controller.toggleGrowthArea,
                borderRadius: BorderRadius.circular(20),
                fillColor: primary,
                selectedColor: Colors.white,
                color: Theme.of(context).textTheme.bodyLarge!.color,
                constraints: const BoxConstraints(minHeight: 30, minWidth: 60),
                children: [
                  Text(
                    '\u{f624}', // Change icon :- gauge
                    style: TextStyle(
                      fontFamily: 'FontAwesomeSolid',
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '\u{e0e7}', // Change icon :- chart-radar
                    style: TextStyle(
                      fontFamily: 'FontAwesomeSolid',
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Spacing.s12.h,
          Divider(),
          Spacing.s12.h,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildGrowthProgressIndicators(context, 0.7, "Mental Health"),
              buildGrowthProgressIndicators(context, 0.5, "Growth Mindset"),

              buildGrowthProgressIndicators(context, 0.9, "Relationships"),
            ],
          ),
          Spacing.s12.h,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildGrowthProgressIndicators(
                context,
                0.7,
                "Personal Development",
              ),
              buildGrowthProgressIndicators(context, 0.5, "Self-awareness"),

              buildGrowthProgressIndicators(context, 0.9, "Stress Management"),
            ],
          ),
        ],
      ),
    );
  }

  Column buildGrowthProgressIndicators(
    BuildContext context,
    double percentage,
    String title,
  ) {
    return Column(
      children: [
        CustomCircularProgressBar(
          percentage: percentage,
          size: Get.height / 9,
          strokeWidth: 10,
          backgroundColor: slate[100]!,
          progressColor: primary,
          textStyle: r16.copyWith(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontWeight: FontWeight.bold,
          ),
          onComplete: () {},
        ),
        Spacing.s4.h,
        SizedBox(
          width: Get.height / 9,
          child: Text(
            title,
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
                    '\u{f142}', // Change Icon :-  ellipsis-vertical
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
      canvas.drawCircle(point, 6.0, dotPaint);
      canvas.drawCircle(point, 6.0, dotBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant InsightsMoodLineChartPainter oldDelegate) {
    return oldDelegate.checkInMoods != checkInMoods;
  }
}
