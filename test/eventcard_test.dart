
import 'package:eventmanagement/screens/eventcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EventCard Widget Tests', () {
    testWidgets('renders all required fields correctly', (WidgetTester tester) async {
      // Arrange
      const testTitle = "Test Event";
      const testDate = "2025-09-20";
      const testLocation = "Mianwali";
      const testAttendees = 25;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EventCard(
              title: testTitle,
              date: testDate,
              eventlocation: testLocation,
              attendeescount: testAttendees,
              onTap: () {}, // ✅ dummy callback
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testDate), findsOneWidget);
      expect(find.text(testLocation), findsOneWidget);
      expect(find.text('$testAttendees attending'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      // Arrange
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EventCard(
              title: "Clickable Event",
              date: "2025-09-20",
              eventlocation: "Islamabad",
              attendeescount: 10,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(EventCard));
      await tester.pumpAndSettle();

      // Assert
      expect(tapped, true);
    });

    testWidgets('displays fallback widget if image fails to load', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EventCard(
              title: "Image Test",
              date: "2025-09-20",
              eventlocation: "Lahore",
              attendeescount: 5,
              onTap: () {}, // ✅ dummy callback
            ),
          ),
        ),
      );

      // Act – force errorBuilder by triggering a rebuild
      await tester.pump();

      // Assert – check placeholder widget exists
      expect(find.byIcon(Icons.broken_image), findsOneWidget);
    });
  });
}
