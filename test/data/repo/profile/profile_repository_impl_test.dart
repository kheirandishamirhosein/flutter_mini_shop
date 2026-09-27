import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/data/local/in_memory_profile_local_data_source.dart';
import 'package:mini_shop/data/repo/profile/profile_repository_impl.dart';
import 'package:mini_shop/domain/entities/user_profile.dart';

void main() {
  test('exposes local profile actions through the domain repository', () async {
    final repository = ProfileRepositoryImpl(
      InMemoryProfileLocalDataSource(),
    );
    const updatedProfile = UserProfile(
      fullName: 'Updated user',
      email: 'updated@example.com',
      phoneNumber: '09120000000',
    );

    await repository.updateProfile(updatedProfile);

    expect(await repository.getProfile(), same(updatedProfile));
  });
}
