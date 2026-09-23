import 'package:get/get.dart';
import 'package:Mentora/data/enums/snackbar_enum.dart';
import 'package:Mentora/data/model/expert.model.dart';
import 'package:Mentora/data/utils/app_utils.dart';
import 'package:Mentora/infrastructure/dal/services/doctor_service.dart';

class AdminDoctorController extends GetxController {
  final RxList<Expert> doctors = <Expert>[].obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalItems = 0.obs;
  final RxString selectedSpeciality = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  final List<String> specialities = [
    'All',
    'Clinical Psychologist',
    'Family Counseling',
    'Cognitive Behavioral',
    'Trauma & PTSD',
    'Mindfulness Coach',
    'Anxiety & Stress',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchDoctors();
  }

  Future<void> fetchDoctors({int? page}) async {
    if (page != null) currentPage.value = page;
    try {
      isLoading.value = true;
      final res = await DoctorService.getDoctors(
        speciality: selectedSpeciality.value,
        search: searchQuery.value,
        page: currentPage.value,
        size: 9,
      );
      if (res.data != null) {
        doctors.assignAll(res.data!.items ?? []);
        currentPage.value = res.data!.page ?? 1;
        totalPages.value = res.data!.totalPages ?? 1;
        totalItems.value = res.data!.totalItems ?? 0;
      }
    } catch (e) {
      Get.log('Error fetching doctors: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onSpecialityChanged(String spec) {
    selectedSpeciality.value = spec;
    currentPage.value = 1;
    fetchDoctors();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    currentPage.value = 1;
    fetchDoctors();
  }

  Future<bool> createDoctor(Map<String, dynamic> body) async {
    try {
      isSubmitting.value = true;
      final res = await DoctorService.createDoctor(body);
      if (res?.data != null) {
        AppUtils.snackbar('Success', 'Doctor profile registered', SnackBarType.SUCCESS);
        await fetchDoctors();
        return true;
      }
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> updateDoctor(int id, Map<String, dynamic> body) async {
    try {
      isSubmitting.value = true;
      final res = await DoctorService.updateDoctor(id, body);
      if (res?.data != null) {
        AppUtils.snackbar('Success', 'Doctor profile updated', SnackBarType.SUCCESS);
        await fetchDoctors();
        return true;
      }
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> deleteDoctor(int id) async {
    final res = await DoctorService.deleteDoctor(id);
    if (res != null) {
      doctors.removeWhere((d) => d.id == id);
      totalItems.value = (totalItems.value - 1).clamp(0, 99999);
      AppUtils.snackbar('Deleted', 'Doctor profile removed', SnackBarType.INFO);
      return true;
    }
    return false;
  }

  Future<String?> uploadAvatar({
    List<int>? bytes,
    String? filePath,
    required String fileName,
  }) async {
    try {
      final res = await DoctorService.uploadDoctorAvatar(
        bytes: bytes,
        filePath: filePath,
        fileName: fileName,
      );
      if (res?.data != null && res!.data!.isNotEmpty) {
        return res.data;
      }
      return null;
    } catch (e) {
      Get.log('Error uploading doctor avatar: $e');
      return null;
    }
  }
}
