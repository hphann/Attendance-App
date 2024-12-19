import 'package:attendance/Account/CreateNewPasswordScreen.dart';
import 'package:attendance/Account/ForgotPasswordScreen.dart';
import 'package:attendance/Account/LoginScreen.dart';
import 'package:attendance/Account/VerifyEmailScreen.dart';

import 'package:attendance/screens/homeScreen.dart';
import 'package:attendance/screens/detailScreen.dart';
import 'package:attendance/screens/absenceRegistrationScreen.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: Scaffold(
      body: DetailScreen(),
      // body: SignUpScreen(),
    ),
  ));
}
