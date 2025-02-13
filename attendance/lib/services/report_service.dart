import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import '../models/report_stats.dart';

class ReportService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:3000/api/reports',
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 3),
  ));

  Future<ReportStats> getAttendanceReport(DateTime? start, DateTime? end) async {
    try {
      final response = await _dio.get(
        '/attendance',
        queryParameters: {
          if (start != null) 'startDate': start.toIso8601String(),
          if (end != null) 'endDate': end.toIso8601String(),
        },
      );

      if (response.data['success']) {
        return ReportStats.fromJson(response.data['data']);
      }
      throw Exception(response.data['message']);
    } catch (e) {
      throw Exception('Failed to load attendance report: ${e.toString()}');
    }
  }

  Future<List<EventStats>> getEventReport(DateTime? start, DateTime? end) async {
    try {
      final response = await _dio.get(
        '/events',
        queryParameters: {
          if (start != null) 'startDate': start.toIso8601String(),
          if (end != null) 'endDate': end.toIso8601String(),
        },
      );

      if (response.data['success']) {
        return (response.data['data'] as List)
            .map((json) => EventStats.fromJson(json))
            .toList();
      }
      throw Exception(response.data['message']);
    } catch (e) {
      throw Exception('Failed to load event report: ${e.toString()}');
    }
  }

  Future<String> exportToExcel(ReportStats stats, List<EventStats> events) async {
    try {
      final response = await _dio.get(
        '/export',
        queryParameters: {
          'type': 'excel',
          'startDate': stats.byDate.keys.first,
          'endDate': stats.byDate.keys.last,
        },
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/report_${DateTime.now().millisecondsSinceEpoch}.xlsx');
      await file.writeAsBytes(response.data);
      
      return file.path;
    } catch (e) {
      throw Exception('Failed to export Excel: ${e.toString()}');
    }
  }

  Future<String> exportToPdf(ReportStats stats, List<EventStats> events) async {
    try {
      final response = await _dio.get(
        '/export',
        queryParameters: {
          'type': 'pdf',
          'startDate': stats.byDate.keys.first,
          'endDate': stats.byDate.keys.last,
        },
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/report_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(response.data);
      
      return file.path;
    } catch (e) {
      throw Exception('Failed to export PDF: ${e.toString()}');
    }
  }
}