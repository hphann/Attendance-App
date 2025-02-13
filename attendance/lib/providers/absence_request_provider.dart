// lib/screens/leave_requests/provider/leave_request_provider.dart

import 'package:flutter/material.dart';

import '../models/absence_request.dart';
import '../services/absence_request_service.dart';

class AbsenceRequestProvider with ChangeNotifier {
  final AbsenceRequestService _service = AbsenceRequestService();
  List<AbsenceRequest> _requests = [];
  List<AbsenceRequest> _filteredRequests = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  int _totalPages = 1;
  int itemsPerPage = 10;
  String _searchQuery = '';
  String _selectedStatus = 'all';
  DateTime? _startDate;
  DateTime? _endDate;

  // Getters
  List<AbsenceRequest> get requests => _applyFilters();
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  String get selectedStatus => _selectedStatus;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  // Filter locally instead of making API calls
  List<AbsenceRequest> _applyFilters() {
    return _requests.where((request) {
      // Filter by search query
      final matchesSearch = _searchQuery.isEmpty ||
          request.reason.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          request.userInfo!['displayName']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          request.eventInfo!['name']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      // Filter by status
      final matchesStatus =
          _selectedStatus == 'all' || request.status == _selectedStatus;

      // Filter by date range
      final matchesDateRange = _startDate == null ||
          _endDate == null ||
          (request.requestedAt.isAfter(_startDate!) &&
              request.requestedAt.isBefore(_endDate!.add(Duration(days: 1))));

      return matchesSearch && matchesStatus && matchesDateRange;
    }).toList();
  }

  // Update filters without API calls
  void searchRequests(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void filterByStatus(String? status) {
    _selectedStatus = status ?? 'all';
    notifyListeners();
  }

  void filterByDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    notifyListeners();
  }

  // Load data from API only when needed
  Future<void> loadRequests({int? page}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await _service.getRequests(
        page: page ?? _currentPage,
        limit: itemsPerPage,
      );

      _requests = result['requests'];
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

  Future<bool> updateRequestStatus(String id, String status) async {
    try {
      await _service.updateStatus(id, status);
      await loadRequests();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
