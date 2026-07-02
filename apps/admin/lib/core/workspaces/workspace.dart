class Workspace {
  const Workspace({
    required this.id,
    required this.slug,
    required this.publicName,
  });

  final String id;
  final String slug;
  final String publicName;
}

/// Neutral demo identity shown in the admin shell header and account settings.
/// No source-specific person names are used.
class AdminUserProfile {
  const AdminUserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  String get fullName => '$firstName $lastName';

  String get initials {
    final first = firstName.isNotEmpty ? firstName[0] : '';
    final last = lastName.isNotEmpty ? lastName[0] : '';
    return '$first$last';
  }
}
