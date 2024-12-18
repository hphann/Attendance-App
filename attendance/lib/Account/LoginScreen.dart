import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4285F4),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 10, left: 40),
                alignment: Alignment.bottomLeft,
                child: const Text(
                  'Xin chào',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFE8F0FE),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(18),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20,),
                    _buildTextField(
                      label: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _buildTextField(
                      label: 'Mật khẩu',
                      controller: _passwordController,
                      keyboardType: TextInputType.phone,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Quên mật khẩu?',
                          style: TextStyle(
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30,),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print(
                              'Email: ${_emailController.text}, Password: ${_passwordController.text}');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4285F4),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        'Đăng nhập',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Tạo tài khoản',
                        style: TextStyle(color: Colors.blue[800]),
                      ),
                    ),
                    const SizedBox(height: 25,),
                    const Text(
                      'Hoặc đăng nhập với',
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8F0FE),
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.only(right: 10, left: 10),
                          child: Image.asset(
                            'images/logo_google.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8F0FE),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'images/logo_facebook.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8F0FE),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'images/logo_apple.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập $label';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

