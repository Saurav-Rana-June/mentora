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
import 'package:my_spacing/spacing.enum.dart';

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
          buildBackgroundImageSection(),
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
                Get.offAllNamed(Routes.CONTINUE);
              },
            ),
          ),
        ],
      ),
    );
  }

  RepaintBoundary buildBackgroundImageSection() {
    return RepaintBoundary(child: Container(color: primary));
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
