import 'package:flutter/material.dart';
import 'package:attendance/models/event_participant.dart';
import 'package:attendance/services/event_participant_service.dart';

class EventParticipantProvider with ChangeNotifier {
  final EventParticipantService _service = EventParticipantService();
  List<EventParticipant> _participants = [];
  bool _isLoading = false;
  String? _error;

  List<EventParticipant> get participants => _participants;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getEventParticipants(String eventId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _participants = await _service.getEventParticipants(eventId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addParticipants(String eventId, List<String> userIds) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _service.addParticipants(eventId, userIds);
      await getEventParticipants(eventId); // Refresh list

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateParticipant(
      String participantId, Map<String, dynamic> data) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _service.updateParticipant(participantId, data);

      // Cập nhật local state
      final index = _participants.indexWhere((p) => p.id == participantId);
      if (index != -1) {
        _participants[index] = EventParticipant.fromJson({
          ..._participants[index].toJson(),
          ...data,
        });
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteParticipant(String participantId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _service.deleteParticipant(participantId);

      // Xóa khỏi local state
      _participants.removeWhere((p) => p.id == participantId);

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
