import 'package:attendance/Account/CreateNewPasswordScreen.dart';
import 'package:attendance/Account/ForgotPasswordScreen.dart';
import 'package:attendance/Account/LoginScreen.dart';
import 'package:attendance/Account/VerifyEmailScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: CreateNewPasswordScreen(),
      // body: SignUpScreen(),
    ),
  ));
}
