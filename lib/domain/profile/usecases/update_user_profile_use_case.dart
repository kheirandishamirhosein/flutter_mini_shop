import '../../entities/user_profile.dart';
import '../../repo/profile_repository.dart';

class UpdateUserProfileUseCase {
  const UpdateUserProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<void> call(UserProfile profile) {
    return _repository.updateProfile(profile);
  }
}
