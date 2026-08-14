import '../../../../data/methods/api_client.dart';
import '../../../../data/model/api_response.dart';
import 'package:Mentora/data/model/journal_entry.model.dart';
import 'package:Mentora/data/model/journal_question.model.dart';

class JournalingService {
  JournalingService._();

  static final ApiClient client = ApiClient();

  /// Retrieve preset journaling questions
  static Future<ApiResponse<List<JournalQuestionModel>>?> getJournalingQuestions({
    String? lastUpdated,
  }) async {
    final Map<String, dynamic> params = {};
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      params['lastUpdated'] = lastUpdated;
    }

    return client.request<ApiResponse<List<JournalQuestionModel>>>(
      (dio) => dio.get(
        'journaling/questions',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<List<JournalQuestionModel>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            if (data == null) return [];
            final list = data as List<dynamic>;
            return list
                .map((e) => JournalQuestionModel.fromJson(e as Map<String, dynamic>))
                .toList();
          },
        );
      },
    );
  }

  /// Retrieve all user journal entries
  static Future<ApiResponse<List<JournalEntryModel>>?> getJournalingEntries({
    String? lastUpdated,
  }) async {
    final Map<String, dynamic> params = {};
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      params['lastUpdated'] = lastUpdated;
    }

    return client.request<ApiResponse<List<JournalEntryModel>>>(
      (dio) => dio.get(
        'journaling/entries',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<List<JournalEntryModel>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            if (data == null) return [];
            final list = data as List<dynamic>;
            return list
                .map((e) => JournalEntryModel.fromJson(e as Map<String, dynamic>))
                .toList();
          },
        );
      },
    );
  }

  /// Create a new journal entry
  static Future<ApiResponse<JournalEntryModel>?> createJournalingEntry({
    required String question,
    required String answer,
    String? imagePath,
  }) async {
    return client.request<ApiResponse<JournalEntryModel>>(
      (dio) => dio.post(
        'journaling/entries',
        data: {
          'question': question,
          'answer': answer,
          if (imagePath != null) 'imagePath': imagePath,
        },
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<JournalEntryModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => JournalEntryModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Update an existing journal entry
  static Future<ApiResponse<JournalEntryModel>?> updateJournalingEntry({
    required String id,
    required String answer,
    String? imagePath,
  }) async {
    return client.request<ApiResponse<JournalEntryModel>>(
      (dio) => dio.put(
        'journaling/entries/$id',
        data: {
          'answer': answer,
          'imagePath': imagePath,
        },
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<JournalEntryModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => JournalEntryModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Delete a journal entry
  static Future<ApiResponse<JournalEntryModel>?> deleteJournalingEntry({
    required String id,
  }) async {
    return client.request<ApiResponse<JournalEntryModel>>(
      (dio) => dio.delete(
        'journaling/entries/$id',
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<JournalEntryModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => JournalEntryModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }
}
