import 'package:get/get.dart';
import 'package:Mentora/data/model/doctor_appointment.model.dart';
import 'package:Mentora/infrastructure/dal/services/doctor_portal_service.dart';

class AppointmentDoctorController extends GetxController {
  final RxList<DoctorAppointmentModel> appointments = <DoctorAppointmentModel>[].obs;
  final RxString selectedTab = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedModality = 'All Modalities'.obs;
  final RxBool isLoading = false.obs;

  final List<String> tabList = ['All', 'Upcoming', 'Today', 'Completed', 'Cancelled'];
  final List<String> modalityList = ['All Modalities', 'Video Consultation', 'Audio Call'];

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      isLoading.value = true;
      final list = await DoctorPortalService.getAppointments();
      appointments.assignAll(list);
    } catch (e) {
      Get.log('Error fetching doctor appointments: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onTabChanged(String tab) {
    selectedTab.value = tab;
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void onModalityChanged(String modality) {
    selectedModality.value = modality;
  }

  int get allCount => appointments.length;

  int get upcomingCount =>
      appointments.where((a) => a.bookingStatus == 'Upcoming' || a.bookingStatus == 'In Progress').length;

  int get todayCount {
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    return appointments.where((a) => a.bookingDate == todayStr && a.bookingStatus != 'Cancelled').length;
  }

  int get completedCount =>
      appointments.where((a) => a.bookingStatus == 'Completed').length;

  int get cancelledCount =>
      appointments.where((a) => a.bookingStatus == 'Cancelled' || a.bookingStatus == 'Canceled').length;

  List<DoctorAppointmentModel> get filteredAppointments {
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final tab = selectedTab.value;
    final query = searchQuery.value.toLowerCase().trim();
    final mod = selectedModality.value;

    return appointments.where((a) {
      // Tab filter
      if (tab == 'Upcoming') {
        if (a.bookingStatus != 'Upcoming' && a.bookingStatus != 'In Progress') return false;
      } else if (tab == 'Today') {
        if (a.bookingDate != todayStr) return false;
      } else if (tab == 'Completed') {
        if (a.bookingStatus != 'Completed') return false;
      } else if (tab == 'Cancelled') {
        if (a.bookingStatus != 'Cancelled' && a.bookingStatus != 'Canceled') return false;
      }

      // Modality filter
      if (mod != 'All Modalities') {
        if (!a.modalityType.toLowerCase().contains(mod.toLowerCase().split(' ').first)) return false;
      }

      // Search query filter
      if (query.isNotEmpty) {
        final matchesName = a.patientName.toLowerCase().contains(query);
        final matchesId = a.id.toString().contains(query);
        final matchesIssue = a.patientIssue.toLowerCase().contains(query);
        final matchesDate = a.bookingDate.toLowerCase().contains(query);
        if (!matchesName && !matchesId && !matchesIssue && !matchesDate) return false;
      }

      return true;
    }).toList();
  }
}
