import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_service.dart';

class EventProvider with ChangeNotifier {
  final EventService _eventService = EventService();
  final formKey = GlobalKey<FormState>();

  List<Event> _events = [];
  bool _isLoading = false;
  String? _error;
  Event? _selectedEvent;
  int _currentPage = 1;
  int _totalPages = 1;
  int _itemsPerPage = 10;
  String _searchQuery = '';
  String _filterType = 'all'; // For filter
  String _selectedStatus = 'all';

  // Controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  DateTime? startTime;
  DateTime? endTime;
  String selectedType = 'event'; // 'event' hoặc 'class'
  String? repeat;
  List<String> selectedDays = [];
  String? classTime;

  // Getters
  List<Event> get events => _applyFilters();
  bool get isLoading => _isLoading;
  String? get error => _error;
  Event? get selectedEvent => _selectedEvent;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get itemsPerPage => _itemsPerPage;
  String get searchQuery => _searchQuery;
  String get filterType => _filterType;
  String get selectedStatus => _selectedStatus;

  List<Event> _applyFilters() {
    return _events.where((event) {
      final matchesSearch = _searchQuery.isEmpty ||
          event.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.location.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesType = _filterType == 'all' || event.type == _filterType;

      final matchesStatus =
          _selectedStatus == 'all' || event.status == _selectedStatus;

      return matchesSearch && matchesType && matchesStatus;
    }).toList();
  }

  void searchEvents(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void filterByType(String type) {
    _filterType = type;
    notifyListeners();
  }

  void filterByStatus(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  Future<void> loadEvents({int? page}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await _eventService.getEvents(
        page: page ?? _currentPage,
        limit: _itemsPerPage,
      );

      _events = result['events'];
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

  void setSelectedEvent(Event? event) {
    _selectedEvent = event;
    if (event != null) {
      nameController.text = event.name;
      descriptionController.text = event.description;
      locationController.text = event.location;
      selectedType = event.type;
      startTime = event.startTime;
      endTime = event.endTime;
      repeat = event.repeat;
      selectedDays = event.daysOfWeek?.toList() ?? [];
      classTime = event.time;
    } else {
      clearForm();
    }
    notifyListeners();
  }

  Future<bool> submitEvent() async {
    if (!formKey.currentState!.validate()) return false;
    if (startTime == null || endTime == null) {
      _error = 'Vui lòng chọn thời gian bắt đầu và kết thúc';
      notifyListeners();
      return false;
    }

    // Kiểm tra thời gian hợp lệ
    if (startTime!.isAfter(endTime!)) {
      _error = 'Thời gian kết thúc phải sau thời gian bắt đầu';
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final event = Event(
        id: _selectedEvent?.id,
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        startTime: startTime!,
        endTime: endTime!,
        type: selectedType,
        location: locationController.text.trim(),
        createdBy: 'test_user_id',
        createdAt: DateTime.now(),
        status: 'upcoming', // Default status
        repeat: repeat,
        daysOfWeek: selectedDays.isNotEmpty ? selectedDays : null,
        time: null, // Optional: Add if needed
      );

      print('Submitting event: ${event.toJson()}'); // Debug log

      if (_selectedEvent != null) {
        await _eventService.updateEvent(_selectedEvent!.id!, event);
        // Load lại danh sách sau khi cập nhật
        await loadEvents();
      } else {
        await _eventService.createEvent(event);
        // Load lại danh sách sau khi tạo mới
        await loadEvents();
      }

      clearForm();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteEvent(String id) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _eventService.deleteEvent(id);
      await loadEvents();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    locationController.clear();
    selectedType = 'event';
    startTime = null;
    endTime = null;
    repeat = null;
    selectedDays = [];
    classTime = null;
    _selectedEvent = null;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }
}
