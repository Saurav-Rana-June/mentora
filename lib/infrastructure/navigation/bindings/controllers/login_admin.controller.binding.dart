import 'package:get/get.dart';

import '../../../../presentation/admin/loginAdmin/controllers/login_admin.controller.dart';

class LoginAdminControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginAdminController>(() => LoginAdminController());
  }
}
