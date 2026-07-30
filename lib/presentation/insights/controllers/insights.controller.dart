import 'package:get/get.dart';
import 'package:Mentora/data/model/assessment/growth_areas_response.model.dart';
import 'package:Mentora/infrastructure/dal/services/insights_service.dart';

class InsightsController extends GetxController {
  final RxInt selectedGrowthTab = 0.obs;
  final RxInt selectedMoodTab = 0.obs;

  final RxBool isLoadingGrowth = false.obs;
  final Rxn<GrowthAreasResponseModel> growthAreasData = Rxn<GrowthAreasResponseModel>();

  @override
  void onInit() {
    super.onInit();
    fetchGrowthAreas();
  }

  Future<void> fetchGrowthAreas() async {
    try {
      isLoadingGrowth.value = true;
      final response = await InsightsService.getGrowthAreas(timezone: 'UTC');
      if (response != null && response.data != null) {
        growthAreasData.value = response.data;
      }
    } catch (e) {
      Get.log("Error fetching growth areas: $e");
    } finally {
      isLoadingGrowth.value = false;
    }
  }

  void toggleGrowthTab(int index) {
    selectedGrowthTab.value = index;
  }

  void toggleMoodTab(int index) {
    selectedMoodTab.value = index;
  }
}
