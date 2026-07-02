import 'package:admin/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shopper tasks lists requests with a create quote action', (
    tester,
  ) async {
    await tester.pumpWidget(const AdminApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('workspace-switcher-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Shopper'));
    await tester.pumpAndSettle();

    expect(find.text('Shopper Tasks'), findsOneWidget);
    expect(
      find.text('Manage pending requests and active orders.'),
      findsOneWidget,
    );
    expect(find.text('Create Quote'), findsWidgets);
  });
}
