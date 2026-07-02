import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'workspace.dart';

final selectedWorkspaceProvider = Provider<Workspace>((ref) {
  return const Workspace(
    id: 'demo-workspace-id',
    slug: 'demo-workspace',
    publicName: 'Demo Workspace',
  );
});
