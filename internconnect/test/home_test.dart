import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internconnect/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:internconnect/models/student.dart';
import 'package:internconnect/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart'; // Add this import statement

void main() {
  setUpAll(() async {
    // Initialize Firebase before running the test.
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets('Test Home widget', (WidgetTester tester) async {
    // Create a mock stream of students
    final studentStream = Stream<List<Student>>.value([
      Student(name: 'John Doe', email: 'john@example.com'),
      Student(name: 'Jane Smith', email: 'jane@example.com'),
    ]);

    // Build the Home widget with a mock stream of students and a mock AuthService.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          StreamProvider<List<Student>?>.value(
            value: studentStream,
            initialData: null,
          ),
          Provider<AuthService>.value(value: AuthService()),
        ],
        child: MaterialApp(home: const Home()),
      ),
    );

    // Verify that the app bar is displayed with the correct title.
    expect(find.text('Home'), findsOneWidget);

    // Verify that the logout button is displayed.
    expect(find.byIcon(Icons.logout), findsOneWidget);

    // Verify that the students are displayed in the list.
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('jane@example.com'), findsOneWidget);

    // Verify that the "Available Internships" button is displayed.
    expect(find.text('Available Internships'), findsOneWidget);

    // Verify that the bottom navigation bar is displayed.
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
