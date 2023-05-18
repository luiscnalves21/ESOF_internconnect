import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:internconnect/models/firebase_user.dart';
import 'package:internconnect/screens/wrapper.dart';
import 'package:internconnect/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:internconnect/screens/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        title: 'interNconnect',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.red),
        home: const Wrapper(),
      ),
    );
  }
}
