import 'package:customer/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('orders dashboard separates quote actions from active orders', (
    tester,
  ) async {
    await tester.pumpWidget(const CustomerApp());
    await tester.pumpAndSettle();

    expect(find.text('Your Orders'), findsOneWidget);
    expect(find.text('Needs Your Attention'), findsOneWidget);
    expect(find.text('Active & Past Orders'), findsOneWidget);
    expect(find.text('Review & Pay'), findsOneWidget);
  });
}
