import 'package:dio/dio.dart';
import 'package:attendance/models/absence_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AbsenceRequestService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://attendance-7f16.onrender.com/api',
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  Future<void> _setUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      _dio.options.headers['userId'] = userId;
    }
  }

  Future<AbsenceRequest> createRequest(Map<String, dynamic> requestData) async {
    try {
      await _setUserId();
      final response =
          await _dio.post('/absence-requests/create', data: requestData);

      if (response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return AbsenceRequest.fromJson(data['data']);
        }
        throw Exception(data['message'] ?? 'Tạo yêu cầu thất bại');
      }
      throw Exception('Tạo yêu cầu thất bại');
    } on DioException catch (e) {
      throw Exception('Lỗi khi tạo yêu cầu: ${e.message}');
    }
  }

  Future<List<AbsenceRequest>> getEventRequests(String eventId) async {
    try {
      await _setUserId();
      final response = await _dio.get('/absence-requests/event/$eventId');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final requests = data['data']['requests'] as List;
          return requests.map((r) => AbsenceRequest.fromJson(r)).toList();
        }
        throw Exception(data['message'] ?? 'Lấy danh sách yêu cầu thất bại');
      }
      throw Exception('Lấy danh sách yêu cầu thất bại');
    } on DioException catch (e) {
      throw Exception('Lỗi khi lấy danh sách yêu cầu: ${e.message}');
    }
  }

  Future<void> updateStatus(String requestId, String status) async {
    try {
      await _setUserId();
      final response = await _dio.put('/absence-requests/$requestId/status', 
        data: {'status': status}
      );

      if (response.statusCode != 200) {
        throw Exception('Cập nhật trạng thái thất bại');
      }
    } on DioException catch (e) {
      throw Exception('Lỗi khi cập nhật trạng thái: ${e.message}');
    }
  }
}
