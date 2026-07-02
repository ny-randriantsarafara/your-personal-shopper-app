import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'workspace.dart';

final selectedWorkspaceProvider = Provider<Workspace>((ref) {
  return const Workspace(
    id: 'demo-workspace-id',
    slug: 'demo-workspace',
    publicName: 'Demo Workspace',
  );
});

final adminUserProfileProvider = Provider<AdminUserProfile>((ref) {
  return const AdminUserProfile(
    firstName: 'Demo',
    lastName: 'Operator',
    email: 'operator@example.com',
    phone: '+261 34 00 000 00',
  );
});
