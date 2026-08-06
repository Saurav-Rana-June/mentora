import 'package:get_storage/get_storage.dart';

class AppMethod {
  AppMethod._();

  static final GetStorage _box = GetStorage();

  static const String _userTokenKey = 'user_token';
  static const String _userEmailKey = 'user_email';
  static const String _hasSeenIntroductionKey = 'has_seen_introduction';
  static const String _trustedContactNameKey = 'trusted_contact_name';
  static const String _trustedContactPhoneKey = 'trusted_contact_phone';

  /// Save JWT token to storage
  static Future<void> saveUserToken(String token) async {
    await _box.write(_userTokenKey, token);
  }

  /// Retrieve JWT token from storage
  static String? getUserToken() {
    return _box.read<String>(_userTokenKey);
  }

  /// Save logged in user email to storage
  static Future<void> saveUserEmail(String email) async {
    await _box.write(_userEmailKey, email);
  }

  /// Retrieve logged in user email from storage
  static String? getUserEmail() {
    return _box.read<String>(_userEmailKey);
  }

  /// Clear all stored credentials (logout)
  static Future<void> clearUserSession() async {
    await _box.remove(_userTokenKey);
    await _box.remove(_userEmailKey);
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
}
