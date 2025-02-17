import 'package:dio/dio.dart';
import 'package:attendance/models/event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:3000/api',
    // Nếu chạy trên thiết bị thật, dùng IP của máy tính
    // baseUrl: 'http://192.168.1.xxx:3000/api',
    // 'https://attendance-7f16.onrender.com/api'
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  EventService() {
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<void> _setUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      _dio.options.headers['userId'] = userId;
    }
  }

  Future<Event> createEvent(Map<String, dynamic> eventData) async {
    try {
      await _setUserId();
      final response = await _dio.post('/events/create', data: eventData);

      if (response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return Event.fromJson(data['data']);
        }
        throw Exception(data['message'] ?? 'Tạo sự kiện thất bại');
      }
      throw Exception('Tạo sự kiện thất bại');
    } on DioException catch (e) {
      throw Exception('Lỗi khi tạo sự kiện: ${e.message}');
    }
  }

  Future<List<Event>> getEvents() async {
    try {
      final response = await _dio.get('/events/all');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final eventsList = data['data']['events'] as List;
          return eventsList.map((e) => Event.fromJson(e)).toList();
        }
        throw Exception(data['message'] ?? 'Lấy danh sách sự kiện thất bại');
      }

      throw Exception('Lấy danh sách sự kiện thất bại');
    } on DioException catch (e) {
      throw Exception('Lỗi khi lấy danh sách sự kiện: ${e.message}');
    }
  }

  Future<void> updateEvent(String eventId, Map<String, dynamic> eventData) async {
    try {
      await _setUserId();
      final response = await _dio.put('/events/$eventId', data: eventData);

      if (response.statusCode != 200) {
        throw Exception('Cập nhật sự kiện thất bại');
      }
    } on DioException catch (e) {
      throw Exception('Lỗi khi cập nhật sự kiện: ${e.message}');
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _setUserId();
      final response = await _dio.delete('/events/$eventId');

      if (response.statusCode != 200) {
        throw Exception('Xóa sự kiện thất bại');
      }
    } on DioException catch (e) {
      throw Exception('Lỗi khi xóa sự kiện: ${e.message}');
    }
  }
}
