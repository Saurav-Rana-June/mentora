import '../../../../data/methods/api_client.dart';
import '../../../../data/model/api_response.dart';
import '../../../../data/model/token_response.model.dart';
import '../../../../data/model/user.model.dart';

class AuthService {
  AuthService._();

  static final ApiClient client = ApiClient();

  /// Register a new user
  static Future<ApiResponse<UserModel>?> register({
    required String email,
    required String password,
  }) async {
    return client.request<ApiResponse<UserModel>>(
      (dio) => dio.post(
        'users/register',
        data: {
          'email': email,
          'password': password,
        },
      ),
      withAccessToken: false,
      parser: (json) {
        return ApiResponse<UserModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => UserModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Log in a user
  static Future<ApiResponse<TokenResponseModel>?> login({
    required String email,
    required String password,
  }) async {
    return client.request<ApiResponse<TokenResponseModel>>(
      (dio) => dio.post(
        'users/login',
        data: {
          'email': email,
          'password': password,
        },
      ),
      withAccessToken: false,
      parser: (json) {
        return ApiResponse<TokenResponseModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => TokenResponseModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }

  /// Change password for authenticated user
  static Future<ApiResponse<void>?> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    return client.request<ApiResponse<void>>(
      (dio) => dio.post(
        'users/change-password',
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<void>.fromJson(
          json as Map<String, dynamic>,
          (_) => null,
        );
      },
    );
  }

  /// Log out the user
  static Future<ApiResponse<void>?> logout() async {
    return client.request<ApiResponse<void>>(
      (dio) => dio.post(
        'users/logout',
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<void>.fromJson(
          json as Map<String, dynamic>,
          (_) => null,
        );
      },
    );
  }

  /// Auto Sign In user by token
  static Future<ApiResponse<UserModel>?> autoSignIn() async {
    return client.request<ApiResponse<UserModel>>(
      (dio) => dio.post(
        'users/auto-signin',
      ),
      withAccessToken: true,
      parser: (json) {
        return ApiResponse<UserModel>.fromJson(
          json as Map<String, dynamic>,
          (data) => UserModel.fromJson(data as Map<String, dynamic>),
        );
      },
    );
  }
}
