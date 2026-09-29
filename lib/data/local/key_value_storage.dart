/// A small contract for storing string values locally.
///
/// Keeping the package API behind this contract makes local data sources easy
/// to test and prevents the repository from depending on a plugin.
abstract interface class KeyValueStorage {
  Future<String?> getString(String key);

  Future<void> setString(String key, String value);
}
