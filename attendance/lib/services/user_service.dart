import 'package:attendance/models/user.dart';
import 'package:dio/dio.dart';

class UserService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://attendance-7f16.onrender.com/api';

  // Cập nhật thông tin người dùng
  Future<User> updateUser(String id, User user) async {
    try {
      final response = await _dio.put(
        '$baseUrl/users/edit/$id',
        data: user.toJson(),
      );
      
      if (response.data['success']) {
        if (response.data['data'] != null) {
          return User.fromJson(response.data['data']);
        }
        return user;
      }
      throw Exception(response.data['message'] ?? 'Lỗi khi cập nhật người dùng');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Lỗi kết nối: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi không xác định: ${e.toString()}');
    }
  }

  // Lấy thông tin người dùng
  Future<User> getUserProfile(String id) async {
    try {
      final response = await _dio.get('$baseUrl/users/profile/$id');
      
      if (response.data['success']) {
        return User.fromJson(response.data['data']);
      }
      throw Exception(response.data['message'] ?? 'Lỗi khi lấy thông tin người dùng');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Lỗi kết nối: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi không xác định: ${e.toString()}');
    }
  }

  Future<void> changePassword(
      String userId, String currentPassword, String newPassword) async {
    try {
      final response = await _dio.post(
        '$baseUrl/users/change-password/$userId',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );

      if (!response.data['success']) {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 400) {
          throw Exception('Mật khẩu hiện tại không chính xác');
        } else if (e.response?.data != null) {
          throw Exception(
              e.response?.data['message'] ?? 'Lỗi khi đổi mật khẩu');
        }
      }
      throw Exception('Lỗi khi đổi mật khẩu: ${e.toString()}');
    }
  }
}
