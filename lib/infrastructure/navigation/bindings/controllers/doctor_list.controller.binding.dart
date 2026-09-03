import 'package:get/get.dart';

import '../../../../presentation/doctorList/controllers/doctor_list_controller.dart';

class DoctorListControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorListController>(() => DoctorListController());
  }
}
