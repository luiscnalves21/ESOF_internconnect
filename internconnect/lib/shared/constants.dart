import 'package:flutter/material.dart';

InputDecoration inputDecoration(String? labeltext) {
  return InputDecoration(
    labelText: labeltext,
    fillColor: Colors.white,
    filled: true,
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black12,
        width: 1.0,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
        width: 2.0,
      ),
    ),
  );
}
