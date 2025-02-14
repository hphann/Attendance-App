import 'package:attendance/Account/ChangePasswordScreen.dart';
import 'package:attendance/Account/EditInfoScreen.dart';
import 'package:attendance/Account/LoginScreen.dart';
import 'package:attendance/Screens/HistoryScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:attendance/models/user.dart';
import 'package:attendance/services/user_service.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final UserService _userService = UserService();
  User? _user;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        return;
      }

      setState(() {
        _isLoading = true;
        _error = null;
      });

      final response = await _userService.getUserProfile(userId);
      setState(() {
        _user = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Lỗi: $_error'))
              : Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundImage: _user?.avatarUrl != null
                                ? NetworkImage(_user!.avatarUrl!)
                                : const AssetImage('assets/images/avatar.png'),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _user?.email ?? 'Người dùng',
                            style: const TextStyle(
                              fontSize: 24, 
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _user?.email ?? 'Không có email',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9F2FE),
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
                              _loadUserData();
                            },
                          ),
                          const SizedBox(height: 10),
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
                          const SizedBox(height: 10),
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
                          const SizedBox(height: 10),
                          _buildMenuItem(
                            context,
                            icon: Icons.language,
                            label: 'Ngôn ngữ',
                            onTap: () {

                            },
                          ),
                          const SizedBox(height: 10),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animation/sad.json',
                width: 200,
                height: 200,
                repeat: true,
              ),
              const SizedBox(height: 10),
              const Text(
                "Ôi không! Bạn sắp đăng xuất...\nBạn có chắc chắn không?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Không, tôi chỉ đùa thôi",
                    style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', false);

                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red, width: 2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Đúng, đăng xuất ngay",
                    style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        );
      },
    );
  }
}
