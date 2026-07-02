import 'package:admin/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('admin overview - desktop', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AdminApp());
    await tester.pumpAndSettle();

    expect(find.text('Admin Overview'), findsOneWidget);

    await expectLater(
      find.byType(AdminApp),
      matchesGoldenFile('admin_overview_desktop.png'),
    );
  });
}
