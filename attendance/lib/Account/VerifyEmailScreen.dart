import 'package:flutter/material.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: const Text(
          'Xác minh Email',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
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
                  Center(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F0FE),
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.only(top: 50, bottom: 30),
                      child: Image.asset(
                        'images/email.png',
                        width: 250,
                        height: 250,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child:  const Text(
                      'Vui lòng nhập mã gồm 4 chữ số \n được gửi tới email của bạn',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  SizedBox(height: 50,),
                  _buildTextField(
                    label: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child:  const Text(
                      'Gửi lại mã',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 50,),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print('Email: ${_emailController.text}');
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
                      'Gửi',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
              // Thêm viền mặc định
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
              // Viền khi được focus
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
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