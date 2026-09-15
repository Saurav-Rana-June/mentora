import 'package:get/get.dart';

import '../../../../presentation/admin/landingAdmin/controllers/landing_admin.controller.dart';

class LandingAdminControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LandingAdminController>(
      () => LandingAdminController(),
    );
  }
}
