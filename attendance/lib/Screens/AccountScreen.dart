import 'package:attendance/Account/ChangePasswordScreen.dart';
import 'package:attendance/Account/EditInfoScreen.dart';
import 'package:attendance/Account/LoginScreen.dart';
import 'package:attendance/Screens/HistoryScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ứng dụng Điểm danh',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 30),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('images/avatar.png'),
                ),
                SizedBox(height: 10),
                Text(
                  'Trần Thế Luật',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'trantheluat@gmail.com',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color(0xFFE9F2FE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.edit,
                  label: 'Chỉnh sửa thông tin',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditInfoScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                _buildMenuItem(
                  context,
                  icon: Icons.lock,
                  label: 'Đổi mật khẩu',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChangePasswordScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                _buildMenuItem(
                  context,
                  icon: Icons.history,
                  label: 'Lịch sử điểm danh',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HistoryScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                _buildMenuItem(
                  context,
                  icon: Icons.language,
                  label: 'Ngôn ngữ',
                ),
                SizedBox(height: 10),
                _buildMenuItem(
                  context,
                  icon: Icons.logout,
                  label: 'Đăng xuất',
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool('isLoggedIn', false);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
      required String label,
      Color iconColor = Colors.black,
      Color textColor = Colors.black,
      VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        label,
        style: TextStyle(color: textColor),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
