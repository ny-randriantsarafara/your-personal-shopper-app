import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/app.dart';

void main() {
  testWidgets('admin app renders its foundation shell', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AdminApp()));

    expect(find.text('Admin app foundation'), findsOneWidget);
  });
}
