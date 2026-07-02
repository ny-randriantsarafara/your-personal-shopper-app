import 'package:admin/shared/motion/page_transition.dart';
import 'package:admin/shared/motion/staggered_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PageFadeSlideTransition reveals its child after settling', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PageFadeSlideTransition(child: Text('Page content')),
        ),
      ),
    );

    expect(find.text('Page content'), findsOneWidget);

    await tester.pumpAndSettle();

    final opacity = tester.widget<FadeTransition>(
      find
          .descendant(
            of: find.byType(PageFadeSlideTransition),
            matching: find.byType(FadeTransition),
          )
          .first,
    );
    expect(opacity.opacity.value, 1.0);
  });

  testWidgets('StaggeredEntry reveals its child after settling', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StaggeredEntry(index: 2, child: Text('Card content')),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Card content'), findsOneWidget);
    final opacity = tester.widget<FadeTransition>(
      find
          .descendant(
            of: find.byType(StaggeredEntry),
            matching: find.byType(FadeTransition),
          )
          .first,
    );
    expect(opacity.opacity.value, 1.0);
  });
}
