import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internconnect/screens/home/student_list.dart';
import 'package:internconnect/models/student.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('StudentList renders the correct number of student cards and content', (WidgetTester tester) async {
    // Create a list of students
    final students = [
      Student(name: 'John Doe', email: 'john@example.com'),
      Student(name: 'Jane Smith', email: 'jane@example.com'),
    ];

    // Build the StudentList widget with a Provider for the students list
    await tester.pumpWidget(
      Provider<List<Student>>(
        create: (context) => students,
        child: MaterialApp(
          home: Scaffold(
            body: const StudentList(),
          ),
        ),
      ),
    );

    // Verify that the correct number of student cards are rendered
    expect(find.byType(Card), findsNWidgets(students.length));

    // Verify that each card contains the correct content
    for (var student in students) {
      expect(find.text(student.name ?? ''), findsOneWidget);
      expect(find.text(student.email ?? ''), findsOneWidget);
    }
  });
}
