import 'package:admin/shared/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders quote available status label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: StatusBadge(status: OrderStatus.quoteAvailable)),
      ),
    );

    expect(find.text('Quote Ready'), findsOneWidget);
  });
}
