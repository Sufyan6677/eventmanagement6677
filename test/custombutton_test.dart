import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventmanagement/widgets/custombutton.dart';

void main() {
  testWidgets('CustomTextButton displays text and responds to tap', (WidgetTester tester) async {
    bool pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomTextButton(
            textSize: 16,
            backgroundColor: Colors.blue,
            borderColor: Colors.black,
            text: "Click Me",
            borderRadiusCircular: 8,
            onPressed: () {
              pressed = true;
            },
          ),
        ),
      ),
    );

    // Check if text is displayed
    expect(find.text("Click Me"), findsOneWidget);

    // Tap the button
    await tester.tap(find.byType(CustomTextButton));
    await tester.pump(); // Rebuild after tap

    // Check if callback was triggered
    expect(pressed, true);
  });

  testWidgets('CustomTextButton shows icon when isIcon = true', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomTextButton(
            textSize: 16,
            backgroundColor: Colors.green,
            borderColor: Colors.black,
            text: "Ignored",
            isIcon: true,
            icon: Icons.add,
            borderRadiusCircular: 8,
            onPressed: () {},
          ),
        ),
      ),
    );

    // Check if Icon is rendered
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
