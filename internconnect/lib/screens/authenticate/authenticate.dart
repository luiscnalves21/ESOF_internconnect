import 'package:flutter/material.dart';
import 'package:internconnect/screens/authenticate/company_login.dart';
import 'package:internconnect/screens/authenticate/company_signup.dart';
import 'package:internconnect/screens/authenticate/student_login.dart';
import 'package:internconnect/screens/authenticate/student_signup.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool _showSignIn = true;
  bool _showUser = true;

  void toggleView(bool showUser, bool showSignIn) {
    setState(() => _showUser = showUser);
    setState(() => _showSignIn = showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (_showUser) {
      if (_showSignIn) {
        return StudentLogin(toggleView: toggleView);
      } else {
        return StudentSignup(toggleView: toggleView);
      }
    } else {
      if (_showSignIn) {
        return CompanyLogin(toggleView: toggleView);
      } else {
        return CompanySignup(toggleView: toggleView);
      }
    }
  }
}
