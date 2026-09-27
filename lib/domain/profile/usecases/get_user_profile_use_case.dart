import '../../entities/user_profile.dart';
import '../../repo/profile_repository.dart';

class GetUserProfileUseCase {
  const GetUserProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<UserProfile> call() {
    return _repository.getProfile();
  }
}
