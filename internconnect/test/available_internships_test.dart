import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internconnect/screens/home/available_internships.dart';

void main() {
  testWidgets('Test AvailableInternships widget', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: const AvailableInternships()));
    expect(find.text('Available Internships'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios_new_outlined), findsOneWidget);
    expect(find.text('Name of company'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Previous'), findsOneWidget);
  });
}
