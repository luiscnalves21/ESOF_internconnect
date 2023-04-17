import 'package:flutter/material.dart';
import 'package:internconnect/services/auth.dart';
import 'available_internships.dart';
import 'package:internconnect/services/database.dart';
import 'package:provider/provider.dart';
import 'package:internconnect/screens/home/student_list.dart';
import 'package:internconnect/models/student.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();
  int currPage = 0;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Student>?>.value(
      value: DatabaseService().students,
      initialData: null,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(child: StudentList()),
            Container(
              margin: EdgeInsets.only(bottom: 200),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const AvailableInternships();
                    }),
                  );
                },
                child: const Text('Available Internships')),
            ),
          ]
        ),
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          ],
          onDestinationSelected: (int index) {
            setState(() {
              currPage = index;
            });
          },
          selectedIndex: currPage,
        ),
      ),
    );
  }
}
