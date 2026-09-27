import '../../domain/entities/user_profile.dart';

/// Local storage contract for profile information.
abstract class ProfileLocalDataSource {
  Future<UserProfile> getProfile();

  Future<void> updateProfile(UserProfile profile);
}
