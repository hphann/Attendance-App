class Event {
  final String? id;
  final String name;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String type;
  final String location;
  final String createdBy;
  final DateTime createdAt;
  String status;
  final String? repeat;
  final List<String>? daysOfWeek;
  final String? time;

  Event({
    this.id,
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.location,
    required this.createdBy,
    required this.createdAt,
    required this.status,
    this.repeat,
    this.daysOfWeek,
    this.time,
  });

  String getStatus() {
    final now = DateTime.now();

    if (now.isBefore(startTime)) {
      return 'upcoming';
    } else if (now.isAfter(endTime)) {
      return 'completed';
    } else {
      return 'active';
    }
  }

  String getDayOfWeek(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'T2';
      case DateTime.tuesday:
        return 'T3';
      case DateTime.wednesday:
        return 'T4';
      case DateTime.thursday:
        return 'T5';
      case DateTime.friday:
        return 'T6';
      case DateTime.saturday:
        return 'T7';
      case DateTime.sunday:
        return 'CN';
      default:
        return '';
    }
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          print('Error parsing date: $e');
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

    final event = Event(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      startTime: parseDate(json['startTime']),
      endTime: parseDate(json['endTime']),
      type: json['type'] ?? 'event',
      location: json['location'] ?? '',
      createdBy: json['createdBy'] ?? '',
      createdAt: parseDate(json['createdAt']),
      status: json['status'] ?? 'active',
      repeat: json['repeat'],
      daysOfWeek: json['daysOfWeek'] != null
          ? List<String>.from(json['daysOfWeek'])
          : null,
      time: json['time'],
    );

    event.status = event.getStatus();

    return event;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'type': type,
        'location': location,
        'createdBy': createdBy,
        'status': status,
        'repeat': repeat,
        'daysOfWeek': daysOfWeek,
        'time': time,
      };
}
