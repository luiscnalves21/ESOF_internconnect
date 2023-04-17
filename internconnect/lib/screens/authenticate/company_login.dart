import 'package:flutter/material.dart';
import 'package:internconnect/shared/constants.dart';

import '../../services/auth.dart';
import '../../shared/loading.dart';

class CompanyLogin extends StatefulWidget {
  final Function toggleView;
  const CompanyLogin({super.key, required this.toggleView});

  @override
  State<CompanyLogin> createState() => _CompanyLoginState();
}

class _CompanyLoginState extends State<CompanyLogin> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

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
                        'LOGIN',
                        style: TextStyle(
                            fontSize: 60.0,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 150.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter your email' : null,
                              decoration: inputDecoration('Company Email'),
                              onChanged: (val) {
                                setState(() => email = val);
                              },
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              validator: (value) => value!.length < 6
                                  ? 'Enter a password 6+ chars long'
                                  : null,
                              decoration: inputDecoration('Password'),
                              obscureText: true,
                              onChanged: (val) {
                                setState(() => password = val);
                              },
                            ),
                            const SizedBox(height: 20.0),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => loading = true);
                                  dynamic result =
                                      await _auth.signInWithEmailAndPassword(
                                          email, password);
                                  if (result == null) {
                                    setState(() {
                                      error = 'Email or password is incorrect';
                                      loading = false;
                                    });
                                  }
                                }
                              },
                              child: const Text('Login'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(150, 35),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () {
                          widget.toggleView(false, false);
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: 'Don\'t have an account? ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Sign up now!',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () {
                          widget.toggleView(true, true);
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: 'Are you an student? ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Click here!',
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
