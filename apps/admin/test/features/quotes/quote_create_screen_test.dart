import 'package:admin/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('quote creation generates a quote and marks it ready', (
    tester,
  ) async {
    await tester.pumpWidget(const AdminApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('workspace-switcher-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Shopper'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create Quote').first);
    await tester.pumpAndSettle();

    expect(find.text('Calculate Quote'), findsOneWidget);
    expect(find.text('Request Details'), findsOneWidget);
    expect(find.text('Product Amount'), findsOneWidget);
    expect(find.text('Exchange Rate'), findsOneWidget);
    expect(find.text('Service Fee'), findsOneWidget);
    expect(find.text('Local Delivery'), findsOneWidget);
    expect(find.text('Generate & Send Quote'), findsOneWidget);

    await tester.enterText(find.bySemanticsLabel('Product Amount'), '100');
    await tester.ensureVisible(find.text('Generate & Send Quote'));
    await tester.tap(find.text('Generate & Send Quote'));
    await tester.pumpAndSettle();

    expect(find.text('Calculate Quote'), findsNothing);
    expect(find.text('Quote Ready'), findsWidgets);
  });
}
