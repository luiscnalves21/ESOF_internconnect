import 'package:flutter/material.dart';
import 'package:internconnect/services/auth.dart';
import 'package:internconnect/screens/home/home.dart';

class StudentSignup extends StatefulWidget {
  const StudentSignup({super.key});

  @override
  State<StudentSignup> createState() => _StudentSignupState();
}

class _StudentSignupState extends State<StudentSignup> {

  final AuthService _auth = AuthService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signup() {
    dynamic result = _auth.registerWithEmailAndPassword(
        _emailController.text, _passwordController.text);
    if (result == null) {
      print('error signing in');
    } else {
      print('signed in');
      print(result.uid);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    }
  }

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
                const SizedBox(height: 70.0),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    prefixText: '+',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 40.0),
                ElevatedButton(
                  child: const Text('SIGN UP'),
                  onPressed: (_signup),
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
                        color: Colors.black, 
                        fontWeight: FontWeight.bold
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Login now!',
                          style: TextStyle(
                            color: Colors.red, 
                            fontWeight: FontWeight.bold, 
                            decoration: TextDecoration.underline
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
