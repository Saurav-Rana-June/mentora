class TokenResponse {
  final String accessToken;
  final String tokenType;

  TokenResponse({
    required this.accessToken,
    required this.tokenType,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      accessToken: json['accessToken'] as String,
      tokenType: json['tokenType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'tokenType': tokenType,
    };
  }
}
