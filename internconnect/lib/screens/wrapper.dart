import 'package:flutter/material.dart';
import 'package:internconnect/screens/home/home.dart';
import 'package:internconnect/screens/home/internships.dart';

class Wrappper extends StatelessWidget {
  const Wrappper({super.key});

  @override
  Widget build(BuildContext context) {
    // return either Home or Authenticate Widget

    return Home();
  }
}
