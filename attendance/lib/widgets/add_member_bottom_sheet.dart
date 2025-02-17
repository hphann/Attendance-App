import 'package:flutter/material.dart';
import 'package:attendance/services/user_service.dart';

class AddMemberBottomSheet extends StatefulWidget {
  final Function(List<String>) onMembersAdded;

  const AddMemberBottomSheet({
    Key? key,
    required this.onMembersAdded,
  }) : super(key: key);

  @override
  State<AddMemberBottomSheet> createState() => _AddMemberBottomSheetState();
}

class _AddMemberBottomSheetState extends State<AddMemberBottomSheet> {
  final TextEditingController _emailController = TextEditingController();
  final List<String> _members = [];
  final UserService _userService = UserService();
  String? _error;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _addMember() async {
    final email = _emailController.text.trim();

    // Kiểm tra email rỗng
    if (email.isEmpty) {
      setState(() {
        _error = 'Vui lòng nhập email';
      });
      return;
    }

    // Kiểm tra định dạng email
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(email)) {
      setState(() {
        _error = 'Email không đúng định dạng';
      });
      return;
    }

    // Kiểm tra email đã tồn tại trong danh sách
    if (_members.contains(email)) {
      setState(() {
        _error = 'Email đã được thêm';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final exists = await _userService.checkEmailExists(email);
      if (exists) {
        setState(() {
          _members.add(email);
          _emailController.clear();
          _error = null;
        });
      } else {
        setState(() {
          _error = 'Email không tồn tại trong hệ thống';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Có lỗi xảy ra, vui lòng thử lại';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _removeMember(String email) {
    setState(() {
      _members.remove(email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Thêm thành viên',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: _error,
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _addMember(),
                ),
              ),
              const SizedBox(width: 8),
              _isLoading
                  ? const CircularProgressIndicator()
                  : IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addMember,
                    ),
            ],
          ),
          const SizedBox(height: 16),
          if (_members.isNotEmpty) ...[
            const Text(
              'Danh sách thành viên:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _members.length,
              itemBuilder: (context, index) {
                final email = _members[index];
                return ListTile(
                  title: Text(email),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    color: Colors.red,
                    onPressed: () => _removeMember(email),
                  ),
                );
              },
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: _members.isEmpty
                    ? null
                    : () {
                        widget.onMembersAdded(_members);
                        Navigator.pop(context);
                      },
                child: const Text('Thêm'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
