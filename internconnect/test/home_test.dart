import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internconnect/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:internconnect/models/users.dart';
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
    final userStream = Stream<List<User>>.value([
      User(name: 'John Doe', email: 'john@example.com'),
      User(name: 'Jane Smith', email: 'jane@example.com'),
    ]);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          StreamProvider<List<User>?>.value(
            value: userStream,
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
