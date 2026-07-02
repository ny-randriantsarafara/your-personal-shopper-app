import 'package:admin/shared/widgets/status_badge.dart';
import 'package:admin/shared/widgets/tracking_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('hides progress for submitted status', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: TrackingProgress(status: OrderStatus.submitted)),
      ),
    );

    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('shows purchased progress copy', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: TrackingProgress(status: OrderStatus.purchased)),
      ),
    );

    expect(find.textContaining('Item purchased'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });
}
