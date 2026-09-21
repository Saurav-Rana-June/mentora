import '../../../../data/methods/api_client.dart';
import '../../../../data/model/api_response.dart';
import '../../../../data/model/plan.model.dart';
import '../../../../data/model/activity.model.dart';

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

  // ---------------- ADMIN CMS ENDPOINTS: ACTIVITIES ---------------- //

  /// List all activities stored in the content catalog (Admin CMS)
  static Future<ApiResponse<List<ActivityModel>>?> getAdminActivities({
    String? category,
    String? tag,
    bool? isActive,
  }) async {
    final Map<String, dynamic> params = {};
    if (category != null && category.isNotEmpty && category != 'All') {
      params['category'] = category;
    }
    if (tag != null && tag.isNotEmpty) {
      params['tag'] = tag;
    }
    if (isActive != null) {
      params['isActive'] = isActive;
    }

    return client.request<ApiResponse<List<ActivityModel>>>(
      (dio) => dio.get(
        'admin/activities',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<List<ActivityModel>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            if (data == null) return [];
            final list = data as List<dynamic>;
            return list
                .map((e) => ActivityModel.fromJson(e as Map<String, dynamic>))
                .toList();
          },
        );
      },
    );
  }

  /// Create a new activity entry in the content catalog (Admin CMS)
  static Future<ApiResponse<ActivityModel>?> createActivity(
    Map<String, dynamic> body,
  ) async {
    return client.request<ApiResponse<ActivityModel>>(
      (dio) => dio.post(
        'admin/activities',
        data: body,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<ActivityModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => ActivityModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Update an existing activity in the catalog (Admin CMS)
  static Future<ApiResponse<ActivityModel>?> updateActivity(
    int activityId,
    Map<String, dynamic> body,
  ) async {
    return client.request<ApiResponse<ActivityModel>>(
      (dio) => dio.put(
        'admin/activities/$activityId',
        data: body,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<ActivityModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => ActivityModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Soft delete an activity (Admin CMS)
  static Future<ApiResponse<ActivityModel>?> deleteActivity(
    int activityId,
  ) async {
    return client.request<ApiResponse<ActivityModel>>(
      (dio) => dio.delete(
        'admin/activities/$activityId',
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<ActivityModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => ActivityModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }
}
