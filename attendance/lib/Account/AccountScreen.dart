import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              padding: const EdgeInsets.only(top: 50, bottom: 20),
              child: Center(
                child: Text(
                  'Tài khoản',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              )),
          Container(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              margin: EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage('images/avatar.png'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Trần Thế Luật',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'trantheluat@gmail.com',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              color: const Color(0xFFE9F2FE),
            ),
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.edit,
                  label: 'Chỉnh sửa thông tin',
                  onTap: () {
                  },
                ),
                SizedBox(height: 10,),
                _buildMenuItem(
                  context,
                  icon: Icons.lock,
                  label: 'Đổi mật khẩu',
                  onTap: () {
                  },
                ),
                SizedBox(height: 10,),
                _buildMenuItem(
                  context,
                  icon: Icons.language,
                  label: 'Ngôn ngữ',
                  onTap: () {
                  },
                ),
                SizedBox(height: 10,),
                _buildMenuItem(
                  context,
                  icon: Icons.logout,
                  label: 'Đăng xuất',
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  onTap: () {
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
