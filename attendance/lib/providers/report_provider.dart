import 'package:flutter/material.dart';
import '../models/report_stats.dart';
import '../services/report_service.dart';

class ReportProvider with ChangeNotifier {
  final ReportService _service = ReportService();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;
  String? _error;
  ReportStats? _stats;
  List<EventStats> _events = [];
  String _exportPath = '';

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  ReportStats get stats => _stats ?? ReportStats.empty();
  List<EventStats> get events => _events;
  String get exportPath => _exportPath;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  Future<void> loadReportData() async {
    if (_startDate == null || _endDate == null) return;
    
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final results = await Future.wait([
        _service.getAttendanceReport(_startDate, _endDate),
        _service.getEventReport(_startDate, _endDate),
      ]);

      _stats = results[0] as ReportStats;
      _events = results[1] as List<EventStats>;

    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectStartDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      _startDate = date;
      startDateController.text = _formatDate(date);
      if (_endDate != null) {
        loadReportData();
      }
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      _endDate = date;
      endDateController.text = _formatDate(date);
      if (_startDate != null) {
        loadReportData();
      }
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
           "${date.month.toString().padLeft(2, '0')}/"
           "${date.year}";
  }

  Future<void> exportToPdf() async {
    if (_stats == null) return;
    
    try {
      _isLoading = true;
      notifyListeners();

      _exportPath = await _service.exportToPdf(_stats!, _events);
      _error = null;

    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> exportToExcel() async {
    if (_stats == null) return;
    
    try {
      _isLoading = true;
      notifyListeners();

      _exportPath = await _service.exportToExcel(_stats!, _events);
      _error = null;

    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }
}