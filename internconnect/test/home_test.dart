import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internconnect/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:internconnect/models/student.dart';
import 'package:internconnect/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart'; // Add this import statement

// This unit test does not work at the moment //

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets('Test Home widget', (WidgetTester tester) async {
    final studentStream = Stream<List<Student>>.value([
      Student(name: 'John Doe', email: 'john@example.com'),
      Student(name: 'Jane Smith', email: 'jane@example.com'),
    ]);

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

    expect(find.text('Home'), findsOneWidget);
    expect(find.byIcon(Icons.logout), findsOneWidget);
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('jane@example.com'), findsOneWidget);
    expect(find.text('Available Internships'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
