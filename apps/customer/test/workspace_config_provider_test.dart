import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:customer/core/config/workspace_config_provider.dart';

void main() {
  test('workspace config provider exposes fallback runtime config', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final config = container.read(workspaceConfigProvider);

    expect(config.publicName, 'Personal Shopper');
    expect(config.defaultLanguage, 'fr');
  });
}
