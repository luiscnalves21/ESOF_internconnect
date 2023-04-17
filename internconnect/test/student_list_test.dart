import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internconnect/screens/home/student_list.dart';
import 'package:internconnect/models/student.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('StudentList renders the correct number of student cards and content', (WidgetTester tester) async {
    final students = [
      Student(name: 'John Doe', email: 'john@example.com'),
      Student(name: 'Jane Smith', email: 'jane@example.com'),
    ];

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

    expect(find.byType(Card), findsNWidgets(students.length));

    for (var student in students) {
      expect(find.text(student.name ?? ''), findsOneWidget);
      expect(find.text(student.email ?? ''), findsOneWidget);
    }
  });
}
