import 'package:flutter/material.dart';
import 'package:internconnect/main.dart';
import 'package:internconnect/services/auth.dart';
import 'package:internconnect/shared/constants.dart';

import '../../shared/loading.dart';

class StudentSignup extends StatefulWidget {
  final Function toggleView;
  const StudentSignup({super.key, required this.toggleView});

  @override
  State<StudentSignup> createState() => _StudentSignupState();
}

class _StudentSignupState extends State<StudentSignup> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String name = "";
  String email = "";
  String password = "";
  String error = "";

  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'SIGN UP',
                        style: TextStyle(
                            fontSize: 60.0,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 90.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.name,
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter your name' : null,
                              decoration: inputDecoration('Name'),
                              onChanged: (val) => setState(() => name = val),
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter your email' : null,
                              decoration: inputDecoration('Email'),
                              onChanged: (val) => setState(() => email = val),
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              validator: (value) => value!.length < 6
                                  ? 'Enter a password 6+ chars long'
                                  : null,
                              decoration: inputDecoration('Password'),
                              obscureText: true,
                              onChanged: (val) =>
                                  setState(() => password = val),
                            ),
                            const SizedBox(height: 40.0),
                            ElevatedButton(
                              child: const Text('Sign Up'),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => loading = true);
                                  dynamic result =
                                      await _auth.registerWithEmailAndPassword(
                                          name.trim(), email, password, 'user');
                                  if (result == null) {
                                    setState(() {
                                      error =
                                          'Please supply a valid email or\nthis email is already being used';
                                      loading = false;
                                    });
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () {
                          widget.toggleView(true, true);
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Login now!',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Text(
                        textAlign: TextAlign.center,
                        error,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
