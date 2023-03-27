import 'package:flutter/material.dart';
import 'package:internconnect/services/auth.dart';

class StudentSignup extends StatefulWidget {
  const StudentSignup({super.key});

  @override
  State<StudentSignup> createState() => _StudentSignupState();
}

class _StudentSignupState extends State<StudentSignup> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String name = "";
  String email = "";
  String password = "";
  String error = "";

  Widget build(BuildContext context) {
    return Scaffold(
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
                        decoration: const InputDecoration(
                          labelText: 'Name',
                        ),
                        onChanged: (val) {
                          setState(() {
                            name = val;
                          });
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter your email' : null,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        validator: (value) => value!.length < 6
                            ? 'Enter a password 6+ chars long'
                            : null,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      const SizedBox(height: 40.0),
                      ElevatedButton(
                        child: const Text('Sign Up'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            dynamic result =
                                await _auth.registerWithEmailAndPassword(
                                    name, email, password);
                            if (result == null) {
                              setState(() {
                                error = 'Please supply a valid email';
                              });
                            } else {
                              Navigator.pop(context);
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
                    Navigator.pop(context);
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
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
                SizedBox(height: 30.0),
                Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 14.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
