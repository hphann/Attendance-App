import 'package:dio/dio.dart';
import 'package:attendance/models/event.dart';

class EventService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/api'));

  Future<Map<String, dynamic>> getEvents({int page = 1, int limit = 10}) async {
    try {
      final response = await _dio.get(
        '/events/all',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final List<Event> events = (response.data['data']['events'] as List)
          .map((json) => Event.fromJson(json))
          .toList();

      return {
        'events': events,
        'total': response.data['data']['total'],
        'currentPage': page,
        'totalPages': (response.data['data']['total'] / limit).ceil(),
      };
    } catch (e) {
      throw Exception('Không thể lấy danh sách sự kiện: $e');
    }
  }

  Future<Event> createEvent(Event event) async {
    try {
      final response = await _dio.post('/events/create', data: event.toJson());
      return Event.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Không thể tạo sự kiện: $e');
    }
  }

  Future<void> updateEvent(String id, Event event) async {
    try {
      await _dio.put('/events/edit/$id', data: event.toJson());
    } catch (e) {
      throw Exception('Không thể cập nhật sự kiện: $e');
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      await _dio.delete('/events/delete/$id');
    } catch (e) {
      throw Exception('Không thể xóa sự kiện: $e');
    }
  }
}
