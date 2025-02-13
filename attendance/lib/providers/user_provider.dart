import 'package:flutter/material.dart';
import 'package:attendance/models/user.dart';
import 'package:attendance/services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();
  final formKey = GlobalKey<FormState>();

  List<User> _users = [];
  bool _isLoading = false;
  String? _error;
  User? _selectedUser;
  int _currentPage = 1;
  int _totalPages = 1;
  int _itemsPerPage = 10;
  String? _successMessage;
  String _searchQuery = '';
  String _selectedRole = 'Tất cả';
  String _selectedStatus = 'Tất cả';
  List<User> _filteredUsers = [];

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  String selectedGender = 'Nam';

  // Getters
  List<User> get users => _applyFilters();
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;
  User? get selectedUser => _selectedUser;

  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get itemsPerPage => _itemsPerPage;

  String get searchQuery => _searchQuery;
  String get selectedRole => _selectedRole;
  String get selectedStatus => _selectedStatus;
  List<User> get filteredUsers => _applyFilters();

  List<User> _applyFilters() {
    return _users.where((user) {
      // Search match
      final matchesSearch = _searchQuery.isEmpty ||
          user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.phone.contains(_searchQuery);

      // Role match
      final matchesRole = _selectedRole == 'Tất cả' ||
          user.role?.toLowerCase() == _selectedRole.toLowerCase();

      // Status match
      final matchesStatus = _selectedStatus == 'Tất cả' ||
          (_selectedStatus == 'Hoạt động' && !user.disabled) ||
          (_selectedStatus == 'Đã khóa' && user.disabled);

      return matchesSearch && matchesRole && matchesStatus;
    }).toList();
  }

  // Update filter methods
  void searchUsers(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void filterByRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }

  void filterByStatus(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedRole = 'Tất cả';
    _selectedStatus = 'Tất cả';
    notifyListeners();
  }

  Future<void> loadUsers({int? page}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await _userService.getUsers(
        page: page ?? _currentPage,
        limit: _itemsPerPage,
      );

      _users = result['users'];
      _totalPages = result['totalPages'];
      _currentPage = result['currentPage'];
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void changePage(int page) {
    if (page != _currentPage && page > 0 && page <= _totalPages) {
      _currentPage = page;
      loadUsers(page: page);
    }
  }

  void setSelectedUser(User? user) {
    _selectedUser = user;
    if (user != null) {
      nameController.text = user.name;
      emailController.text = user.email;
      phoneController.text = user.phone;
      selectedGender = user.gender;
    } else {
      clearForm();
    }
    notifyListeners();
  }

  Future<bool> submitUser() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    try {
      _isLoading = true;
      _error = null;
      _successMessage = null;
      notifyListeners();

      final user = User(
        id: _selectedUser?.id,
        name: nameController.text.trim(),
        gender: selectedGender,
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
      );

      if (_selectedUser != null) {
        await _userService.updateUser(_selectedUser!.id!, user);
        _successMessage = 'Cập nhật người dùng thành công';
      } else {
        final result = await _userService.createUser(user);
        _successMessage = '''
Tạo người dùng thành công!
Email: ${result['user'].email}
Mật khẩu: ${result['password']}
''';
      }

      clearForm();
      await loadUsers();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteUser(String id) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _userService.deleteUser(id);
      await loadUsers();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> toggleUserStatus(String id, bool disabled) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _userService.toggleUserStatus(id, disabled);
      await loadUsers();

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<void> exportUsers() async {
  //   try {
  //     _isLoading = true;
  //     notifyListeners();

  //     final bytes = await _userService.exportUsers();
  //     final blob = html.Blob([bytes]);
  //     final url = html.Url.createObjectUrlFromBlob(blob);
  //     final anchor = html.AnchorElement(href: url)
  //       ..setAttribute(
  //           "download", "users_${DateTime.now().toIso8601String()}.xlsx")
  //       ..click();
  //     html.Url.revokeObjectUrl(url);
  //   } catch (e) {
  //     _error = e.toString();
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  void clearForm() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    selectedGender = 'Nam';
    _selectedUser = null;
    _successMessage = null;
    _error = null;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
