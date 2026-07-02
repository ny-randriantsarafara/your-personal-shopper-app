import 'package:admin/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('admin app starts on overview and exposes workspace switcher', (
    tester,
  ) async {
    await tester.pumpWidget(const AdminApp());
    await tester.pumpAndSettle();

    expect(find.text('Admin Overview'), findsOneWidget);

    await tester.tap(find.byKey(const Key('workspace-switcher-button')));
    await tester.pumpAndSettle();

    expect(find.text('Shopper'), findsOneWidget);
    expect(find.text('Logistics Hub'), findsOneWidget);
    // Present as the current-workspace chip in the header and as a switcher row.
    expect(find.text('Admin Console'), findsWidgets);
    expect(find.text('Account Settings'), findsOneWidget);
  });
}
