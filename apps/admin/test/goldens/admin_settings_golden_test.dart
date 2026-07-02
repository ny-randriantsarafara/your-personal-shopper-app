import 'package:admin/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('admin account settings - tablet', (tester) async {
    tester.view.physicalSize = const Size(1024, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AdminApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('workspace-switcher-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Account Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings that stay out of your way.'), findsOneWidget);

    await expectLater(
      find.byType(AdminApp),
      matchesGoldenFile('admin_settings_tablet.png'),
    );
  });
}
