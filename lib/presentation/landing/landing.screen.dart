import 'package:Mentora/controllers/bottom.nav.controller.dart';
import 'package:Mentora/data/model/page.model.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/landing/controllers/landing.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LandingScreen extends GetView<LandingController> {
  LandingScreen({super.key});

  final BottamNavController _bottomNavController = Get.put(
    BottamNavController(),
  );
  final LandingController _landingController = Get.put(LandingController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        key: _landingController.scaffoldKey,
        body: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: _bottomNavController
                .pages[_bottomNavController.tabIndex.value]
                .widget,
          ),
        ),

        bottomNavigationBar: _buildBottomNavigationBar(context),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Obx(
      () => Container(
        height: 65.h,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, -4),
              blurRadius: 16,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _bottomNavController.pages.map((PageModel page) {
            final index = _bottomNavController.pages.indexOf(page);
            final isSelected = _bottomNavController.tabIndex.value == index;
            final isAi = page.title == 'AI';

            if (isAi) {
              return buildCustomAiButton(context, page);
            }

            return buildCustomTabItem(context, page, index, isSelected);
          }).toList(),
        ),
      ),
    );
  }

  Widget buildCustomAiButton(BuildContext context, PageModel page) {
    return InkWell(
      onTap: () => _bottomNavController.changeTabIndex(2),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Transform.translate(
        offset: Offset(0, -12.h),
        child: Container(
          width: 52.h,
          height: 52.h,
          decoration: BoxDecoration(
            color: primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.35),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              page.icon ?? '',
              style: const TextStyle(
                fontFamily: 'FontAwesomeSolid',
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCustomTabItem(
    BuildContext context,
    PageModel page,
    int index,
    bool isSelected,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () => _bottomNavController.changeTabIndex(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              page.icon ?? '',
              style: TextStyle(
                fontFamily: isSelected
                    ? 'FontAwesomeSolid'
                    : 'FontAwesomeLight',
                fontSize: 20,
                color: isSelected ? primary : slate[500],
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              page.title ?? '',
              style: r10.copyWith(
                color: isSelected ? primary : slate[500],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
