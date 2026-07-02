import 'package:customer/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('payment screen lists mobile money methods and authorize action', (
    tester,
  ) async {
    await tester.pumpWidget(const CustomerApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Review & Pay'));
    await tester.tap(find.text('Review & Pay'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Accept & Pay'));
    await tester.tap(find.text('Accept & Pay'));
    await tester.pumpAndSettle();

    expect(find.text('Complete Payment'), findsOneWidget);
    expect(find.text('MVola'), findsOneWidget);
    expect(find.text('Orange Money'), findsOneWidget);
    expect(find.text('Airtel Money'), findsOneWidget);
    expect(find.text('Authorize Payment'), findsOneWidget);
  });
}
