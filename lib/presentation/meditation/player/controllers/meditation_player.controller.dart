import 'package:get/get.dart';
import '../../widgets/meditation_session.dart';

class MeditationPlayerController extends GetxController {
  late MeditationSession session;
  final RxBool isFavorited = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Resolve arguments from GetX or fallback to first mock session
    session = Get.arguments as MeditationSession? ?? mockMeditationSessions.first;
    // Set initial favorite status
    isFavorited.value = session.id == '1' || session.id == '3';
  }

  // Toggle favorite status
  void toggleFavorite() {
    isFavorited.value = !isFavorited.value;
  }
}
