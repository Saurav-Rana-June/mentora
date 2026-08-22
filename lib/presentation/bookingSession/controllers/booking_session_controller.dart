import 'package:flutter/material.dart';
import 'package:Mentora/data/model/expert.model.dart';
import 'package:get/get.dart';
import 'package:Mentora/presentation/bookingSession/models/booking_session_model.dart';
import 'package:Mentora/presentation/sessions/controllers/sessions.controller.dart';

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

  final TextEditingController notesController = TextEditingController();

  // Available lists
  final RxList<DateTime> availableDates = <DateTime>[].obs;
  final RxList<TimeSlot> timeSlots = <TimeSlot>[].obs;

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
    generateAvailableDates();
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }

  void generateAvailableDates() {
    final List<DateTime> dates = [];
    final today = DateTime.now();
    for (int i = 0; i < 14; i++) {
      dates.add(today.add(Duration(days: i)));
    }
    availableDates.assignAll(dates);
    // Auto-select today
    if (dates.isNotEmpty) {
      selectDate(dates.first);
    }
  }

  void selectDoctor(Expert doctor) {
    selectedDoctor.value = doctor;
    // Set default session type based on features
    if (doctor.videoCallFeature == true) {
      selectedSessionType.value = "Video Call";
    } else if (doctor.callFeature == true) {
      selectedSessionType.value = "Voice Call";
    } else {
      selectedSessionType.value = "Video Call";
    }
    updateSessionPrice();
  }

  void updateSessionPrice() {
    final doctor = selectedDoctor.value;
    if (doctor == null) {
      sessionPrice.value = 0.0;
      return;
    }
    final hourlyRate = doctor.startingPricePerHour ?? 100.0;
    final modalityMultiplier = selectedSessionType.value == "Video Call" ? 1.0 : 0.8;
    final durationFraction = selectedDuration.value / 60.0;
    sessionPrice.value = hourlyRate * durationFraction * modalityMultiplier;
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    selectedTimeSlot.value = null; // Clear previous time slot selection
    generateTimeSlots(date);
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

  void generateTimeSlots(DateTime date) {
    // Generate static slots grouped by period
    final List<TimeSlot> slots = [
      TimeSlot(time: "09:00 AM", period: "Morning", isAvailable: true),
      TimeSlot(time: "09:30 AM", period: "Morning", isAvailable: true),
      TimeSlot(
        time: "10:00 AM",
        period: "Morning",
        isAvailable: false,
      ), // simulate booked
      TimeSlot(time: "10:30 AM", period: "Morning", isAvailable: true),
      TimeSlot(time: "11:00 AM", period: "Morning", isAvailable: true),

      TimeSlot(time: "01:30 PM", period: "Afternoon", isAvailable: true),
      TimeSlot(time: "02:00 PM", period: "Afternoon", isAvailable: true),
      TimeSlot(time: "02:30 PM", period: "Afternoon", isAvailable: true),
      TimeSlot(
        time: "03:00 PM",
        period: "Afternoon",
        isAvailable: false,
      ), // simulate booked
      TimeSlot(time: "03:30 PM", period: "Afternoon", isAvailable: true),

      TimeSlot(time: "05:00 PM", period: "Evening", isAvailable: true),
      TimeSlot(time: "05:30 PM", period: "Evening", isAvailable: true),
      TimeSlot(time: "06:00 PM", period: "Evening", isAvailable: true),
      TimeSlot(time: "06:30 PM", period: "Evening", isAvailable: true),
      TimeSlot(
        time: "07:00 PM",
        period: "Evening",
        isAvailable: false,
      ), // simulate booked
    ];

    // If date is today, disable past slots
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      final List<TimeSlot> adjustedSlots = [];
      for (var slot in slots) {
        final parsedTime = _parseTimeOfDay(slot.time, date);
        if (parsedTime.isBefore(now)) {
          adjustedSlots.add(
            TimeSlot(time: slot.time, period: slot.period, isAvailable: false),
          );
        } else {
          adjustedSlots.add(slot);
        }
      }
      timeSlots.assignAll(adjustedSlots);
    } else {
      timeSlots.assignAll(slots);
    }
  }

  DateTime _parseTimeOfDay(String timeStr, DateTime date) {
    // Parse formats like "09:30 AM" or "02:00 PM"
    final parts = timeStr.split(" ");
    final timeParts = parts[0].split(":");
    int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);
    final String amPm = parts[1];

    if (amPm == "PM" && hour != 12) {
      hour += 12;
    } else if (amPm == "AM" && hour == 12) {
      hour = 0;
    }

    return DateTime(date.year, date.month, date.day, hour, minute);
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
    if (selectedDoctor.value == null ||
        selectedDate.value == null ||
        selectedTimeSlot.value == null) {
      Get.snackbar(
        "Invalid Selection",
        "Please select a doctor, date, and time slot.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      // Simulate network request
      await Future.delayed(const Duration(milliseconds: 1500));

      // Build SessionModel
      final docName = selectedDoctor.value?.name ?? "Therapist";
      final docSpecialty = selectedDoctor.value?.speciality ?? "Specialist";
      final docImage =
          selectedDoctor.value?.image ??
          "https://randomuser.me/api/portraits/men/32.jpg";
      final formattedDate =
          formatFullDate(selectedDate.value!) +
          " • " +
          selectedTimeSlot.value!.time +
          " (${selectedDuration.value} mins)";

      final newSession = SessionModel(
        expertName: docName,
        specialty: docSpecialty,
        imageUrl: docImage,
        dateTime: formattedDate,
        callType: selectedSessionType.value,
        status: "Confirmed",
      );

      // Add to SessionsController if registered
      if (Get.isRegistered<SessionsController>()) {
        Get.find<SessionsController>().addSession(newSession);
      }

      // Move to success step
      currentStep.value = 4;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Could not book your session. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
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
