import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData;
import 'package:logger/logger.dart';

import '../enums/snackbar_enum.dart';
import '../utils/app_utils.dart';
import '../../infrastructure/environment/environment.dart';
import '../../infrastructure/navigation/routes.dart';
import 'app_method.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  final log = Logger();
  late final Dio _dio;

  ApiClient._internal() {
    final baseUrl = ConfigEnvironments.getEnvironments()['url']!;
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 45),
        receiveTimeout: const Duration(seconds: 45),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Logging interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log.i('API REQUEST [${options.method}] => ${options.uri}');
          if (options.data != null) {
            if (options.data is FormData) {
              final formData = options.data as FormData;
              final fields = formData.fields.map((e) => '${e.key}: ${e.value}').join(', ');
              final files = formData.files.map((e) => '${e.key}: ${e.value.filename}').join(', ');
              log.i('Request Body (FormData): Fields: [$fields], Files: [$files]');
            } else {
              try {
                log.i('Request Body: ${jsonEncode(options.data)}');
              } catch (_) {
                log.i('Request Body: ${options.data}');
              }
            }
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log.i('API RESPONSE [${response.statusCode}] <= ${response.requestOptions.uri}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          log.e('API ERROR [${e.response?.statusCode}] <= ${e.requestOptions.uri}');
          if (e.response?.data != null) {
            try {
              log.e('Error Response Data: ${jsonEncode(e.response?.data)}');
            } catch (_) {
              log.e('Error Response Data: ${e.response?.data}');
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<T?> request<T>(
    Future<Response> Function(Dio dio) requestFn, {
    bool withAccessToken = true,
    T Function(dynamic json)? parser,
  }) async {
    if (withAccessToken) {
      final token = AppMethod.getUserToken();
      if (token != null && token.isNotEmpty) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      } else {
        _dio.options.headers.remove('Authorization');
      }
    } else {
      _dio.options.headers.remove('Authorization');
    }

    try {
      final response = await requestFn(_dio);
      if (parser != null && response.data != null) {
        return parser(response.data);
      }
      return null;
    } on DioException catch (dioError) {
      _handleDioError(dioError);
      rethrow;
    } catch (e) {
      log.e('General Request Error: $e');
      AppUtils.snackbar(
        'Error',
        'An unexpected error occurred.',
        SnackBarType.ERROR,
      );
      rethrow;
    }
  }

  void _handleDioError(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;

    // Handle 401 Unauthorized globally - clear credentials and boot user out
    if (statusCode == 401) {
      AppMethod.clearUserSession();
      AppUtils.snackbar(
        'Session Expired',
        'Please sign in again.',
        SnackBarType.WARNING,
      );
      Get.offAllNamed(Routes.SIGN_IN);
      return;
    }

    // Extract detail message from backend error response
    String errorMessage = 'Something went wrong';
    if (response?.data != null && response?.data is Map) {
      final data = response!.data as Map;
      if (data.containsKey('detail')) {
        errorMessage = data['detail'].toString();
      } else if (data.containsKey('message')) {
        errorMessage = data['message'].toString();
      }
    } else {
      errorMessage = error.message ?? 'Network connection issue';
    }

    AppUtils.snackbar(
      'Error',
      errorMessage,
      SnackBarType.ERROR,
    );
  }
}
