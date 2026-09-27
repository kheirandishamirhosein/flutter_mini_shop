import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/domain/entities/user_profile.dart';
import 'package:mini_shop/domain/profile/usecases/get_user_profile_use_case.dart';
import 'package:mini_shop/domain/profile/usecases/update_user_profile_use_case.dart';
import 'package:mini_shop/domain/repo/profile_repository.dart';
import 'package:mini_shop/presentation/profile/view_model/profile_view_model.dart';

void main() {
  test('loads the profile into a successful state', () async {
    final viewModel = _createViewModel(_FakeProfileRepository());

    await viewModel.loadProfile();

    expect(viewModel.state.status, ProfileStatus.success);
    expect(viewModel.state.profile?.fullName, 'Amirhosein Sharifi');
  });

  test('saves profile edits and exposes the updated value', () async {
    final repository = _FakeProfileRepository();
    final viewModel = _createViewModel(repository);
    const profile = UserProfile(
      fullName: 'Updated user',
      email: 'updated@example.com',
      phoneNumber: '09120000000',
    );

    final saved = await viewModel.updateProfile(profile);

    expect(saved, isTrue);
    expect(repository.updatedProfile, same(profile));
    expect(viewModel.state.status, ProfileStatus.success);
    expect(viewModel.state.profile, same(profile));
  });

  test('exposes a failure state when updating the profile fails', () async {
    final viewModel = _createViewModel(
      _FakeProfileRepository(shouldFailToUpdate: true),
    );

    final saved = await viewModel.updateProfile(_profile);

    expect(saved, isFalse);
    expect(viewModel.state.status, ProfileStatus.failure);
    expect(viewModel.state.errorMessage, isNotEmpty);
  });
}

ProfileViewModel _createViewModel(_FakeProfileRepository repository) {
  return ProfileViewModel(
    GetUserProfileUseCase(repository),
    UpdateUserProfileUseCase(repository),
  );
}

class _FakeProfileRepository implements ProfileRepository {
  _FakeProfileRepository({this.shouldFailToUpdate = false});

  final bool shouldFailToUpdate;
  UserProfile? updatedProfile;

  @override
  Future<UserProfile> getProfile() async => _profile;

  @override
  Future<void> updateProfile(UserProfile profile) async {
    if (shouldFailToUpdate) {
      throw Exception('Mock update failure');
    }

    updatedProfile = profile;
  }
}

const _profile = UserProfile(
  fullName: 'Amirhosein Sharifi',
  email: 'amir@example.com',
  phoneNumber: '09120000000',
);
