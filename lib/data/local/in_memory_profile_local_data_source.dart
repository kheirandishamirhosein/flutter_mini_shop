import '../../domain/entities/user_profile.dart';
import 'profile_local_data_source.dart';

/// A temporary profile store that keeps edits while the app is running.
///
/// A persistent local data source can replace this class later without
/// changing the repository contract or presentation layer.
class InMemoryProfileLocalDataSource implements ProfileLocalDataSource {
  UserProfile _profile = const UserProfile(
    fullName: 'Amirhosein Sharifi',
    email: 'amir@example.com',
    phoneNumber: '09120000000',
  );

  @override
  Future<UserProfile> getProfile() async => _profile;

  @override
  Future<void> updateProfile(UserProfile profile) async {
    _profile = profile;
  }
}
