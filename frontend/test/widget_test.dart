import 'package:fct_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FCT App Widget Tests', () {
    testWidgets('App should render without crashing',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        const ProviderScope(
          child: FCTApp(),
        ),
      );

      // Verify that the app renders without crashing
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App should have correct title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: FCTApp(),
        ),
      );

      // Verify that the app has the correct title
      expect(find.text('FCT - Gestión de Proyectos'), findsOneWidget);
    });
  });
}
