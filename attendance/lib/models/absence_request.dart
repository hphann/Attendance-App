// lib/models/absence_request.dart
class AbsenceRequest {
  final String? id;
  final String userId;
  final String eventId;
  final String reason;
  final String status; // PENDING, APPROVED, REJECTED
  final DateTime requestedAt;
  final Map<String, dynamic>? userInfo;
  final Map<String, dynamic>? eventInfo;

  AbsenceRequest({
    this.id,
    required this.userId,
    required this.eventId,
    required this.reason,
    required this.status,
    required this.requestedAt,
    this.userInfo,
    this.eventInfo,
  });

  factory AbsenceRequest.fromJson(Map<String, dynamic> json) {
    DateTime parseDateTime(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          print('Error parsing date: $e');
          return DateTime.now();
        }
      }
      return DateTime.now();
    }

    return AbsenceRequest(
      id: json['id'],
      userId: json['userId'],
      eventId: json['eventId'],
      reason: json['reason'],
      status: json['status'],
      requestedAt: parseDateTime(json['requestedAt']),
      userInfo: json['userInfo'],
      eventInfo: json['eventInfo'],
    );
  }

  get startDate => null;

  get endDate => null;
}
