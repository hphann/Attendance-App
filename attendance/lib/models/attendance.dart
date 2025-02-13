class Attendance {
  final String? id;
  final String userId;
  final String eventId;
  final String status; // present, late, absent
  final DateTime timestamp;
  final String? note;
  final String userName;
  final Map<String, dynamic>? eventInfo; // Thêm thông tin sự kiện

  Attendance({
    this.id,
    required this.userId,
    required this.eventId,
    required this.status,
    required this.timestamp,
    this.note,
    required this.userName,
    this.eventInfo,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    DateTime parseTimestamp(dynamic value) {
      if (value == null) return DateTime.now();

      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          print('Error parsing timestamp: $e');
          return DateTime.now();
        }
      }

      if (value is Map) {
        // Handle Firestore Timestamp
        if (value['_seconds'] != null) {
          return DateTime.fromMillisecondsSinceEpoch(value['_seconds'] * 1000);
        }
      }

      return DateTime.now();
    }

    return Attendance(
      id: json['id'],
      userId: json['userId'],
      eventId: json['eventId'],
      status: json['status'],
      timestamp: parseTimestamp(json['timestamp']),
      note: json['note'],
      userName: json['userName'] ?? '',
      eventInfo: json['eventInfo'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'eventId': eventId,
        'status': status,
        'timestamp': timestamp.toIso8601String(),
        'note': note,
        'userName': userName,
      };
}
