// lib/models/event_participant.dart
class EventParticipant {
  final String? id;
  final String eventId;
  final String userId;
  final String status;
  final DateTime createdAt;
  final Map<String, dynamic>? userInfo;

  EventParticipant({
    this.id,
    required this.eventId,
    required this.userId,
    required this.status,
    required this.createdAt,
    this.userInfo,
  });

  factory EventParticipant.fromJson(Map<String, dynamic> json) {
    return EventParticipant(
      id: json['id'],
      eventId: json['eventId'],
      userId: json['userId'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      userInfo: json['userInfo'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'eventId': eventId,
        'userId': userId,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'userInfo': userInfo,
      };
}