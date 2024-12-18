import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedGender;
  String? _selectedRole;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final List<String> _genderOptions = ['Nam', 'Nữ', 'Khác'];
  final List<String> _roleOptions = ['Người tổ chức', 'Người tham gia'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4285F4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 30, bottom: 20),
                child: const Text(
                  'Tạo Tài Khoản',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(
                        label: 'Tên',
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                      ),
                      _buildTextField(
                        label: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _buildTextField(
                        label: 'Số điện thoại',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      _buildDropdownField(
                        label: 'Giới tính',
                        value: _selectedGender,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedGender = newValue;
                          });
                        },
                        items: _genderOptions,
                      ),
                      _buildDropdownField(
                        label: 'Vai trò',
                        value: _selectedRole,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedRole = newValue;
                          });
                        },
                        items: _roleOptions,
                      ),
                      _buildTextField(
                        label: 'Mật khẩu',
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ),
                      _buildTextField(
                        label: 'Nhập lại mật khẩu',
                        controller: _confirmPasswordController,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Bằng cách nhấp vào Đăng ký, bạn đồng ý với ',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12),
                              ),
                              Text(
                                'Điều khoản',
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                ',',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Chính sách quyền riêng tư',
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                ' của chúng tôi.',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            print('Name: ${_nameController.text}');
                            print('Email: ${_emailController.text}');
                            print('Phone: ${_phoneController.text}');
                            print('Gender: $_selectedGender');
                            print('Role: $_selectedRole');
                            print('Password: ${_passwordController.text}');
                            print(
                                'Confirm Password: ${_confirmPasswordController.text}');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4285F4),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Đăng ký',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            // Handle navigation to login screen
                          },
                          child: const Text(
                            'Bạn đã có tài khoản?',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required void Function(String?)? onChanged,
    required List<String> items,
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
          DropdownButtonFormField<String>(
            value: value,
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
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
                return 'Vui lòng chọn $label';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
