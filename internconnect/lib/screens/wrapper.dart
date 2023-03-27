import 'package:flutter/material.dart';
import 'package:internconnect/models/firebase_user.dart';
import 'package:internconnect/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser?>(context);
    print(user);

    // return either Home or Authenticate Widget
    return Authenticate();
  }
}
