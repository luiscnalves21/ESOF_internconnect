import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/users.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  List<String> _softSkills = [];
  List<String> _certificates = [];

  Future updateUserData(String name, String email, String type) async {
    return await userCollection.doc(uid).set({
      'type': type,
      'name': name,
      'email': email,
      'softSkills': _softSkills,
      'certificates': _certificates,
    });
  }

  Future updateUserName(String name) async {
    return await userCollection.doc(uid).update({
      'name': name,
    });
  }

  Future updateUserSoftSkills(List<String> softSkills) async {
    _softSkills = softSkills;
    return await userCollection.doc(uid).update({
      'softSkills': _softSkills,
    });
  }

  Future updateUserCertificates(List<String> certificates) async {
    _certificates = certificates;
    return await userCollection.doc(uid).update({
      'certificates': _certificates,
    });
  }


  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid!,
      type: snapshot['type'],
      name: snapshot['name'],
      email: snapshot['email'],
      softSkills: List<String>.from(snapshot['softSkills']),
      certificates: List<String>.from(snapshot['certificates']),
    );
  }

  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
