import 'package:fct_frontend/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoadingWidget Tests', () {
    testWidgets('should render loading indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should render with custom message',
        (WidgetTester tester) async {
      const message = 'Cargando datos...';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(message: message),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(message), findsOneWidget);
    });

    testWidgets('should render without message when not provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('should render with custom size', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(size: LoadingSize.large),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.byType(SizedBox).first,
      );

      expect(sizedBox.width, 60.0);
      expect(sizedBox.height, 60.0);
    });
  });
}
