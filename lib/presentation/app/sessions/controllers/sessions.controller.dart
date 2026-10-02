import 'package:get/get.dart';
import 'package:Mentora/data/model/booked_session.model.dart';
import 'package:Mentora/data/utils/storage_utils.dart';
import 'package:Mentora/infrastructure/dal/services/booking_session_service.dart';

class SessionsController extends GetxController {
  // Toggle between: true (Upcoming) and false (Completed)
  final RxBool isUpcomingSelected = true.obs;

  final RxList<SessionModel> upcomingSessions = <SessionModel>[].obs;
  final RxList<SessionModel> completedSessions = <SessionModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCachedSessions();
    fetchSessions();
  }

  void toggleTab(bool upcoming) {
    isUpcomingSelected.value = upcoming;
  }

  void loadCachedSessions() {
    try {
      final cachedList = StorageUtils.read<List<dynamic>>(StorageKeys.MY_SESSIONS);
      if (cachedList != null) {
        final parsed = cachedList
            .map((json) => BookedSession.fromJson(Map<String, dynamic>.from(json as Map)))
            .toList();
        _distributeSessions(parsed);
      }
    } catch (e) {
      Get.log("Failed to load cached sessions: $e");
    }
  }

  Future<void> fetchSessions() async {
    isLoading.value = upcomingSessions.isEmpty && completedSessions.isEmpty;
    try {
      final cachedLastUpdated = StorageUtils.read<String>(StorageKeys.MY_SESSIONS_LAST_UPDATED);

      if (cachedLastUpdated != null && (upcomingSessions.isNotEmpty || completedSessions.isNotEmpty)) {
        // Background check for updates
        final checkRes = await BookingSessionService.getMySessions(lastUpdated: cachedLastUpdated);
        if (checkRes != null) {
          final serverLastUpdated = checkRes.lastUpdated;
          final cachedDateTime = DateTime.tryParse(cachedLastUpdated);
          if (serverLastUpdated != null && cachedDateTime != null && serverLastUpdated.isAtSameMomentAs(cachedDateTime)) {
            isLoading.value = false;
            return; // Cache is still up to date
          }
        }
      }

      // Execute full API call to get fresh data
      final res = await BookingSessionService.getMySessions();
      if (res != null && res.data != null) {
        final List<BookedSession> sessions = res.data!;

        // Update local storage cache
        await StorageUtils.write(StorageKeys.MY_SESSIONS, sessions.map((e) => e.toJson()).toList());
        if (res.lastUpdated != null) {
          await StorageUtils.write(StorageKeys.MY_SESSIONS_LAST_UPDATED, res.lastUpdated!.toIso8601String());
        }

        _distributeSessions(sessions);
      }
    } catch (e) {
      Get.log("Failed to fetch sessions: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSessionStatus(int sessionId, String status) async {
    try {
      final res = await BookingSessionService.updateSessionStatus(
        sessionId: sessionId,
        bookingStatus: status,
      );
      if (res != null && res.data != null) {
        // Refresh local list and storage
        await fetchSessions();
      }
    } catch (e) {
      Get.log("Failed to update session status: $e");
    }
  }

  void _distributeSessions(List<BookedSession> sessions) {
    final List<SessionModel> upcoming = [];
    final List<SessionModel> completed = [];

    for (final s in sessions) {
      final statusLower = s.bookingStatus.toLowerCase();
      final isPast = statusLower == 'completed' ||
          statusLower == 'cancelled' ||
          statusLower == 'canceled' ||
          statusLower == 'declined';

      final mapped = SessionModel(
        id: s.id,
        doctorId: s.doctorId,
        expertName: s.doctorName ?? "Unknown Doctor",
        specialty: s.doctorSpeciality ?? "Mental Health Professional",
        imageUrl: s.doctorImage ?? "https://randomuser.me/api/portraits/men/32.jpg",
        dateTime: _formatDateTime(s.bookingDate, s.bookingTimeslot),
        callType: s.modalityType,
        status: s.bookingStatus,
        duration: s.duration,
        notes: s.notes,
      );

      if (isPast) {
        completed.add(mapped);
      } else {
        upcoming.add(mapped);
      }
    }

    upcomingSessions.assignAll(upcoming);
    completedSessions.assignAll(completed);
  }

  String _formatDateTime(String dateStr, String timeslot) {
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
      ];
      final monthName = months[date.month - 1];
      final dayStr = date.day.toString().padLeft(2, '0');
      return "$monthName $dayStr, ${date.year} • $timeslot";
    } catch (_) {
      return "$dateStr • $timeslot";
    }
  }
}

class SessionModel {
  final int? id;
  final int? doctorId;
  final String expertName;
  final String specialty;
  final String imageUrl;
  final String dateTime;
  final String callType;
  final String status;
  final int duration;
  final String? notes;

  SessionModel({
    this.id,
    this.doctorId,
    required this.expertName,
    required this.specialty,
    required this.imageUrl,
    required this.dateTime,
    required this.callType,
    required this.status,
    this.duration = 30,
    this.notes,
  });
}
