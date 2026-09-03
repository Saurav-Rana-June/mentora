import '../../../../data/methods/api_client.dart';
import '../../../../data/model/api_response.dart';
import '../../../../data/model/expert.model.dart';
import '../../../../data/model/paginated_experts.model.dart';

class DoctorService {
  DoctorService._();

  static final ApiClient client = ApiClient();

  /// Retrieve all doctors with optional filters (paginated)
  static Future<ApiResponse<PaginatedExpertsModel>?> getDoctors({
    String? speciality,
    String? search,
    int? page,
    int? size,
    String? lastUpdated,
  }) async {
    final Map<String, dynamic> params = {};
    if (speciality != null && speciality != 'All') {
      params['speciality'] = speciality;
    }
    if (search != null && search.isNotEmpty) {
      params['search'] = search;
    }
    if (page != null) {
      params['page'] = page;
    }
    if (size != null) {
      params['size'] = size;
    }
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      params['lastUpdated'] = lastUpdated;
    }

    return client.request<ApiResponse<PaginatedExpertsModel>>(
      (dio) => dio.get(
        'doctors',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<PaginatedExpertsModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => PaginatedExpertsModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Retrieve details of a single doctor by ID
  static Future<ApiResponse<Expert>?> getDoctorDetails({
    required int doctorId,
    String? lastUpdated,
  }) async {
    final Map<String, dynamic> params = {};
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      params['lastUpdated'] = lastUpdated;
    }

    return client.request<ApiResponse<Expert>>(
      (dio) => dio.get(
        'doctors/$doctorId',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<Expert>.fromJson(
          json as Map<String, dynamic>,
          (data) => Expert.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }
}
