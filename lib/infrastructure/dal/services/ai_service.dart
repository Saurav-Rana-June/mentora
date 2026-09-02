import '../../../data/methods/api_client.dart';
import '../../../data/model/api_response.dart';
import '../../../presentation/chatAI/models/chat_session.model.dart';

class AIService {
  AIService._();

  static final ApiClient client = ApiClient();

  /// Query the Gemini AI assistant (and auto-persist under session if sessionId is passed)
  static Future<ApiResponse<Map<String, dynamic>>?> queryAI({
    required String query,
    String? sessionId,
    String? title,
  }) async {
    final body = <String, dynamic>{
      'query': query,
    };
    if (sessionId != null) body['sessionId'] = sessionId;
    if (title != null) body['title'] = title;

    return client.request<ApiResponse<Map<String, dynamic>>>(
      (dio) => dio.post('ai/query', data: body),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<Map<String, dynamic>>.fromJson(
          json as Map<String, dynamic>,
          (data) => data as Map<String, dynamic>,
        );
      },
    );
  }

  /// Fetch all saved chat conversation sessions from the backend
  static Future<ApiResponse<List<ChatSessionModel>>?> fetchSessions() async {
    return client.request<ApiResponse<List<ChatSessionModel>>>(
      (dio) => dio.get('ai/sessions'),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<List<ChatSessionModel>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            final list = data as List<dynamic>? ?? [];
            return list
                .map((e) => ChatSessionModel.fromJson(e as Map<String, dynamic>))
                .toList();
          },
        );
      },
    );
  }

  /// Load previous chat conversation details and all its messages
  static Future<ApiResponse<ChatSessionModel>?> fetchSessionDetails(
    String sessionId,
  ) async {
    return client.request<ApiResponse<ChatSessionModel>>(
      (dio) => dio.get('ai/sessions/$sessionId'),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<ChatSessionModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => ChatSessionModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Explicitly create a new chat session on the backend
  static Future<ApiResponse<ChatSessionModel>?> createSession({
    required String sessionId,
    required String title,
  }) async {
    return client.request<ApiResponse<ChatSessionModel>>(
      (dio) => dio.post(
        'ai/sessions',
        data: {'sessionId': sessionId, 'title': title},
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<ChatSessionModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => ChatSessionModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Delete a chat session and all its messages from the backend
  static Future<ApiResponse<dynamic>?> deleteSession(String sessionId) async {
    return client.request<ApiResponse<dynamic>>(
      (dio) => dio.delete('ai/sessions/$sessionId'),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<dynamic>.fromJson(
          json as Map<String, dynamic>,
          (data) => data,
        );
      },
    );
  }

  /// Clear all chat history from the backend
  static Future<ApiResponse<dynamic>?> clearAllSessions() async {
    return client.request<ApiResponse<dynamic>>(
      (dio) => dio.delete('ai/sessions'),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<dynamic>.fromJson(
          json as Map<String, dynamic>,
          (data) => data,
        );
      },
    );
  }
}
