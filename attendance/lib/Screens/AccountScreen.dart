import 'package:attendance/Account/ChangePasswordScreen.dart';
import 'package:attendance/Account/EditInfoScreen.dart';
import 'package:attendance/Account/LoginScreen.dart';
import 'package:attendance/Screens/HistoryScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

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
                  onTap: () {
                    _showLogoutConfirmationDialog(context);
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

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Bo góc hộp thoại
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'animation/sad.json', // Đường dẫn đến file Lottie của bạn
                width: 200,
                height: 200,
                repeat: true,
              ),
              SizedBox(height: 10),
              Text(
                "Ôi không! Bạn sắp đăng xuất...\nBạn có chắc chắn không?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng hộp thoại
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Màu đỏ
                  foregroundColor: Colors.white, // Màu chữ trắng
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Bo góc
                  ),
                ),
                child: Text("Không, tôi chỉ đùa thôi", style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 10),
              OutlinedButton(
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', false);

                  // Xóa toàn bộ stack và chuyển về màn hình đăng nhập
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) => false, // Xóa toàn bộ màn hình trước đó
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red, // Màu chữ đỏ
                  side: BorderSide(color: Colors.red, width: 2), // Viền đỏ
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Bo góc
                  ),
                ),
                child: Text("Đúng, đăng xuất ngay", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        );
      },
    );
  }
}
