import '../../../../data/methods/api_client.dart';
import '../../../../data/model/api_response.dart';
import '../../../../data/model/auth/profile.model.dart';

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

  /// Update Profile Picture URL
  static Future<ApiResponse<ProfileModel>?> updateProfilePicture(String url) async {
    return client.request<ApiResponse<ProfileModel>>(
      (dio) => dio.put(
        'profile/picture',
        data: {
          'profilePictureUrl': url,
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
}
