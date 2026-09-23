import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../../../data/methods/api_client.dart';
import '../../../../data/model/api_response.dart';
import '../../../../data/model/expert.model.dart';
import '../../../../data/model/paginated_experts.model.dart';

class DoctorService {
  DoctorService._();

  static final ApiClient client = ApiClient();

  /// Retrieve all doctors with optional filters (paginated)
  static Future<ApiResponse<PaginatedExpertsModel>> getDoctors({
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

    final response = await client.request<ApiResponse<PaginatedExpertsModel>>(
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

    return response ??
        ApiResponse<PaginatedExpertsModel>(
          status: 500,
          message: 'Failed to fetch doctors',
          data: PaginatedExpertsModel(
            items: [],
            page: 1,
            size: 10,
            totalItems: 0,
            totalPages: 1,
          ),
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

  // ---------------- ADMIN CMS ENDPOINTS ---------------- //

  /// Create a new doctor profile (Admin CMS)
  static Future<ApiResponse<Expert>?> createDoctor(
    Map<String, dynamic> body,
  ) async {
    return client.request<ApiResponse<Expert>>(
      (dio) => dio.post(
        'admin/doctors',
        data: body,
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

  /// Update an existing doctor profile (Admin CMS)
  static Future<ApiResponse<Expert>?> updateDoctor(
    int doctorId,
    Map<String, dynamic> body,
  ) async {
    return client.request<ApiResponse<Expert>>(
      (dio) => dio.put(
        'admin/doctors/$doctorId',
        data: body,
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

  /// Delete a doctor profile (Admin CMS)
  static Future<ApiResponse<Expert>?> deleteDoctor(
    int doctorId,
  ) async {
    return client.request<ApiResponse<Expert>>(
      (dio) => dio.delete(
        'admin/doctors/$doctorId',
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

  /// Upload doctor avatar image (Admin CMS)
  static Future<ApiResponse<String>?> uploadDoctorAvatar({
    List<int>? bytes,
    String? filePath,
    required String fileName,
  }) async {
    final safeName = fileName.isEmpty ? 'doctor.jpg' : fileName;
    final mediaType = _mediaTypeForImagePath(safeName);

    final MultipartFile multipartFile;
    if (bytes != null) {
      multipartFile = MultipartFile.fromBytes(
        bytes,
        filename: safeName,
        contentType: mediaType,
      );
    } else if (filePath != null) {
      multipartFile = MultipartFile.fromFileSync(
        filePath,
        filename: safeName,
        contentType: mediaType,
      );
    } else {
      throw ArgumentError('Either bytes or filePath must be provided');
    }

    final formData = FormData.fromMap({
      'data': multipartFile,
    });

    return client.request<ApiResponse<String>>(
      (dio) => dio.post(
        'admin/doctors/upload-avatar',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<String>.fromJson(
          json as Map<String, dynamic>,
          (data) {
            if (data is Map && data.containsKey('url')) {
              return data['url'].toString();
            }
            return data.toString();
          },
        );
      },
    );
  }

  static MediaType _mediaTypeForImagePath(String path) {
    final ext = path
        .replaceAll(r'\', '/')
        .split('/')
        .last
        .split('.')
        .last
        .toLowerCase();
    switch (ext) {
      case 'png':
        return MediaType('image', 'png');
      case 'webp':
        return MediaType('image', 'webp');
      case 'gif':
        return MediaType('image', 'gif');
      case 'jpg':
      case 'jpeg':
      default:
        return MediaType('image', 'jpeg');
    }
  }
}
