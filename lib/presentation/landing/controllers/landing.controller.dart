import 'package:Mentora/controllers/bottom.nav.controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingController extends GetxController {
  final _bottomNavController = Get.put(BottamNavController());
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void onInit() {
    _bottomNavController.prepareBottomNav();
    super.onInit();
  }
}
