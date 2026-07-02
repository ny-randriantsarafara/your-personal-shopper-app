import 'package:customer/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('customer app starts on orders dashboard', (tester) async {
    await tester.pumpWidget(const CustomerApp());
    await tester.pumpAndSettle();

    expect(find.text('Your Orders'), findsOneWidget);
    expect(find.text('New Request'), findsOneWidget);
  });
}
