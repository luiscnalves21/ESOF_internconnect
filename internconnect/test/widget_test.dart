import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internconnect/screens/authenticate/student_login.dart';
import 'package:internconnect/screens/home/home.dart';
import 'package:internconnect/screens/home/available_internships.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  testWidgets('Home widget renders properly', (WidgetTester tester) async {
    //await tester.pumpWidget(MaterialApp(home: Home()));
    //expect(find.byType(Home), findsOneWidget);
    //expect(find.byType(AppBar), findsOneWidget);
    //expect(find.text('Home'), findsOneWidget);
    //expect(find.byType(IconButton), findsNWidgets(2));
    //expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('AvailableInternships widget renders properly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AvailableInternships()));
    expect(find.byType(AvailableInternships), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Available Internships'), findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(OutlinedButton), findsOneWidget);
  });
/*
  testWidgets('Button click navigates to another page',
      (WidgetTester tester) async {
    // Build your main app widget
    final Function toggleView;
    toggleView = () {};
    await tester.pumpWidget(StudentLogin(
      toggleView: toggleView,
    ));

    // Find the button by its key (assuming you've set a key for the button)
    final button = find.text('Continue as Guest');

    // Tap the button to trigger the click event
    await tester.tap(button);
    await tester.pumpAndSettle(); // Wait for animations to complete

    // Expect that the app navigates to the SecondPage
    expect(find.text('Home'), findsOneWidget);
  });*/
}
