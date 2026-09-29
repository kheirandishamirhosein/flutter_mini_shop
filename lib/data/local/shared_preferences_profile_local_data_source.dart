import 'dart:convert';

import '../../domain/entities/user_profile.dart';
import 'key_value_storage.dart';
import 'profile_local_data_source.dart';

/// Stores the user's profile as one JSON value in persistent local storage.
class SharedPreferencesProfileLocalDataSource
    implements ProfileLocalDataSource {
  const SharedPreferencesProfileLocalDataSource(this._storage);

  static const _profileKey = 'user_profile';
  static const _defaultProfile = UserProfile(
    fullName: 'Amirhosein Sharifi',
    email: 'amir@example.com',
    phoneNumber: '09120000000',
  );

  final KeyValueStorage _storage;

  @override
  Future<UserProfile> getProfile() async {
    final encodedProfile = await _storage.getString(_profileKey);
    if (encodedProfile == null) {
      return _defaultProfile;
    }

    try {
      final decodedProfile = jsonDecode(encodedProfile);
      if (decodedProfile is! Map<String, dynamic>) {
        return _defaultProfile;
      }

      final fullName = decodedProfile['fullName'];
      final email = decodedProfile['email'];
      final phoneNumber = decodedProfile['phoneNumber'];
      if (fullName is! String || email is! String || phoneNumber is! String) {
        return _defaultProfile;
      }

      return UserProfile(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
      );
    } on FormatException {
      return _defaultProfile;
    }
  }

  @override
  Future<void> updateProfile(UserProfile profile) {
    return _storage.setString(
      _profileKey,
      jsonEncode(<String, String>{
        'fullName': profile.fullName,
        'email': profile.email,
        'phoneNumber': profile.phoneNumber,
      }),
    );
  }
}
