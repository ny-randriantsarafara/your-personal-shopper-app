import 'package:customer/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('customer payment screen', (tester) async {
    tester.view.physicalSize = const Size(900, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CustomerApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Review & Pay').first);
    await tester.tap(find.text('Review & Pay').first);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Accept & Pay'));
    await tester.tap(find.text('Accept & Pay'));
    await tester.pumpAndSettle();

    expect(find.text('Complete Payment'), findsOneWidget);

    await expectLater(
      find.byType(CustomerApp),
      matchesGoldenFile('customer_payment.png'),
    );
  });
}
