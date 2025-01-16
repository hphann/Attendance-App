import 'package:flutter/material.dart';
import 'LeaveScreen.dart';
import 'AccountScreen.dart';
import 'QrScreen.dart';
import 'EventScreen.dart';
import 'HomeScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  final List<Widget> _screens = [
    HomeScreen(),
    EventScreen(),
    QrScreen(),
    LeaveScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: _screens.asMap().entries.map((entry) {
          int index = entry.key;
          return Offstage(
            offstage: _currentIndex != index,
            child: Navigator(
              key: _navigatorKeys[index],
              onGenerateRoute: (routeSettings) {
                return MaterialPageRoute(
                  builder: (context) => entry.value,
                );
              },
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined),
            label: 'Sự kiện',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Quét mã',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_off_outlined),
            label: 'Xin phép',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Hồ sơ',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
