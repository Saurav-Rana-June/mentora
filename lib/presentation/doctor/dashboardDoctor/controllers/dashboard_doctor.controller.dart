import 'package:get/get.dart';
import 'package:Mentora/data/model/doctor_appointment.model.dart';
import 'package:Mentora/data/model/doctor_dashboard.model.dart';
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
  final RxInt totalConsultations = 120.obs;
  final RxDouble totalEarnings = 4820.0.obs;
  final RxDouble rating = 4.95.obs;
  final RxInt reviewsCount = 142.obs;
  final RxString completionRate = '98.4%'.obs;
  final RxString patientsGrowth = '+14 this month'.obs;
  final RxString earningsGrowth = '+\$650 this week'.obs;

  // Weekly Volume & Recent Reviews
  final Rx<WeeklyConsultationVolume?> weeklyVolume = Rx<WeeklyConsultationVolume?>(null);
  final RxList<PatientReviewItem> recentReviews = <PatientReviewItem>[].obs;

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

      // 1. Fetch Clinical Dashboard Data from API (Stats, Weekly Graph, Recent Reviews)
      final dashboardRes = await DoctorPortalService.getClinicalDashboard(doctorId: profile.id);
      if (dashboardRes != null && dashboardRes.data != null) {
        final d = dashboardRes.data!;
        totalPatients.value = d.stats.totalPatients;
        totalConsultations.value = d.stats.totalConsultations;
        totalEarnings.value = d.stats.totalEarnings;
        rating.value = d.stats.averageRating;
        reviewsCount.value = d.stats.reviewsCount;
        completionRate.value = d.stats.completionRate;
        patientsGrowth.value = d.stats.patientsGrowth;
        earningsGrowth.value = d.stats.earningsGrowth;

        weeklyVolume.value = d.weeklyVolume;
        recentReviews.assignAll(d.recentReviews);
      }

      // 2. Fetch appointments for Today's schedule preview
      final list = await DoctorPortalService.getAppointments();
      allAppointments.assignAll(list);

      final now = DateTime.now();
      final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      todayAppointments.assignAll(
        list.where((a) => a.bookingDate == todayStr && a.bookingStatus != 'Cancelled').toList(),
      );
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
