import 'package:Mentora/data/methods/app_method.dart';
import 'package:Mentora/infrastructure/navigation/routes.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/buttons/custom_primary_button.widget.dart';
import 'package:Mentora/widgets/others/custom.screen.wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'controllers/introduction.controller.dart';

class IntroductionScreen extends GetView<IntroductionController> {
  IntroductionScreen({super.key});
  @override
  final controller = Get.put(IntroductionController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: primary,
        statusBarIconBrightness: Get.isDarkMode
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: black,
      ),
    );

    return CustomScreenWrapper(
      safeAreaTop: false,
      body: Stack(
        children: [
          buildBackgroundImageSection(context),
          buildMainContentSection(context),
        ],
      ),
    );
  }

  Column buildMainContentSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RepaintBoundary(
          child: CurvedTopContainer(
            curveHeight: 100.h,
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: EdgeInsets.symmetric(
              vertical: Spacing.s12.symmetric.vertical,
            ),
            child: buildMainConent(context),
          ),
        ),
      ],
    );
  }

  Padding buildMainConent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Spacing.s40.value),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Spacing.s8.h,
              SizedBox(
                height: Get.height / 4,
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: controller.items.length,
                  onPageChanged: controller.onPageChanged,
                  itemBuilder: (context, index) {
                    final item = controller.items[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Spacing.s12.symmetric.vertical,
                        horizontal: Spacing.s4.symmetric.horizontal,
                      ),
                      child: Column(
                        children: [
                          Text(
                            item["title"]!,
                            textAlign: TextAlign.center,
                            style: h3.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(
                                context,
                              ).textTheme.headlineMedium!.color,
                            ),
                          ),
                          Spacing.s12.h,
                          Text(
                            item["subtitle"]!,
                            textAlign: TextAlign.center,
                            style: r14.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.color,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(controller.items.length, (i) {
                    bool isActive = controller.currentIndex.value == i;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8.h,
                      width: isActive ? 22.w : 8.w,
                      decoration: BoxDecoration(
                        color: isActive ? primary : slate[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }),
                );
              }),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.s4.symmetric.horizontal,
            ),
            child: CustomPrimaryButton(
              text: "Let's get started!",
              borderRadius: 50.r,
              height: 45.h,
              backgroundColor: primary,
              disabledColor: primary.withValues(alpha: 0.5),
              isLoading: false,
              textStyle: r16.copyWith(
                fontWeight: FontWeight.w600,
                color: white,
              ),
              onPressed: () async {
                await AppMethod.setHasSeenIntroduction(true);
                Get.offAllNamed(Routes.SIGN_IN);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBackgroundImageSection(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height - (Get.height / 2) + 50.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [primary.withValues(alpha: 0.8), primary],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: 20.h, bottom: 40.h),
          child: PageView.builder(
            controller: controller.imagePageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              return buildImagePage(context, index);
            },
          ),
        ),
      ),
    );
  }

  Widget buildImagePage(BuildContext context, int index) {
    if (index == 0) {
      return Center(
        child: SizedBox(
          height: 300.h,
          width: Get.width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              buildScreenshot(
                assetPath: 'assets/images/light_mode_ss/ssd_2.png',
                scale: 0.82,
                rotate: -0.15,
                offset: Offset(-55.w, 10.h),
                opacity: 0.8,
              ),
              buildScreenshot(
                assetPath: 'assets/images/light_mode_ss/ssd_1.png',
                scale: 0.95,
                rotate: 0.05,
                offset: Offset(35.w, -5.h),
              ),
            ],
          ),
        ),
      );
    } else if (index == 1) {
      return Center(
        child: SizedBox(
          height: 300.h,
          width: Get.width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              buildScreenshot(
                assetPath: 'assets/images/light_mode_ss/ssd_4.png',
                scale: 0.82,
                rotate: -0.18,
                offset: Offset(-75.w, 15.h),
                opacity: 0.8,
              ),
              buildScreenshot(
                assetPath: 'assets/images/light_mode_ss/ssd_5.png',
                scale: 0.82,
                rotate: 0.18,
                offset: Offset(75.w, 15.h),
                opacity: 0.8,
              ),
              buildScreenshot(
                assetPath: 'assets/images/light_mode_ss/ssd_3.png',
                scale: 0.95,
                rotate: 0.0,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: SizedBox(
          height: 300.h,
          width: Get.width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              buildScreenshot(
                assetPath: 'assets/images/light_mode_ss/ssd_7.png',
                scale: 0.82,
                rotate: -0.18,
                offset: Offset(-75.w, 15.h),
                opacity: 0.8,
              ),
              buildScreenshot(
                assetPath: 'assets/images/light_mode_ss/ssd_8.png',
                scale: 0.82,
                rotate: 0.18,
                offset: Offset(75.w, 15.h),
                opacity: 0.8,
              ),
              buildScreenshot(
                assetPath: 'assets/images/light_mode_ss/ssd_6.png',
                scale: 0.95,
                rotate: 0.0,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget buildScreenshot({
    required String assetPath,
    double scale = 1.0,
    double rotate = 0.0,
    Offset offset = Offset.zero,
    double opacity = 1.0,
  }) {
    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: rotate,
        child: Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Container(
              height: 250.h,
              width: 120.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.4),
                  width: 2.w,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CurvedTopContainer extends StatelessWidget {
  final double curveHeight;
  final Color color;
  final Widget child;
  final EdgeInsetsGeometry padding;

  const CurvedTopContainer({
    super.key,
    this.curveHeight = 20.0,
    this.color = Colors.blue,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurvedTopClipper(curveHeight: curveHeight),
      child: Container(
        height: Get.height / 2,
        width: Get.width,
        color: color,
        padding: padding,
        child: child,
      ),
    );
  }
}

class CurvedTopClipper extends CustomClipper<Path> {
  final double curveHeight;

  CurvedTopClipper({this.curveHeight = 20.0});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);

    // Create a quadratic bezier curve for the top
    path.quadraticBezierTo(size.width / 2, curveHeight, size.width, 0);

    // Draw the rest
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
