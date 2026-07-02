import 'package:admin/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('admin app renders the neutral brand in its header', (
    tester,
  ) async {
    await tester.pumpWidget(const AdminApp());
    await tester.pumpAndSettle();

    expect(find.text('Personal Shopper Admin'), findsOneWidget);
  });
}
