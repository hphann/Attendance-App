import 'package:attendance/models/attendance.dart';
import 'package:flutter/material.dart';
import 'package:attendance/models/event.dart';
import 'package:attendance/services/event_service.dart';
import 'package:attendance/services/attendance_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventProvider with ChangeNotifier {
  final EventService _service = EventService();
  final AttendanceService _attendanceService = AttendanceService();
  String? _userId;
  List<Event> _events = [];
  bool _isLoading = false;
  String? _error;
  Map<String, Attendance> _attendanceStatus = {};

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> createEvent(Map<String, dynamic> eventData) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final event = await _service.createEvent(eventData);
      _events.add(event);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchEvents() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final events = await _service.getEvents();
      _events = events;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateEvent(String eventId, Event event) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _service.updateEvent(eventId, event.toJson());

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _service.deleteEvent(eventId);

      // Xóa sự kiện khỏi danh sách local
      _events.removeWhere((event) => event.id == eventId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchUserEvents() async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      _userId = prefs.getString('userId');
      if (_userId == null) {
        _error = 'Không tìm thấy thông tin người dùng';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final events = await _service.getUserEvents();
      _events = events;
      _error = null;

      // Reset và cập nhật attendance status
      _attendanceStatus.clear();
      for (var event in events) {
        if (event.id != null) {
          try {
            final attendances =
                await _attendanceService.getEventAttendance(event.id!);

            // Tìm attendance của user hiện tại
            final userAttendance = attendances.firstWhere(
              (a) => a['user_id'] == _userId,
              orElse: () => null,
            );

            if (userAttendance != null) {
              _attendanceStatus[event.id!] =
                  Attendance.fromJson(userAttendance);
            }
          } catch (e) {
            print('Error fetching attendance for event ${event.id}: $e');
          }
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchEventsByCreator() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final events = await _service.getEventsByCreator();
      _events = events;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Attendance? getAttendanceStatus(String eventId) {
    final attendance = _attendanceStatus[eventId];
    print(
        'Getting attendance status for event $eventId: $attendance'); // Debug log
    return attendance;
  }
}
