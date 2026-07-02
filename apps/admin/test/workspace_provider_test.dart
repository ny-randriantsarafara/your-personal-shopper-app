import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin/core/workspaces/workspace_provider.dart';

void main() {
  test('admin has a selected workspace placeholder', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final workspace = container.read(selectedWorkspaceProvider);

    expect(workspace.slug, 'demo-workspace');
  });
}
