import 'package:attendance/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class UserService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://attendance-7f16.onrender.com/api';

  Future<Map<String, dynamic>> getUsers({int page = 1, int limit = 10}) async {
    try {
      final response = await _dio.get(
        '$baseUrl/users/all',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.data['success']) {
        final List<dynamic> data = response.data['data']['users'];
        final int total = response.data['data']['total'];
        final users = data.map((json) => User.fromJson(json)).toList();

        return {
          'users': users,
          'total': total,
          'currentPage': page,
          'totalPages': (total / limit).ceil(),
        };
      }
      throw Exception(response.data['message']);
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách người dùng: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> createUser(User user) async {
    try {
      final response = await _dio.post(
        '$baseUrl/users/create',
        data: user.toJson(),
      );
      if (response.data['success']) {
        return {
          'user': User.fromJson(response.data['data']),
          'password': response.data['data']['password']
        };
      }
      throw Exception(response.data['message']);
    } catch (e) {
      throw Exception('Lỗi khi tạo người dùng: ${e.toString()}');
    }
  }

  Future<User> updateUser(String id, User user) async {
    try {
      final response = await _dio.put(
        '$baseUrl/users/edit/$id',
        data: user.toJson(),
      );
      if (response.data['success']) {
        // Kiểm tra xem data có tồn tại không
        if (response.data['data'] != null) {
          return User.fromJson(response.data['data']);
        }
        // Nếu không có data, trả về user hiện tại
        return user;
      }
      throw Exception(response.data['message']);
    } catch (e) {
      throw Exception('Lỗi khi cập nhật người dùng: ${e.toString()}');
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      final response = await _dio.delete('$baseUrl/users/delete/$id');
      if (!response.data['success']) {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Lỗi khi xóa người dùng: ${e.toString()}');
    }
  }

  Future<void> toggleUserStatus(String id, bool disabled) async {
    try {
      final response = await _dio.put(
        '$baseUrl/users/toggle-status/$id',
        data: {'disabled': disabled},
      );
      if (!response.data['success']) {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Lỗi khi thay đổi trạng thái tài khoản: ${e.toString()}');
    }
  }

  Future<Uint8List> exportUsers() async {
    try {
      final response = await _dio.get(
        '$baseUrl/users/export',
        options: Options(responseType: ResponseType.bytes),
      );
      return response.data;
    } catch (e) {
      throw Exception('Lỗi khi xuất danh sách: ${e.toString()}');
    }
  }

  Future<User> getUserProfile(String id) async {
    try {
      final response = await _dio.get('$baseUrl/users/profile/$id');
      if (response.data['success']) {
        return User.fromJson(response.data['data']);
      }
      throw Exception(response.data['message']);
    } catch (e) {
      throw Exception('Lỗi khi lấy thông tin người dùng: ${e.toString()}');
    }
  }
}
