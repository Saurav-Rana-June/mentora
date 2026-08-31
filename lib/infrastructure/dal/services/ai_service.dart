import '../../../../data/methods/api_client.dart';
import '../../../../data/model/api_response.dart';

class AIService {
  AIService._();

  static final ApiClient client = ApiClient();

  /// Query the Gemini AI assistant
  static Future<ApiResponse<Map<String, dynamic>>?> queryAI({required String query}) async {
    return client.request<ApiResponse<Map<String, dynamic>>>(
      (dio) => dio.post('ai/query', data: {'query': query}),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<Map<String, dynamic>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            return data as Map<String, dynamic>;
          },
        );
      },
    );
  }
}
