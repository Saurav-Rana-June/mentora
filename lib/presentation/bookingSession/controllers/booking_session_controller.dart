import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Mentora/data/model/expert.model.dart';
import 'package:get/get.dart';
import 'package:Mentora/data/model/doctor_availability.model.dart';
import 'package:Mentora/data/model/session_info.model.dart';
import 'package:Mentora/data/model/booked_session.model.dart';
import 'package:Mentora/infrastructure/dal/services/booking_session_service.dart';
import 'package:Mentora/data/utils/storage_utils.dart';
import '../../../infrastructure/navigation/routes.dart';

class BookingSessionController extends GetxController {
  // Wizard steps: 0 (Session Slot), 1 (Session Type), 2 (Details), 3 (Review), 4 (Success)
  final RxInt currentStep = 0.obs;

  // Selected details
  final Rxn<Expert> selectedDoctor = Rxn<Expert>();
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final Rxn<TimeSlot> selectedTimeSlot = Rxn<TimeSlot>();
  final RxString selectedSessionType =
      "Video Call".obs; // 'Video Call' or 'Voice Call'
  final RxInt selectedDuration = 45.obs; // 15, 30, 45, 60 minutes
  final RxString sessionNotes = "".obs;
  final RxDouble sessionPrice = 0.0.obs;

  final RxBool isLoading = false.obs;

  final Rxn<BookedSession> bookedSession = Rxn<BookedSession>();

  final TextEditingController notesController = TextEditingController();

  // Available lists
  final RxList<DateTime> availableDates = <DateTime>[].obs;
  final RxList<TimeSlot> timeSlots = <TimeSlot>[].obs;

  // API modalities and durations buffers
  final RxList<SessionModalityModel> apiModalities =
      <SessionModalityModel>[].obs;
  final RxList<SessionDurationModel> apiDurations =
      <SessionDurationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    notesController.text = sessionNotes.value;
    notesController.addListener(() {
      sessionNotes.value = notesController.text;
    });
    if (Get.arguments is Expert) {
      selectDoctor(Get.arguments as Expert);
    }
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }

  void selectDoctor(Expert doctor) {
    selectedDoctor.value = doctor;
    if (doctor.videoCallFeature == true) {
      selectedSessionType.value = "Video Call";
    } else if (doctor.callFeature == true) {
      selectedSessionType.value = "Voice Call";
    } else {
      selectedSessionType.value = "Video Call";
    }

    selectedDate.value = null;
    selectedTimeSlot.value = null;
    timeSlots.clear();

    initBookingSessionFlow();
  }

  Future<void> initBookingSessionFlow() async {
    final doctor = selectedDoctor.value;
    if (doctor == null) return;

    isLoading.value = true;
    try {
      // 1. Generate local dates (next 14 days)
      final List<DateTime> dates = [];
      final today = DateTime.now();
      for (int i = 0; i < 14; i++) {
        dates.add(today.add(Duration(days: i)));
      }
      availableDates.assignAll(dates);
      if (dates.isNotEmpty) {
        selectedDate.value = dates.first;
      }

      // 2. Fetch availability for selectedDate and session info in parallel
      await Future.wait([
        if (selectedDate.value != null)
          fetchDoctorAvailability(selectedDate.value!),
        fetchSessionInfo(),
      ]);
    } catch (e) {
      Get.log("Failed to initialize booking session flow: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSessionInfo({bool forceRefresh = false}) async {
    final doctor = selectedDoctor.value;
    if (doctor == null) return;

    final String infoCacheKey = StorageKeys.sessionInfo(doctor.id!);
    final String infoLastUpdatedCacheKey = StorageKeys.sessionInfoLastUpdated(
      doctor.id!,
    );

    if (forceRefresh) {
      await StorageUtils.remove(infoCacheKey);
      await StorageUtils.remove(infoLastUpdatedCacheKey);
    }

    try {
      // 1. Read from local cache first
      final cachedInfo = StorageUtils.read<Map<String, dynamic>>(infoCacheKey);
      final cachedLastUpdated = StorageUtils.read<String>(
        infoLastUpdatedCacheKey,
      );

      bool hasCache = false;
      if (cachedInfo != null && cachedLastUpdated != null) {
        final info = SessionInfoModel.fromJson(cachedInfo);
        apiModalities.assignAll(info.modalities);
        apiDurations.assignAll(info.durations);
        hasCache = true;
      }

      if (hasCache) {
        _applyDefaultModalityAndDuration();
      } else {
        isLoading.value = true;
      }

      // 2. Fetch from backend with lastUpdated optimization
      final String? lastUpdatedQuery = (hasCache && !forceRefresh)
          ? cachedLastUpdated
          : null;
      final res = await BookingSessionService.getSessionInfo(
        doctorId: doctor.id!,
        lastUpdated: lastUpdatedQuery,
      );

      if (res != null && res.data != null) {
        final info = res.data!;
        apiModalities.assignAll(info.modalities);
        apiDurations.assignAll(info.durations);

        // Cache the fresh data
        await StorageUtils.write(infoCacheKey, info.toJson());
        if (res.lastUpdated != null) {
          await StorageUtils.write(
            infoLastUpdatedCacheKey,
            res.lastUpdated!.toIso8601String(),
          );
        }

        _applyDefaultModalityAndDuration();
      }
    } catch (e) {
      Get.log("Failed to fetch session info: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _applyDefaultModalityAndDuration() {
    if (apiModalities.isNotEmpty) {
      final currentType = selectedSessionType.value;
      final exists = apiModalities.any((m) => m.type == currentType);
      if (!exists) {
        selectedSessionType.value = apiModalities.first.type;
      }
    }
    if (apiDurations.isNotEmpty) {
      final currentDuration = selectedDuration.value;
      final exists = apiDurations.any((d) => d.minutes == currentDuration);
      if (!exists) {
        selectedDuration.value = apiDurations.first.minutes;
      }
    }
    updateSessionPrice();
  }

  Future<void> fetchDoctorAvailability(
    DateTime date, {
    bool forceRefresh = false,
  }) async {
    final doctor = selectedDoctor.value;
    if (doctor == null) return;

    final dateStr = date.toIso8601String().split('T')[0];
    final String availCacheKey = StorageKeys.doctorAvailability(
      doctor.id!,
      dateStr,
    );

    if (forceRefresh) {
      await StorageUtils.remove(availCacheKey);
    }

    try {
      // 1. Read from cache first
      final cachedAvail = StorageUtils.read<Map<String, dynamic>>(
        availCacheKey,
      );
      bool hasCache = false;
      if (cachedAvail != null) {
        final avail = DoctorAvailabilityModel.fromJson(cachedAvail);
        timeSlots.assignAll(avail.timeSlots);
        hasCache = true;
      }

      if (!hasCache) {
        isLoading.value = true;
      }

      // 2. Fetch fresh availability from API in background/foreground
      final res = await BookingSessionService.getDoctorAvailability(
        doctorId: doctor.id!,
        date: dateStr,
      );

      if (res != null && res.data != null) {
        final DoctorAvailabilityModel freshAvail = res.data!;
        timeSlots.assignAll(freshAvail.timeSlots);

        // Serialize and save to cache
        await StorageUtils.write(availCacheKey, freshAvail.toJson());
      }
    } catch (e) {
      Get.log("Failed to fetch doctor availability: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateSessionPrice() {
    if (apiDurations.isEmpty) {
      sessionPrice.value = 0.0;
      return;
    }
    final durationData = apiDurations.firstWhereOrNull(
      (element) => element.minutes == selectedDuration.value,
    );
    if (durationData != null) {
      if (selectedSessionType.value == "Video Call") {
        sessionPrice.value = durationData.videoCallPrice;
      } else {
        sessionPrice.value = durationData.voiceCallPrice;
      }
    }
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    selectedTimeSlot.value = null; // Clear previous time slot selection
    fetchDoctorAvailability(date);
  }

  void selectTimeSlot(TimeSlot slot) {
    selectedTimeSlot.value = slot;
  }

  void setSessionType(String type) {
    selectedSessionType.value = type;
    updateSessionPrice();
  }

  void setSessionDuration(int minutes) {
    selectedDuration.value = minutes;
    updateSessionPrice();
  }

  void setSessionNotes(String notes) {
    sessionNotes.value = notes;
  }

  void nextStep() {
    if (currentStep.value < 4) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  Future<void> bookSession() async {
    final doctor = selectedDoctor.value;
    final date = selectedDate.value;
    final slot = selectedTimeSlot.value;
    if (doctor == null || date == null || slot == null) {
      Get.snackbar("Error", "Please complete all booking selections.");
      return;
    }

    isLoading.value = true;
    try {
      final dateStr = date.toIso8601String().split('T')[0];
      final res = await BookingSessionService.createSession(
        doctorId: doctor.id!,
        selectedDate: dateStr,
        selectedTimeSlot: slot.time,
        timeSlotType: slot.period,
        modalityType: selectedSessionType.value,
        duration: selectedDuration.value,
        durationCost: sessionPrice.value,
        notes: sessionNotes.value,
      );

      if (res != null && res.data != null) {
        bookedSession.value = res.data;
        notesController.clear();
        sessionNotes.value = "";

        // Push booking confirmation screen passing the booked session
        Get.toNamed(Routes.BOOKING_CONFIRMATION);
      } else {
        Get.snackbar(
          "Booking Failed",
          res?.message ?? "An error occurred while booking.",
        );
      }
    } catch (e) {
      Get.snackbar("Booking Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  String formatBookingDate(DateTime date) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    const weekdays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    final month = months[date.month - 1];
    final weekday = weekdays[date.weekday - 1];
    return "$weekday, $month ${date.day}";
  }

  String formatFullDate(DateTime date) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return "${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}";
  }
}
