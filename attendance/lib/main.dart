import 'package:attendance/Attendance/QrGenerator.dart';
import 'package:attendance/Attendance/QrScanner.dart';
import 'package:attendance/Screens/HistoryScreen.dart';
import 'package:attendance/Screens/HomeScreen.dart';
import 'package:attendance/Screens/MainScreen.dart';
import 'package:attendance/screens/DetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:attendance/Account/LoginScreen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lottie/lottie.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('vi_VN', null); // Sử dụng tiếng Việt
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Đường dẫn animation
  static const String _loadingLottieUrl = 'animation/attendance.json';

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 2)); // Mô phỏng thời gian tải
    bool isLoggedIn = await _checkLoginStatus();

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          _loadingLottieUrl,
          width: 200, // Điều chỉnh kích thước
          height: 200, // Điều chỉnh kích thước
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}