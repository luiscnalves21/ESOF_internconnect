import 'package:flutter/material.dart';
import 'package:internconnect/models/student.dart';
import 'package:provider/provider.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  @override
  Widget build(BuildContext context) {
    final students = Provider.of<List<Student>?>(context);

    return ListView.builder(
        itemCount: students?.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(students?[index].name ?? ''),
              subtitle: Text(students?[index].email ?? ''),
            ),
          );
        },
    );
  }
}
