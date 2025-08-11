import 'package:fct_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FCT App Widget Tests', () {
    testWidgets('App should render without crashing',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: FCTApp(),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App should have correct title in configuration',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: FCTApp(),
        ),
      );

      // Verificamos que el título de la app esté configurado en WidgetsApp
      final widgetsApp = tester.widget<WidgetsApp>(find.byType(WidgetsApp));
      expect(widgetsApp.title, 'FCT - Gestión de Proyectos');
    });
  });
}
