import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platter_catering/app/app.dart';

void main() {
  testWidgets('Platter app starts on the splash screen', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PlatterCateringApp(),
      ),
    );
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Platter'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    expect(find.text('Premium catering for modern offices'), findsOneWidget);
  });
}
