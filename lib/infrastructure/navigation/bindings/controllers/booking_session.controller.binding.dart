import 'package:get/get.dart';

import '../../../../presentation/app/bookingSession/controllers/booking_session_controller.dart';

class BookingSessionControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingSessionController>(() => BookingSessionController());
  }
}
