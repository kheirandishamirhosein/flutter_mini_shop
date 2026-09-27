import '../../../domain/entities/user_profile.dart';
import '../../../domain/repo/profile_repository.dart';
import '../../local/profile_local_data_source.dart';

/// Coordinates local profile storage for the domain layer.
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._localDataSource);

  final ProfileLocalDataSource _localDataSource;

  @override
  Future<UserProfile> getProfile() {
    return _localDataSource.getProfile();
  }

  @override
  Future<void> updateProfile(UserProfile profile) {
    return _localDataSource.updateProfile(profile);
  }
}
