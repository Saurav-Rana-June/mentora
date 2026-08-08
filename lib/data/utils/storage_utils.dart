import 'package:get_storage/get_storage.dart';

class StorageUtils {
  StorageUtils._();

  static final GetStorage _box = GetStorage();

  /// Reads a value of type [T] from local storage.
  static T? read<T>(String key) {
    return _box.read<T>(key);
  }

  /// Writes [value] to local storage.
  static Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  /// Removes a value from local storage.
  static Future<void> remove(String key) async {
    await _box.remove(key);
  }
}
