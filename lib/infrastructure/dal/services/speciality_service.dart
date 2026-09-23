import '../../../../data/methods/api_client.dart';
import '../../../../data/model/api_response.dart';
import '../../../../data/model/speciality.model.dart';

class SpecialityService {
  SpecialityService._();

  static final ApiClient client = ApiClient();

  /// Retrieve list of doctor specialities
  static Future<ApiResponse<List<Speciality>>?> getSpecialities({
    bool includeInactive = false,
    String? lastUpdated,
  }) async {
    final Map<String, dynamic> params = {};
    if (includeInactive) {
      params['include_inactive'] = true;
    }
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      params['lastUpdated'] = lastUpdated;
    }

    final response = await client.request<ApiResponse<List<Speciality>>>(
      (dio) => dio.get(
        'specialities',
        queryParameters: params,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<List<Speciality>>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            if (data is List) {
              return data
                  .map((e) => Speciality.fromJson(e as Map<String, dynamic>))
                  .toList();
            }
            return [];
          },
        );
      },
    );

    return response;
  }

  /// Create a new doctor speciality (Admin CMS)
  static Future<ApiResponse<Speciality>?> createSpeciality(
    Map<String, dynamic> body,
  ) async {
    return client.request<ApiResponse<Speciality>>(
      (dio) => dio.post(
        'admin/specialities',
        data: body,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<Speciality>.fromJson(
          json as Map<String, dynamic>,
          (data) => Speciality.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Update an existing doctor speciality (Admin CMS)
  static Future<ApiResponse<Speciality>?> updateSpeciality(
    int id,
    Map<String, dynamic> body,
  ) async {
    return client.request<ApiResponse<Speciality>>(
      (dio) => dio.put(
        'admin/specialities/$id',
        data: body,
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<Speciality>.fromJson(
          json as Map<String, dynamic>,
          (data) => Speciality.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Delete a doctor speciality (Admin CMS)
  static Future<ApiResponse<Speciality>?> deleteSpeciality(
    int id,
  ) async {
    return client.request<ApiResponse<Speciality>>(
      (dio) => dio.delete(
        'admin/specialities/$id',
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<Speciality>.fromJson(
          json as Map<String, dynamic>,
          (data) => Speciality.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }
}
