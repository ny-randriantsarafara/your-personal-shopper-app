import 'package:customer/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('new request screen submits a request and returns to orders', (
    tester,
  ) async {
    await tester.pumpWidget(const CustomerApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('New Request'));
    await tester.pumpAndSettle();

    expect(find.text('What would you like to buy?'), findsOneWidget);

    await tester.enterText(
      find.bySemanticsLabel('Product Name'),
      'Demo Product',
    );
    await tester.enterText(
      find.bySemanticsLabel('Product Link (URL)'),
      'https://example.com/demo',
    );
    await tester.ensureVisible(find.text('Submit Request'));
    await tester.tap(find.text('Submit Request'));
    await tester.pumpAndSettle();

    expect(find.text('What would you like to buy?'), findsNothing);
    expect(find.text('Demo Product'), findsOneWidget);
  });
}
