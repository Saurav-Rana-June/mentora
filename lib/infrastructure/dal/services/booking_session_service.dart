import '../../../../data/methods/api_client.dart';
import '../../../../data/model/api_response.dart';
import 'package:Mentora/presentation/bookingSession/models/booking_session_model.dart';
import 'package:Mentora/data/model/booked_session.model.dart';

class BookingSessionService {
  BookingSessionService._();

  static final ApiClient client = ApiClient();

  /// Retrieve available dates and time slots for a specific doctor
  static Future<ApiResponse<Map<String, dynamic>>?> getDoctorAvailability({
    required int doctorId,
    String? date,
  }) async {
    final Map<String, dynamic> params = {};
    if (date != null && date.isNotEmpty) {
      params['date'] = date;
    }

    return client.request<ApiResponse<Map<String, dynamic>>>(
      (dio) => dio.get(
        'book-session/availability/$doctorId',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<Map<String, dynamic>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            if (data == null) return {};
            final map = data as Map<String, dynamic>;
            final datesList = map['availableDates'] as List<dynamic>? ?? [];
            final slotsList = map['timeSlots'] as List<dynamic>? ?? [];
            return {
              'availableDates': datesList.map((e) => DateTime.parse(e.toString())).toList(),
              'timeSlots': slotsList.map((e) => TimeSlot.fromJson(e as Map<String, dynamic>)).toList(),
            };
          },
        );
      },
    );
  }

  /// Retrieve modalities and pricing details for a specific doctor
  static Future<ApiResponse<Map<String, dynamic>>?> getSessionInfo({
    required int doctorId,
    String? lastUpdated,
  }) async {
    final Map<String, dynamic> params = {};
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      params['lastUpdated'] = lastUpdated;
    }

    return client.request<ApiResponse<Map<String, dynamic>>>(
      (dio) => dio.get(
        'book-session/info/$doctorId',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<Map<String, dynamic>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            if (data == null) return {};
            return data as Map<String, dynamic>;
          },
        );
      },
    );
  }

  /// Create a new session booking
  static Future<ApiResponse<BookedSession>?> createSession({
    required int doctorId,
    required String selectedDate,
    required String selectedTimeSlot,
    required String timeSlotType,
    required String modalityType,
    required int duration,
    required double durationCost,
    String? notes,
  }) async {
    final payload = {
      'doctorId': doctorId,
      'selectedDate': selectedDate,
      'selectedTimeSlot': selectedTimeSlot,
      'timeSlotType': timeSlotType,
      'modalityType': modalityType,
      'duration': duration,
      'durationCost': durationCost,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };

    return client.request<ApiResponse<BookedSession>>(
      (dio) => dio.post(
        'book-session',
        data: payload,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<BookedSession>.fromJson(
          json as Map<String, dynamic>,
          (data) => BookedSession.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Retrieve all booked sessions for the current user
  static Future<ApiResponse<List<BookedSession>>?> getMySessions({
    String? lastUpdated,
  }) async {
    final Map<String, dynamic> params = {};
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      params['lastUpdated'] = lastUpdated;
    }

    return client.request<ApiResponse<List<BookedSession>>>(
      (dio) => dio.get(
        'book-session/my-sessions',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<List<BookedSession>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            if (data == null) return [];
            final list = data as List<dynamic>;
            return list.map((e) => BookedSession.fromJson(e as Map<String, dynamic>)).toList();
          },
        );
      },
    );
  }
}
