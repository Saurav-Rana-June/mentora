import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../../../data/methods/api_client.dart';
import '../../../../data/model/api_response.dart';
import '../../../../data/model/profile.model.dart';

class ProfileService {
  ProfileService._();

  static final ApiClient client = ApiClient();

  /// Retrieve Current User Profile
  static Future<ApiResponse<ProfileModel>?> getProfile() async {
    return client.request<ApiResponse<ProfileModel>>(
      (dio) => dio.get('profile/me'),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<ProfileModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => ProfileModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Update Profile Attributes
  static Future<ApiResponse<ProfileModel>?> updateProfile({
    String? name,
    String? gender,
    int? age,
    String? email,
    String? address,
    double? height,
    double? weight,
    String? phoneNumber,
  }) async {
    return client.request<ApiResponse<ProfileModel>>(
      (dio) => dio.put(
        'profile/update',
        data: {
          if (name != null) 'name': name,
          if (gender != null) 'gender': gender,
          if (age != null) 'age': age,
          if (email != null) 'email': email,
          if (address != null) 'address': address,
          if (height != null) 'height': height,
          if (weight != null) 'weight': weight,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
        },
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<ProfileModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => ProfileModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Upload and Update Profile Picture (Multipart)
  static Future<ApiResponse<ProfileModel>?> uploadProfilePicture({
    required int userId,
    required String filePath,
    required String fileName,
  }) async {
    final safeName = fileName.isEmpty ? 'profile.jpg' : fileName;
    final formData = FormData.fromMap({
      'data': MultipartFile.fromFileSync(
        filePath,
        filename: safeName,
        contentType: _mediaTypeForImagePath(filePath),
      ),
    });

    return client.request<ApiResponse<ProfileModel>>(
      (dio) => dio.put(
        'profile/update-profile-picture/$userId',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<ProfileModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => ProfileModel.fromJson(data as Map<String, dynamic>),
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

  /// Delete Profile Picture
  static Future<ApiResponse<ProfileModel>?> deleteProfilePicture({
    required int userId,
  }) async {
    return client.request<ApiResponse<ProfileModel>>(
      (dio) => dio.delete('profile/delete-profile-picture/$userId'),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<ProfileModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => ProfileModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }
}
