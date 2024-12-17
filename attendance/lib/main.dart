import 'package:attendance/LoginScreen.dart';
import 'package:attendance/SignUpScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: SignUpScreen(),
    ),
  ));
}
