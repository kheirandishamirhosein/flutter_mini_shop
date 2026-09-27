import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/domain/entities/user_profile.dart';
import 'package:mini_shop/domain/profile/usecases/get_user_profile_use_case.dart';
import 'package:mini_shop/domain/profile/usecases/update_user_profile_use_case.dart';
import 'package:mini_shop/domain/repo/profile_repository.dart';

void main() {
  test('gets the profile from the repository', () async {
    final repository = _FakeProfileRepository();

    final profile = await GetUserProfileUseCase(repository)();

    expect(profile.fullName, 'Amirhosein Sharifi');
  });

  test('forwards profile edits to the repository', () async {
    final repository = _FakeProfileRepository();
    const updatedProfile = UserProfile(
      fullName: 'Amirhosein Sharifi',
      email: 'amir@example.com',
      phoneNumber: '09120000000',
    );

    await UpdateUserProfileUseCase(repository)(updatedProfile);

    expect(repository.updatedProfile, same(updatedProfile));
  });
}

class _FakeProfileRepository implements ProfileRepository {
  UserProfile? updatedProfile;

  @override
  Future<UserProfile> getProfile() async {
    return const UserProfile(
      fullName: 'Amirhosein Sharifi',
      email: 'amir@example.com',
      phoneNumber: '09120000000',
    );
  }

  @override
  Future<void> updateProfile(UserProfile profile) async {
    updatedProfile = profile;
  }
}
