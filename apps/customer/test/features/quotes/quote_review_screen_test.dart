import 'package:customer/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('quote review shows the breakdown and pay actions', (
    tester,
  ) async {
    await tester.pumpWidget(const CustomerApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Review & Pay'));
    await tester.tap(find.text('Review & Pay'));
    await tester.pumpAndSettle();

    expect(find.text('Quote Details'), findsOneWidget);
    expect(find.text('Total to Pay'), findsOneWidget);
    expect(find.text('Accept & Pay'), findsOneWidget);
    expect(find.text('Decline'), findsOneWidget);
  });
}
