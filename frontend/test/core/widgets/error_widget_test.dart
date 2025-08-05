import 'package:fct_frontend/core/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ErrorDisplayWidget Tests', () {
    testWidgets('should render error message', (WidgetTester tester) async {
      const message = 'Ha ocurrido un error';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorDisplayWidget(message: message),
          ),
        ),
      );

      expect(find.text(message), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should render with custom icon', (WidgetTester tester) async {
      const message = 'Error personalizado';
      const customIcon = Icons.warning;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorDisplayWidget(
              message: message,
              icon: customIcon,
            ),
          ),
        ),
      );

      expect(find.text(message), findsOneWidget);
      expect(find.byIcon(customIcon), findsOneWidget);
    });

    testWidgets('should render retry button when onRetry is provided',
        (WidgetTester tester) async {
      const message = 'Error con reintento';
      bool retryCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDisplayWidget(
              message: message,
              onRetry: () => retryCalled = true,
            ),
          ),
        ),
      );

      expect(find.text('Reintentar'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      await tester.tap(find.text('Reintentar'));
      expect(retryCalled, true);
    });

    testWidgets('should not render retry button when onRetry is not provided',
        (WidgetTester tester) async {
      const message = 'Error sin reintento';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorDisplayWidget(message: message),
          ),
        ),
      );

      expect(find.text(message), findsOneWidget);
      expect(find.text('Reintentar'), findsNothing);
      expect(find.byType(ElevatedButton), findsNothing);
    });
  });
}
