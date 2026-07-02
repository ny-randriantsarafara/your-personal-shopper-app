import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:customer/app.dart';

void main() {
  testWidgets('customer app renders its foundation shell', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CustomerApp()));

    expect(find.text('Customer app foundation'), findsOneWidget);
  });
}
