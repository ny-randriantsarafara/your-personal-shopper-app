import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'workspace_config.dart';

final workspaceConfigProvider = Provider<WorkspaceConfig>((ref) {
  return const WorkspaceConfig(
    publicName: 'Personal Shopper',
    defaultLanguage: 'fr',
    primaryColorHex: '#111113',
  );
});
