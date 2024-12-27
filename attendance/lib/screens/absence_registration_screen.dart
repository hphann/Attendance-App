// lib/screens/absence_registration_screen.dart
import 'package:flutter/material.dart';

class AbsenceRegistrationScreen extends StatefulWidget {
  const AbsenceRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<AbsenceRegistrationScreen> createState() =>
      _AbsenceRegistrationScreenState();
}

class _AbsenceRegistrationScreenState extends State<AbsenceRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _typeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _typeController.dispose();
    _phoneController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      print('Form submitted');
      print('Tiêu đề: ${_titleController.text}');
      print('Loại nghỉ phép: ${_typeController.text}');
      print('Số điện thoại: ${_phoneController.text}');
      print('Lý do: ${_reasonController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Đăng ký vắng mặt',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Tiêu đề'),
              _buildTextFormField(
                controller: _titleController,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Vui lòng nhập tiêu đề';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildLabel('Loại nghỉ phép'),
              _buildTextFormField(
                controller: _typeController,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Vui lòng nhập loại nghỉ phép';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildLabel('Số điện thoại'),
              _buildTextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  if (!RegExp(r'^\d{10}$').hasMatch(value!)) {
                    return 'Số điện thoại không hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildLabel('Lý do xin nghỉ'),
              _buildTextFormField(
                controller: _reasonController,
                maxLines: 5,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Vui lòng nhập lý do xin nghỉ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Gửi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
