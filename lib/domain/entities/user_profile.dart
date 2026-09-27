/// The user's editable account information.
class UserProfile {
  const UserProfile({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  final String fullName;
  final String email;
  final String phoneNumber;

  UserProfile copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
