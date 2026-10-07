import 'package:get/get.dart';
import 'package:Mentora/data/model/doctor_appointment.model.dart';
import 'package:Mentora/data/model/expert.model.dart';
import 'package:Mentora/infrastructure/dal/services/doctor_portal_service.dart';

class DashboardDoctorController extends GetxController {
  final Rx<Expert?> doctorProfile = Rx<Expert?>(null);
  final RxList<DoctorAppointmentModel> todayAppointments = <DoctorAppointmentModel>[].obs;
  final RxList<DoctorAppointmentModel> allAppointments = <DoctorAppointmentModel>[].obs;

  final RxBool isOnline = true.obs;
  final RxBool isLoading = false.obs;

  // Stats
  final RxInt totalPatients = 148.obs;
  final RxDouble totalEarnings = 4820.0.obs;
  final RxDouble rating = 4.95.obs;
  final RxInt reviewsCount = 142.obs;
  final RxString completionRate = '98.4%'.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;
      final profile = await DoctorPortalService.getCurrentDoctorProfile();
      doctorProfile.value = profile;
      isOnline.value = profile.isAvailable ?? true;

      final list = await DoctorPortalService.getAppointments();
      allAppointments.assignAll(list);

      final now = DateTime.now();
      final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      todayAppointments.assignAll(
        list.where((a) => a.bookingDate == todayStr && a.bookingStatus != 'Cancelled').toList(),
      );

      // Recalculate stats dynamically
      final completed = list.where((a) => a.bookingStatus == 'Completed').toList();
      if (completed.isNotEmpty) {
        final earned = completed.fold<double>(0.0, (sum, a) => sum + a.durationCost);
        totalEarnings.value = 3200.0 + earned;
      }
    } catch (e) {
      Get.log('Error loading doctor dashboard: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleOnlineStatus(bool val) async {
    isOnline.value = val;
    if (doctorProfile.value != null) {
      final updated = Expert(
        id: doctorProfile.value!.id,
        name: doctorProfile.value!.name,
        speciality: doctorProfile.value!.speciality,
        image: doctorProfile.value!.image,
        rating: doctorProfile.value!.rating,
        reviewsCount: doctorProfile.value!.reviewsCount,
        experienceYears: doctorProfile.value!.experienceYears,
        patientsCount: doctorProfile.value!.patientsCount,
        bio: doctorProfile.value!.bio,
        startingPricePerHour: doctorProfile.value!.startingPricePerHour,
        specialties: doctorProfile.value!.specialties,
        languages: doctorProfile.value!.languages,
        degree: doctorProfile.value!.degree,
        university: doctorProfile.value!.university,
        graduationYear: doctorProfile.value!.graduationYear,
        licenseNumber: doctorProfile.value!.licenseNumber,
        certifications: doctorProfile.value!.certifications,
        callFeature: doctorProfile.value!.callFeature,
        videoCallFeature: doctorProfile.value!.videoCallFeature,
        isAvailable: val,
        availableDays: doctorProfile.value!.availableDays,
        workingHoursStart: doctorProfile.value!.workingHoursStart,
        workingHoursEnd: doctorProfile.value!.workingHoursEnd,
        availableShifts: doctorProfile.value!.availableShifts,
        sessionDurations: doctorProfile.value!.sessionDurations,
      );
      doctorProfile.value = updated;
      await DoctorPortalService.saveCurrentDoctorProfile(updated);
    }
  }
}
