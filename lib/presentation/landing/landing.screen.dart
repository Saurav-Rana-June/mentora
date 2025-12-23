import 'package:Mentora/controllers/bottom.nav.controller.dart';
import 'package:Mentora/data/model/extras/page.model.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/presentation/landing/controllers/landing.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LandingScreen extends GetView<LandingController> {
  LandingScreen({super.key});

  final BottamNavController _bottomNavController = Get.put(
    BottamNavController(),
  );
  final LandingController _landingController = Get.put(LandingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Obx(
      () => Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(0, 0),
              blurRadius: 15,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          type: BottomNavigationBarType.fixed,
          onTap: _bottomNavController.changeTabIndex,
          currentIndex: _bottomNavController.tabIndex.value,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: r12.copyWith(
            color: primary,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: r12.copyWith(
            color: slate[500],
            fontWeight: FontWeight.w400,
          ),
          selectedItemColor: primary,
          unselectedItemColor: slate[500],
          items: _bottomNavController.pages.map((PageModel page) {
            final index = _bottomNavController.pages.indexOf(page);
            final isSelected = _bottomNavController.tabIndex.value == index;

            return BottomNavigationBarItem(
              icon: Text(
                page.icon,
                style: TextStyle(
                  fontFamily: isSelected
                      ? 'FontAwesomeSolid'
                      : 'FontAwesomeLight',
                  fontSize: 20,
                  color: isSelected ? primary : slate[500],
                ),
              ),
              label: page.title,
            );
          }).toList(),
        ),
      ),
    );
  }
}
