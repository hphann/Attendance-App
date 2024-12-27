import 'package:attendance/Account/AccountScreen.dart';
import 'package:attendance/Account/EditInfoScreen.dart';
import 'package:attendance/Account/SignUpScreen.dart';
import 'package:attendance/screens/absence_registration_screen.dart';
import 'package:attendance/screens/detail_screen.dart';
import 'package:attendance/screens/home_screen.dart';
import 'package:attendance/screens/organizer_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:attendance/Account/CreateNewPasswordScreen.dart';
import 'package:attendance/Account/ForgotPasswordScreen.dart';
import 'package:attendance/Account/LoginScreen.dart';
import 'package:attendance/Account/VerifyEmailScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: HomeScreen(),
      ),
    );
  }
}