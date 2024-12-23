import 'package:attendance/Account/CreateNewPasswordScreen.dart';
import 'package:attendance/Account/ForgotPasswordScreen.dart';
import 'package:attendance/Account/LoginScreen.dart';
import 'package:attendance/Account/VerifyEmailScreen.dart';

import 'package:attendance/screens/home_screen.dart';
import 'package:attendance/screens/detail_screen.dart';
import 'package:attendance/screens/absence_registration_screen.dart';
import 'package:attendance/screens/organizer_dashboard_screen.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: Scaffold(
      body: OrganizerDashboardScreen(),
      // body: SignUpScreen(),
    ),
  ));
}
