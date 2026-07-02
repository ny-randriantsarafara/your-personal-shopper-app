import 'package:customer/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(const CustomerApp());
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('customer orders dashboard - mobile', (tester) async {
    await _pumpAt(tester, const Size(390, 844));

    await expectLater(
      find.byType(CustomerApp),
      matchesGoldenFile('customer_orders_dashboard_mobile.png'),
    );
  });

  testWidgets('customer orders dashboard - tablet', (tester) async {
    await _pumpAt(tester, const Size(900, 900));

    await expectLater(
      find.byType(CustomerApp),
      matchesGoldenFile('customer_orders_dashboard_tablet.png'),
    );
  });
}
