import 'package:flutter/material.dart';

import '../../../domain/entities/user_profile.dart';
import '../view_model/profile_view_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({required this.viewModel, super.key});

  final ProfileViewModel viewModel;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onStateChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.viewModel.loadProfile();
      }
    });
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onStateChanged);
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    final profile = widget.viewModel.state.profile;
    if (!_isEditing && profile != null) {
      _populateControllers(profile);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _populateControllers(UserProfile profile) {
    _fullNameController.text = profile.fullName;
    _emailController.text = profile.email;
    _phoneNumberController.text = profile.phoneNumber;
  }

  void _startEditing(UserProfile profile) {
    _populateControllers(profile);
    setState(() => _isEditing = true);
  }

  void _cancelEditing(UserProfile profile) {
    _populateControllers(profile);
    setState(() => _isEditing = false);
  }

  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final saved = await widget.viewModel.updateProfile(
      UserProfile(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
      ),
    );

    if (!mounted) {
      return;
    }

    if (saved) {
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.viewModel.state.errorMessage ?? 'Unable to save your profile.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.viewModel.state;
    final profile = state.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (profile != null && !state.isSaving)
            TextButton(
              onPressed: _isEditing
                  ? () => _cancelEditing(profile)
                  : () => _startEditing(profile),
              child: Text(_isEditing ? 'Cancel' : 'Edit'),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: switch (state.status) {
          ProfileStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          ProfileStatus.failure when profile == null => _ProfileErrorView(
              message: state.errorMessage ?? 'Unable to load your profile.',
              onRetry: widget.viewModel.loadProfile,
            ),
          ProfileStatus.success ||
          ProfileStatus.saving ||
          ProfileStatus.failure =>
            _ProfileContent(
              profile: profile!,
              isEditing: _isEditing,
              errorMessage: state.status == ProfileStatus.failure
                  ? state.errorMessage
                  : null,
              formKey: _formKey,
              fullNameController: _fullNameController,
              emailController: _emailController,
              phoneNumberController: _phoneNumberController,
            ),
        },
      ),
      bottomNavigationBar: profile == null || !_isEditing
          ? null
          : SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: state.isSaving ? null : _saveProfile,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    child: state.isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save changes'),
                  ),
                ),
              ),
            ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.profile,
    required this.isEditing,
    required this.errorMessage,
    required this.formKey,
    required this.fullNameController,
    required this.emailController,
    required this.phoneNumberController,
  });

  final UserProfile profile;
  final bool isEditing;
  final String? errorMessage;
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneNumberController;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 112),
      children: [
        _ProfileHeader(profile: profile),
        const SizedBox(height: 28),
        if (errorMessage != null) ...[
          _ProfileMessage(message: errorMessage!),
          const SizedBox(height: 16),
        ],
        Text(
          isEditing ? 'Edit details' : 'Account details',
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        if (isEditing)
          Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: fullNameController,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  decoration: const InputDecoration(
                    labelText: 'Full name',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: _emailValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: _phoneNumberValidator,
                ),
              ],
            ),
          )
        else
          _ProfileDetails(profile: profile),
      ],
    );
  }

  String? _requiredValidator(String? value) {
    return value == null || value.trim().isEmpty
        ? 'This field is required.'
        : null;
  }

  String? _emailValidator(String? value) {
    final normalizedValue = value?.trim() ?? '';
    if (normalizedValue.isEmpty) {
      return 'This field is required.';
    }

    return normalizedValue.contains('@') ? null : 'Enter a valid email.';
  }

  String? _phoneNumberValidator(String? value) {
    final normalizedValue = value?.trim() ?? '';
    if (normalizedValue.isEmpty) {
      return 'This field is required.';
    }

    return normalizedValue.length < 8 ? 'Enter a valid phone number.' : null;
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final trimmedName = profile.fullName.trim();
    final initial = trimmedName.isEmpty ? '?' : trimmedName[0].toUpperCase();

    return Row(
      children: [
        CircleAvatar(
          radius: 34,
          backgroundColor: const Color(0xFF5C4BFF),
          child: Text(
            initial,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.fullName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                profile.email,
                style: const TextStyle(color: Color(0xFF777285)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileDetails extends StatelessWidget {
  const _ProfileDetails({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _ProfileDetailRow(
            icon: Icons.person_outline_rounded,
            label: 'Full name',
            value: profile.fullName,
          ),
          const Divider(height: 1),
          _ProfileDetailRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: profile.email,
          ),
          const Divider(height: 1),
          _ProfileDetailRow(
            icon: Icons.phone_outlined,
            label: 'Phone number',
            value: profile.phoneNumber,
          ),
        ],
      ),
    );
  }
}

class _ProfileDetailRow extends StatelessWidget {
  const _ProfileDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF5C4BFF)),
      title: Text(label),
      subtitle: Text(value),
    );
  }
}

class _ProfileMessage extends StatelessWidget {
  const _ProfileMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFE8ED),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Color(0xFFB4233C)),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}

class _ProfileErrorView extends StatelessWidget {
  const _ProfileErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 54,
              color: Color(0xFF938FA1),
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
