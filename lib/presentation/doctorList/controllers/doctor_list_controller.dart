import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:Mentora/data/model/expert.model.dart';
import 'package:Mentora/data/utils/storage_utils.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/dal/services/doctor_service.dart';

class DoctorListController extends GetxController {
  final RxList<Expert> therapists = <Expert>[].obs;
  final RxString searchQuery = "".obs;

  // Pagination states
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadMore = false.obs;

  // Scroll controller for infinite scrolling
  final ScrollController scrollController = ScrollController();

  List<Expert> get filteredTherapists => therapists;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    
    // Debounce search query to optimize API request frequency
    debounce(
      searchQuery,
      (_) => fetchTherapists(forceRefresh: true),
      time: const Duration(milliseconds: 300),
    );
    
    fetchTherapists();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      loadNextPage();
    }
  }

  Future<void> fetchTherapists({bool forceRefresh = false}) async {
    if (isLoading.value) return;
    isLoading.value = true;
    currentPage.value = 1;

    if (forceRefresh) {
      await StorageUtils.remove(StorageKeys.DOCTORS);
      await StorageUtils.remove(StorageKeys.DOCTORS_LAST_UPDATED);
      await StorageUtils.remove(StorageKeys.DOCTORS_TOTAL_PAGES);
    }

    try {
      final List<dynamic>? cachedData = StorageUtils.read<List<dynamic>>(
        StorageKeys.DOCTORS,
      );
      final String? cachedLastUpdated = StorageUtils.read<String>(
        StorageKeys.DOCTORS_LAST_UPDATED,
      );
      final int? cachedTotalPages = StorageUtils.read<int>(
        StorageKeys.DOCTORS_TOTAL_PAGES,
      );

      bool hasCache = false;
      if (cachedData != null &&
          cachedLastUpdated != null &&
          searchQuery.value.isEmpty) {
        therapists.assignAll(
          cachedData
              .map((e) => Expert.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList(),
        );
        if (cachedTotalPages != null) {
          totalPages.value = cachedTotalPages;
        }
        hasCache = true;
      }

      if (hasCache && !forceRefresh) {
        // Background check for updates
        final checkRes = await DoctorService.getDoctors(
          search: searchQuery.value,
          page: 1,
          size: 10,
          lastUpdated: cachedLastUpdated,
        );
        if (checkRes != null) {
          final DateTime? cachedDateTime =
              DateTime.tryParse(cachedLastUpdated!);
          if (checkRes.lastUpdated != null &&
              checkRes.lastUpdated == cachedDateTime) {
            isLoading.value = false;
            return; // Cache is still up to date
          }
        }
      }

      // Execute API call
      final res = await DoctorService.getDoctors(
        search: searchQuery.value,
        page: currentPage.value,
        size: 10,
      );

      if (res != null && res.data != null) {
        final items = res.data!.items ?? [];
        therapists.assignAll(items);
        totalPages.value = res.data!.totalPages ?? 1;

        // Cache first page response if search is empty
        if (searchQuery.value.isEmpty) {
          await StorageUtils.write(
            StorageKeys.DOCTORS,
            items.map((e) => e.toJson()).toList(),
          );
          await StorageUtils.write(
            StorageKeys.DOCTORS_TOTAL_PAGES,
            totalPages.value,
          );
          if (res.lastUpdated != null) {
            await StorageUtils.write(
              StorageKeys.DOCTORS_LAST_UPDATED,
              res.lastUpdated!.toIso8601String(),
            );
          }
        }
      }
    } catch (e) {
      Get.log("Failed to load therapists: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadNextPage() async {
    if (isLoading.value ||
        isLoadMore.value ||
        currentPage.value >= totalPages.value) return;
    isLoadMore.value = true;

    try {
      final nextPage = currentPage.value + 1;
      final res = await DoctorService.getDoctors(
        search: searchQuery.value,
        page: nextPage,
        size: 10,
      );

      if (res != null && res.data != null) {
        final items = res.data!.items ?? [];
        therapists.addAll(items);
        currentPage.value = nextPage;
        totalPages.value = res.data!.totalPages ?? 1;
      }
    } catch (e) {
      Get.log("Failed to load more therapists: $e");
    } finally {
      isLoadMore.value = false;
    }
  }

  void selectDoctor(Expert expert) {
    Get.toNamed(Routes.BOOKING_SESSION, arguments: expert);
  }
}
