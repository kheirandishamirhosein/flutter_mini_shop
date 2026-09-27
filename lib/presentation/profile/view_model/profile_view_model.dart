import 'package:flutter/foundation.dart';

import '../../../domain/entities/user_profile.dart';
import '../../../domain/profile/usecases/get_user_profile_use_case.dart';
import '../../../domain/profile/usecases/update_user_profile_use_case.dart';

enum ProfileStatus { loading, success, saving, failure }

class ProfileState {
  const ProfileState({
    required this.status,
    this.profile,
    this.errorMessage,
  });

  const ProfileState.loading() : this(status: ProfileStatus.loading);

  final ProfileStatus status;
  final UserProfile? profile;
  final String? errorMessage;

  bool get isSaving => status == ProfileStatus.saving;
}

/// Presentation state for loading and editing the user's profile.
class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(this._getUserProfileUseCase, this._updateUserProfileUseCase);

  final GetUserProfileUseCase _getUserProfileUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  ProfileState _state = const ProfileState.loading();

  ProfileState get state => _state;

  Future<void> loadProfile() async {
    _state = const ProfileState.loading();
    notifyListeners();

    try {
      final profile = await _getUserProfileUseCase();
      _state = ProfileState(status: ProfileStatus.success, profile: profile);
    } catch (_) {
      _setFailure('Unable to load your profile. Please try again.');
    }

    notifyListeners();
  }

  Future<bool> updateProfile(UserProfile profile) async {
    if (_state.isSaving) {
      return false;
    }

    _state = ProfileState(status: ProfileStatus.saving, profile: profile);
    notifyListeners();

    try {
      await _updateUserProfileUseCase(profile);
      _state = ProfileState(status: ProfileStatus.success, profile: profile);
      notifyListeners();
      return true;
    } catch (_) {
      _setFailure('Unable to save your profile. Please try again.', profile);
      notifyListeners();
      return false;
    }
  }

  void _setFailure(String message, [UserProfile? profile]) {
    _state = ProfileState(
      status: ProfileStatus.failure,
      profile: profile,
      errorMessage: message,
    );
  }
}
