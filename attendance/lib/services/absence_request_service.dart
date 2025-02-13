// lib/services/absence_request_service.dart
import 'package:attendance/models/absence_request.dart';
import 'package:dio/dio.dart';

class AbsenceRequestService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/api'));

  // lib/services/absence_request_service.dart
  Future<Map<String, dynamic>> getRequests({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/absence-requests',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.data['success']) {
        final data = response.data['data'];
        return {
          'requests': (data['requests'] as List)
              .map((json) => AbsenceRequest.fromJson(json))
              .toList(),
          'total': data['total'],
          'currentPage': page,
          'totalPages': data['totalPages'],
        };
      }
      throw Exception(response.data['message']);
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách đơn: ${e.toString()}');
    }
  }

  Future<void> updateStatus(String id, String status) async {
    try {
      final response = await _dio.put(
        '/absence-requests/$id/status',
        data: {'status': status},
      );
      if (!response.data['success']) {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Lỗi khi cập nhật trạng thái: ${e.toString()}');
    }
  }
}
