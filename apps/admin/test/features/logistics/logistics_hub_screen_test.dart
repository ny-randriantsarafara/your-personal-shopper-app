import 'package:admin/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('logistics hub shows active parcels with stage actions', (
    tester,
  ) async {
    await tester.pumpWidget(const AdminApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('workspace-switcher-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Logistics Hub'));
    await tester.pumpAndSettle();

    // Present as the heading and the current-workspace chip.
    expect(find.text('Logistics Hub'), findsWidgets);
    expect(find.text('Receive Box'), findsOneWidget);
    expect(find.text('Mark Delivered'), findsOneWidget);
  });
}
