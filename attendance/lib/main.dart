import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:attendance/Account/AccountScreen.dart';
import 'package:attendance/Account/EditInfoScreen.dart';
import 'package:attendance/Account/SignUpScreen.dart';
import 'package:attendance/Account/UpdateInfoScreen.dart';
import 'package:attendance/screens/absence_registration_screen.dart';
import 'package:attendance/screens/detail_screen.dart';
import 'package:attendance/screens/home_screen.dart';
import 'package:attendance/screens/organizer_dashboard_screen.dart';
import 'package:attendance/Account/CreateNewPasswordScreen.dart';
import 'package:attendance/Account/ForgotPasswordScreen.dart';
import 'package:attendance/Account/LoginScreen.dart';
import 'package:attendance/Account/VerifyEmailScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  bool isLoggedIn = await checkLoginStatus();
  runApp(MyApp(isLoggedIn));
}

Future<bool> checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false; // trả về false nếu chưa có giá trị
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp(this.isLoggedIn);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: isLoggedIn ? HomeScreen() : LoginScreen(),
      ),
    );
  }
}