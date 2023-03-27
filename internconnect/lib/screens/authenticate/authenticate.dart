import 'package:flutter/material.dart';
import 'package:internconnect/screens/authenticate/student_login.dart';
import 'package:internconnect/screens/authenticate/student_signup.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
      return StudentLogin();
  }
}
