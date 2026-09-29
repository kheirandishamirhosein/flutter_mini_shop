import 'package:shared_preferences/shared_preferences.dart';

import 'key_value_storage.dart';

/// Persistent key-value storage backed by the shared_preferences plugin.
class SharedPreferencesKeyValueStorage implements KeyValueStorage {
  SharedPreferencesKeyValueStorage({Future<SharedPreferences>? preferences})
      : _preferences = preferences ?? SharedPreferences.getInstance();

  final Future<SharedPreferences> _preferences;

  @override
  Future<String?> getString(String key) async {
    return (await _preferences).getString(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    final wasSaved = await (await _preferences).setString(key, value);
    if (!wasSaved) {
      throw StateError('Could not save profile information locally.');
    }
  }
}
