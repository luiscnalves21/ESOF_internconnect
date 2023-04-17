import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/student.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference studentCollection =
      FirebaseFirestore.instance.collection('students');
  final CollectionReference companyCollection =
      FirebaseFirestore.instance.collection('companies');

  Future updateStudentData(String name, String email) async {
    return await studentCollection.doc(uid).set({
      'name': name,
      'email': email,
    });
  }

  Future updateCompanyData(String name, String email) async {
    return await companyCollection.doc(uid).set({
      'name': name,
      'email': email,
    });
  }

  // student list from snapshot
  List<Student> _studentListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Student(
        name: doc['name'] ?? '',
        email: doc['email'] ?? '',
      );
    }).toList();
  }

  Stream<List<Student>> get students {
    return studentCollection.snapshots().map(_studentListFromSnapshot);
  }
}
