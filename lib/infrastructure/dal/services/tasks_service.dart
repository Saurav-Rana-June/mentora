import '../../../../data/methods/api_client.dart';
import '../../../../data/model/api_response.dart';
import '../../../../data/model/tasks/plan.model.dart';

class TasksService {
  TasksService._();

  static final ApiClient client = ApiClient();

  /// Retrieve or generate daily plan
  static Future<ApiResponse<List<PlanModel>>?> getDailyPlan({
    String timezone = "UTC",
  }) async {
    return client.request<ApiResponse<List<PlanModel>>>(
      (dio) => dio.get(
        'tasks/plan',
        queryParameters: {
          'timezone': timezone,
        },
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<List<PlanModel>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            final list = data as List<dynamic>;
            return list
                .map((e) => PlanModel.fromJson(e as Map<String, dynamic>))
                .toList();
          },
        );
      },
    );
  }

  /// Update plan item completion status
  static Future<ApiResponse<PlanModel>?> updatePlanItemCompletion({
    required int planItemId,
    required bool isComplete,
  }) async {
    return client.request<ApiResponse<PlanModel>>(
      (dio) => dio.patch(
        'tasks/plan/$planItemId/complete',
        data: {
          'isComplete': isComplete,
        },
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<PlanModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => PlanModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }
}
