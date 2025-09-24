import 'package:eventmanagement/widgets/textwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GoogleText Widget Tests', () {
    testWidgets('renders with default values', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GoogleText('Hello World'),
          ),
        ),
      );

      final textFinder = find.text('Hello World');
      expect(textFinder, findsOneWidget);

      final textWidget = tester.widget<Text>(textFinder);
      expect(textWidget.style?.fontSize, 16);
      expect(textWidget.style?.fontWeight, FontWeight.normal);
      expect(textWidget.style?.color, Colors.black);
    });

    testWidgets('renders with custom values', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GoogleText(
              'Custom Text',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );

      final textFinder = find.text('Custom Text');
      expect(textFinder, findsOneWidget);

      final textWidget = tester.widget<Text>(textFinder);
      expect(textWidget.style?.fontSize, 20);
      expect(textWidget.style?.fontWeight, FontWeight.bold);
      expect(textWidget.style?.color, Colors.red);
      expect(textWidget.textAlign, TextAlign.center);
    });

    testWidgets('does not render unexpected text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GoogleText('Expected Text'),
          ),
        ),
      );

      // Negative check: this text should NOT be found
      expect(find.text('Wrong Text'), findsNothing);
    });
  });
}
