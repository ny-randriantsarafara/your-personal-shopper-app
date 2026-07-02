import 'package:admin/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('account settings shows nav and switches to mobile money', (
    tester,
  ) async {
    await tester.pumpWidget(const AdminApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('workspace-switcher-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Account Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings that stay out of your way.'), findsOneWidget);
    expect(find.text('Profile'), findsWidgets);
    expect(find.text('Security'), findsOneWidget);
    expect(find.text('Mobile Money'), findsWidgets);
    expect(find.text('Addresses'), findsOneWidget);

    await tester.tap(find.text('Mobile Money'));
    await tester.pumpAndSettle();

    expect(find.text('MVola'), findsOneWidget);
    expect(find.text('Orange Money'), findsOneWidget);
    expect(find.text('Airtel Money'), findsOneWidget);
  });
}
