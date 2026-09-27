import '../entities/user_profile.dart';

/// Domain contract for reading and editing the user's profile.
abstract class ProfileRepository {
  Future<UserProfile> getProfile();

  Future<void> updateProfile(UserProfile profile);
}
