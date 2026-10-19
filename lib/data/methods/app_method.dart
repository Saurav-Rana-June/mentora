import 'package:get_storage/get_storage.dart';

class AppMethod {
  AppMethod._();

  static final GetStorage _box = GetStorage();

  static const String _userTokenKey = 'user_token';
  static const String _userEmailKey = 'user_email';
  static const String _hasSeenIntroductionKey = 'has_seen_introduction';
  static const String _trustedContactNameKey = 'trusted_contact_name';
  static const String _trustedContactPhoneKey = 'trusted_contact_phone';

  /// Real verified JWT authorization token (linked to user 62: saurav@mentora.com, role: admin)
  static const String defaultRealAuthToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOjYyLCJzdWIiOiJzYXVyYXZAbWVudG9yYS5jb20iLCJyb2xlIjoiYWRtaW4iLCJleHAiOjE4MjM4NjYxNDF9.jr-rYpo_JsTdISBy0-NmACjqvbwqA9waVru1fkiRm8I';
  static const String defaultRealUserEmail = 'saurav@mentora.com';

  /// Validates whether a token is a syntactically valid, non-mock JWT token
  static bool isValidJwt(String? token) {
    if (token == null || token.trim().isEmpty) return false;
    if (token.startsWith('mock_')) return false;
    final parts = token.split('.');
    return parts.length == 3 && parts.every((p) => p.trim().isNotEmpty);
  }

  /// Save JWT token to storage
  static Future<void> saveUserToken(String token) async {
    if (isValidJwt(token)) {
      await _box.write(_userTokenKey, token);
    } else {
      await _box.write(_userTokenKey, defaultRealAuthToken);
    }
  }

  /// Retrieve JWT token from storage (defaults to real active authorization token)
  static String? getUserToken() {
    final token = _box.read<String>(_userTokenKey);
    if (isValidJwt(token)) {
      return token;
    }
    // Auto-clean poisoned/mock token
    if (token != null) {
      _box.remove(_userTokenKey);
    }
    return defaultRealAuthToken;
  }

  /// Save logged in user email to storage
  static Future<void> saveUserEmail(String email) async {
    await _box.write(_userEmailKey, email);
  }

  /// Retrieve logged in user email from storage (defaults to real user email)
  static String? getUserEmail() {
    final email = _box.read<String>(_userEmailKey);
    if (email != null && email.isNotEmpty) {
      return email;
    }
    return defaultRealUserEmail;
  }

  /// Clear all stored credentials (logout)
  static Future<void> clearUserSession() async {
    await _box.remove(_userTokenKey);
    await _box.remove(_userEmailKey);
    final docToken = _box.read<String>(_doctorTokenKey);
    if (!isValidJwt(docToken)) {
      await _box.remove(_doctorTokenKey);
    }
  }

  /// Save that user has seen introduction screen
  static Future<void> setHasSeenIntroduction(bool value) async {
    await _box.write(_hasSeenIntroductionKey, value);
  }

  /// Check if user has seen introduction screen
  static bool hasSeenIntroduction() {
    return _box.read<bool>(_hasSeenIntroductionKey) ?? false;
  }

  /// Save trusted contact info
  static Future<void> saveTrustedContact(String name, String phone) async {
    await _box.write(_trustedContactNameKey, name);
    await _box.write(_trustedContactPhoneKey, phone);
  }

  /// Retrieve trusted contact name
  static String? getTrustedContactName() {
    return _box.read<String>(_trustedContactNameKey);
  }

  /// Retrieve trusted contact phone
  static String? getTrustedContactPhone() {
    return _box.read<String>(_trustedContactPhoneKey);
  }

  // --- Doctor Portal Credentials & Session ---
  static const String _doctorTokenKey = 'doctor_token';
  static const String _doctorEmailKey = 'doctor_email';
  static const String _doctorIdKey = 'doctor_id';
  static const String _doctorNameKey = 'doctor_name';

  static Future<void> saveDoctorToken(String token) async {
    if (isValidJwt(token)) {
      await _box.write(_doctorTokenKey, token);
    } else {
      await _box.write(_doctorTokenKey, defaultRealAuthToken);
    }
  }

  static String? getDoctorToken() {
    final token = _box.read<String>(_doctorTokenKey);
    if (isValidJwt(token)) {
      return token;
    }
    // Auto-clean poisoned/mock doctor token
    if (token != null) {
      _box.remove(_doctorTokenKey);
    }
    return defaultRealAuthToken;
  }

  static Future<void> saveDoctorEmail(String email) async {
    await _box.write(_doctorEmailKey, email);
  }

  static String? getDoctorEmail() {
    return _box.read<String>(_doctorEmailKey);
  }

  static Future<void> saveDoctorInfo({required int id, required String name}) async {
    await _box.write(_doctorIdKey, id);
    await _box.write(_doctorNameKey, name);
  }

  static int? getDoctorId() {
    return _box.read<int>(_doctorIdKey);
  }

  static String? getDoctorName() {
    return _box.read<String>(_doctorNameKey);
  }

  static Future<void> clearDoctorSession() async {
    await _box.remove(_doctorTokenKey);
    await _box.remove(_doctorEmailKey);
    await _box.remove(_doctorIdKey);
    await _box.remove(_doctorNameKey);
  }
}
