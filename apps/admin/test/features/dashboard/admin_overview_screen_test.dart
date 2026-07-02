import 'package:admin/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('admin overview shows metrics and platform requests', (
    tester,
  ) async {
    await tester.pumpWidget(const AdminApp());
    await tester.pumpAndSettle();

    expect(find.text('Admin Overview'), findsOneWidget);
    expect(find.text('Platform metrics and global requests.'), findsOneWidget);
    expect(find.text('Total Requests'), findsOneWidget);
    // Present as a metric label and as a delivered request's status badge.
    expect(find.text('Delivered'), findsWidgets);
    expect(find.text('Active Users'), findsOneWidget);
    expect(find.text('All Platform Requests'), findsOneWidget);
  });
}
