import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/data/local/in_memory_profile_local_data_source.dart';
import 'package:mini_shop/domain/entities/user_profile.dart';

void main() {
  test('returns the updated profile after an edit', () async {
    final dataSource = InMemoryProfileLocalDataSource();
    const updatedProfile = UserProfile(
      fullName: 'Updated user',
      email: 'updated@example.com',
      phoneNumber: '09120000000',
    );

    await dataSource.updateProfile(updatedProfile);

    expect(await dataSource.getProfile(), same(updatedProfile));
  });
}
