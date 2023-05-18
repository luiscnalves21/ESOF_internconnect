import 'package:firebase_auth/firebase_auth.dart';
import 'package:internconnect/models/firebase_user.dart';
import 'package:internconnect/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on FirebaseUser
  FirebaseUser _userFromFirebaseUser(User? user) {
    return user != null ? FirebaseUser(uid: user.uid) : FirebaseUser(uid: '');
  }

  // auth change user stream
  Stream<FirebaseUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await FirebaseAuth.instance.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(
      String name, String email, String password, String type) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      await DatabaseService(uid: user!.uid).updateUserData(name, email, type);

      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
