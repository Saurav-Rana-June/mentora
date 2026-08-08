class ApiResponse<T> {
  int? status;
  String? message;
  T? data;
  DateTime? lastUpdated;

  ApiResponse({
    this.status,
    this.message,
    this.data,
    this.lastUpdated,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['status'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.tryParse(json['lastUpdated'] as String)
          : null,
    );
  }
}

