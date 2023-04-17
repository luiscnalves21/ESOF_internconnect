import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internconnect/screens/home/available_internships.dart';

void main() {
  testWidgets('Test AvailableInternships widget', (WidgetTester tester) async {
    // Build the AvailableInternships widget.
    await tester.pumpWidget(MaterialApp(home: const AvailableInternships()));

    // Verify that the app bar is displayed with the correct title.
    expect(find.text('Available Internships'), findsOneWidget);

    // Verify that the back button is displayed.
    expect(find.byIcon(Icons.arrow_back_ios_new_outlined), findsOneWidget);

    // Verify that the company name container is displayed.
    expect(find.text('Name of company'), findsOneWidget);

    // Verify that the "Next" button is displayed.
    expect(find.text('Next'), findsOneWidget);

    // Verify that the "Previous" button is displayed.
    expect(find.text('Previous'), findsOneWidget);
  });
}
