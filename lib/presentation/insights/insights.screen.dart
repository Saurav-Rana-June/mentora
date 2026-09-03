import 'dart:math';
import 'package:Mentora/presentation/home/controllers/home.controller.dart';
import 'package:Mentora/widgets/others/custom.circular.progressbar.dart';
import 'package:Mentora/widgets/others/custom.primary.appbar.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:Mentora/widgets/others/custom.screen.wrapper.dart';
import 'package:Mentora/widgets/others/custom.toggle.dart';
import 'package:Mentora/widgets/others/custom.divider.dart';
import 'package:Mentora/widgets/others/custom.horizontal.scrollable.filter.widget.dart';
import 'package:Mentora/widgets/charts/custom.line.chart.dart';
import 'package:Mentora/widgets/charts/custom.bar.chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';
import '../../infrastructure/theme/theme.dart';
import 'controllers/insights.controller.dart';
import 'package:Mentora/presentation/widgets/loaders/loader.dart';
import 'package:Mentora/controllers/global.controller.dart';
import 'package:Mentora/data/enums/date_filter_enum.dart';
import 'package:Mentora/data/model/growth_areas_response.model.dart';

class InsightsScreen extends GetView<InsightsController> {
  InsightsScreen({super.key});

  @override
  final controller = Get.put(InsightsController());

  @override
  Widget build(BuildContext context) {
    final homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());

    final horizontalPadding = EdgeInsets.symmetric(
      horizontal: Spacing.s8.symmetric.horizontal,
    );

    return CustomScreenWrapper(
      appBar: buildAppbar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait({
            controller.fetchGrowthAreas(
              controller.selectedDateFilter.value,
              forceRefresh: true,
            ),
            controller.fetchCoachingBanner(forceRefresh: true),
            controller.globalController.fetchMoodTrackerStats(
              dateFilter: controller.selectedDateFilter.value.name,
              forceRefresh: true,
            ),
          });
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: Spacing.s4.symmetric.horizontal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: horizontalPadding,
                child: Obx(
                  () => buildPersonalizedCoachingCard(context, homeController),
                ),
              ),
              buildDateFilters(context),
              Spacing.s20.h,
              Padding(
                padding: horizontalPadding,
                child: Column(
                  children: [
                    buildGrowthAreaCard(context),
                    Spacing.s20.h,
                    buildMoodTrackerCard(context, homeController),
                    Spacing.s12.h,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPersonalizedCoachingCard(
    BuildContext context,
    HomeController homeController,
  ) {
    final theme = Theme.of(context);
    final banner = controller.coachingBannerData.value;

    if (controller.isLoadingCoachingBanner.value) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: const Loader(),
        ),
      );
    }

    if (banner == null) {
      return const SizedBox.shrink();
    }

    final title = banner.title ?? '';
    final description = banner.description ?? '';

    // Map backend icon tag to FontAwesome solid unicode string:
    // 'calendar' -> \u{f073}
    // 'leaf' -> \u{f06c}
    // 'checkmark' -> \u{f058}
    String icon = '\u{f058}';
    if (banner.icon == 'calendar') {
      icon = '\u{f073}';
    } else if (banner.icon == 'leaf') {
      icon = '\u{f06c}';
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
          const CustomDivider(),
          Spacing.s16.h,
          Obx(() {
            if (controller.isLoadingGrowth.value) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 36.h),
                  child: const Loader(),
                ),
              );
            }

            final data = controller.growthAreasData.value;
            if (data == null) {
              return const SizedBox();
            }

            if (data.hasSufficientData != true) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  border: Border.all(color: slate[200]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text("🌱", style: TextStyle(fontSize: 24.sp)),
                    Spacing.s8.h,
                    Text(
                      data.placeholderMessage ??
                          "Check in a few more days to see your growth areas",
                      textAlign: TextAlign.center,
                      style: r14.copyWith(
                        color: Theme.of(context).textTheme.bodySmall!.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            final areas = data.areas ?? [];
            if (areas.length < 6) {
              return const SizedBox();
            }

            return buildGrowthContent(context, areas);
          }),
        ],
      ),
    );
  }

  Widget buildGrowthContent(BuildContext context, List<GrowthAreaModel> areas) {
    return Column(
      children: [
        Obx(() {
          if (controller.selectedGrowthTab.value == 0) {
            return buildGrowthGridView(context, areas);
          } else {
            return Column(
              children: [
                SizedBox(
                  height: 200.h,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: GrowthRadarChartPainter(
                      growthAreas: areas,
                      primaryColor: primary,
                      textColor:
                          Theme.of(context).textTheme.bodyLarge!.color ??
                          slate[900]!,
                    ),
                  ),
                ),
                Spacing.s20.h,
                buildGrowthDetailedView(context, areas),
              ],
            );
          }
        }),
      ],
    );
  }

  Widget buildGrowthGridView(
    BuildContext context,
    List<GrowthAreaModel> areas,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (areas.isNotEmpty)
              buildGrowthProgressIndicators(
                context,
                areas[0].progress ?? 0.0,
                areas[0].title ?? '',
              ),
            if (areas.length > 1)
              buildGrowthProgressIndicators(
                context,
                areas[1].progress ?? 0.0,
                areas[1].title ?? '',
              ),
            if (areas.length > 2)
              buildGrowthProgressIndicators(
                context,
                areas[2].progress ?? 0.0,
                areas[2].title ?? '',
              ),
          ],
        ),
        Spacing.s16.h,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (areas.length > 3)
              buildGrowthProgressIndicators(
                context,
                areas[3].progress ?? 0.0,
                areas[3].title ?? '',
              ),
            if (areas.length > 4)
              buildGrowthProgressIndicators(
                context,
                areas[4].progress ?? 0.0,
                areas[4].title ?? '',
              ),
            if (areas.length > 5)
              buildGrowthProgressIndicators(
                context,
                areas[5].progress ?? 0.0,
                areas[5].title ?? '',
              ),
          ],
        ),
      ],
    );
  }

  Widget buildGrowthDetailedView(
    BuildContext context,
    List<GrowthAreaModel> areas,
  ) {
    final theme = Theme.of(context);
    return Column(
      children: areas.map((area) {
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
                      Icon(area.iconData, color: primary, size: 20),
                      Spacing.s8.w,
                      Text(
                        area.title ?? '',
                        style: r14.copyWith(
                          color: theme.textTheme.bodyLarge!.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${((area.progress ?? 0.0) * 100).toInt()}%",
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
                  value: area.progress ?? 0.0,
                  minHeight: 6.h,
                  backgroundColor: slate[100],
                  valueColor: AlwaysStoppedAnimation<Color>(primary),
                ),
              ),
              Spacing.s8.h,
              Text(
                area.tip ?? '',
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

  Widget buildDateFilters(BuildContext context) {
    return Obx(() {
      return CustomHorizontalScrollableFilter<DateFilter>(
        items: DateFilter.values,
        selectedItem: controller.selectedDateFilter.value,
        labelBuilder: (filter) => filter.value,
        onItemSelected: (filter) => controller.changeDateFilter(filter),
      );
    });
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
                  width: 100.w,
                  unselectedColor: primary,
                  children: const [
                    Icon(Icons.show_chart),
                    Icon(Icons.bar_chart),
                  ],
                ),
              ),
            ],
          ),
          Spacing.s4.h,
          const CustomDivider(),
          Spacing.s16.h,
          Obx(() {
            final globalController = Get.find<GlobalController>();

            if (globalController.isLoadingMoodTracker.value) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 36.h),
                  child: const Loader(),
                ),
              );
            }

            final stats = globalController.moodTrackerStats.value;

            final apiMoods =
                stats?.data
                    ?.map((d) => d.feeling)
                    .whereType<String>()
                    .toList() ??
                [];

            if (apiMoods.length < 2) {
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
                      "Check in a few more days to see your\ntrends",
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
              final Map<String, int> counts = {
                'Great': 0,
                'Good': 0,
                'Normal': 0,
                'Low': 0,
                'Angry': 0,
              };

              for (var m in apiMoods) {
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

              final chartColor = primary;
              final textChartColor =
                  theme.textTheme.bodySmall!.color ?? slate[500]!;

              return Column(
                children: [
                  SizedBox(
                    height: 150.h,
                    width: double.infinity,
                    child: controller.selectedMoodTab.value == 0
                        ? CustomLineChart(
                            checkInMoods: apiMoods,
                            primaryColor: chartColor,
                            textColor: textChartColor,
                          )
                        : CustomBarChart(
                            data: counts,
                            orderKeys: const [
                              'Angry',
                              'Low',
                              'Normal',
                              'Good',
                              'Great',
                            ],
                            primaryColor: chartColor,
                            textColor: textChartColor,
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
    final stats = globalController.moodTrackerStats.value;

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
      final double progress = growthAreas[i].progress ?? 0.0;
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
