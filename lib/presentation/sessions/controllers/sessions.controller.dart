import 'package:get/get.dart';

class SessionsController extends GetxController {
  // Toggle between: true (Upcoming) and false (Completed)
  final RxBool isUpcomingSelected = true.obs;

  final RxList<SessionModel> upcomingSessions = <SessionModel>[
    SessionModel(
      expertName: "Dr. William Butcher",
      specialty: "Clinical Psychologist",
      imageUrl: "https://randomuser.me/api/portraits/men/32.jpg",
      dateTime: "July 28, 2026 • 10:00 AM",
      callType: "Video Call",
      status: "Confirmed",
    ),
    SessionModel(
      expertName: "Dr. Emily Carter",
      specialty: "Family Therapist",
      imageUrl: "https://randomuser.me/api/portraits/women/44.jpg",
      dateTime: "August 02, 2026 • 02:30 PM",
      callType: "Voice Call",
      status: "Scheduled",
    ),
  ].obs;

  final RxList<SessionModel> completedSessions = <SessionModel>[
    SessionModel(
      expertName: "Dr. Michael Reed",
      specialty: "Behavioral Specialist",
      imageUrl: "https://randomuser.me/api/portraits/men/76.jpg",
      dateTime: "July 15, 2026 • 11:00 AM",
      callType: "Video Call",
      status: "Completed",
    ),
    SessionModel(
      expertName: "Dr. Sophia Turner",
      specialty: "Child Psychologist",
      imageUrl: "https://randomuser.me/api/portraits/women/68.jpg",
      dateTime: "July 10, 2026 • 04:00 PM",
      callType: "Voice Call",
      status: "Completed",
    ),
  ].obs;

  void toggleTab(bool upcoming) {
    isUpcomingSelected.value = upcoming;
  }

  void addSession(SessionModel session) {
    upcomingSessions.insert(0, session);
  }
}

class SessionModel {
  final String expertName;
  final String specialty;
  final String imageUrl;
  final String dateTime;
  final String callType;
  final String status;

  SessionModel({
    required this.expertName,
    required this.specialty,
    required this.imageUrl,
    required this.dateTime,
    required this.callType,
    required this.status,
  });
}
