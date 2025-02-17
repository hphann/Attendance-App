import 'package:flutter/material.dart';
import 'package:attendance/models/event.dart';
import 'package:attendance/services/event_service.dart';

class EventProvider with ChangeNotifier {
  final EventService _service = EventService();
  List<Event> _events = [];
  bool _isLoading = false;
  String? _error;

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
}
