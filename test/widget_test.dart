import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assignmentbit31/main.dart'; // Ensure this is the correct import path

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // ✅ FIX: Use MyApp instead of TicketBookingApp
    await tester.pumpWidget(MyApp(languageCode: 'en'));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
