import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/data/local/key_value_storage.dart';
import 'package:mini_shop/data/local/shared_preferences_profile_local_data_source.dart';
import 'package:mini_shop/domain/entities/user_profile.dart';

void main() {
  test('returns the default profile when local storage is empty', () async {
    final dataSource = SharedPreferencesProfileLocalDataSource(
      _FakeKeyValueStorage(),
    );

    expect(
      await dataSource.getProfile(),
      const UserProfile(
        fullName: 'Amirhosein Sharifi',
        email: 'amir@example.com',
        phoneNumber: '09120000000',
      ),
    );
  });

  test('persists and restores an updated profile', () async {
    final storage = _FakeKeyValueStorage();
    final dataSource = SharedPreferencesProfileLocalDataSource(storage);
    const updatedProfile = UserProfile(
      fullName: 'Updated user',
      email: 'updated@example.com',
      phoneNumber: '09350000000',
    );

    await dataSource.updateProfile(updatedProfile);

    final recreatedDataSource =
        SharedPreferencesProfileLocalDataSource(storage);
    final restoredProfile = await recreatedDataSource.getProfile();

    expect(restoredProfile.fullName, updatedProfile.fullName);
    expect(restoredProfile.email, updatedProfile.email);
    expect(restoredProfile.phoneNumber, updatedProfile.phoneNumber);
  });

  test('uses the default profile when the stored value is malformed', () async {
    final dataSource = SharedPreferencesProfileLocalDataSource(
      _FakeKeyValueStorage()..values['user_profile'] = 'not valid json',
    );

    expect(
      await dataSource.getProfile(),
      const UserProfile(
        fullName: 'Amirhosein Sharifi',
        email: 'amir@example.com',
        phoneNumber: '09120000000',
      ),
    );
  });
}

class _FakeKeyValueStorage implements KeyValueStorage {
  final values = <String, String>{};

  @override
  Future<String?> getString(String key) async => values[key];

  @override
  Future<void> setString(String key, String value) async {
    values[key] = value;
  }
}
