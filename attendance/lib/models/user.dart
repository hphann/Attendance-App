import '../utils/date_utils.dart';

class User {
  final String? id;
  final String name;
  final String gender;
  final String email;
  final String phone;
  final bool disabled;
  final String? role;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    required this.name,
    required this.gender,
    required this.email,
    required this.phone,
    this.disabled = false,
    this.role,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    String formatPhoneNumber(String? phone) {
      if (phone == null || phone.isEmpty) return '';
      if (phone.startsWith('+84')) {
        return '0${phone.substring(3)}';
      }
      return phone;
    }

    return User(
      id: json['id']?.toString() ?? json['uid']?.toString(),
      name: json['displayName']?.toString() ?? '',
      gender: json['gender']?.toString() ?? 'Nam',
      email: json['email']?.toString() ?? '',
      phone: formatPhoneNumber(json['phoneNumber']?.toString()),
      disabled: json['disabled'] ?? false,
      role: json['role']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
      createdAt: parseDateTimeFromJson(json['createdAt']),
      updatedAt: parseDateTimeFromJson(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    String formatPhoneNumber(String phone) {
      return phone;
    }

    return {
      'displayName': name,
      'gender': gender,
      'email': email,
      'phoneNumber': formatPhoneNumber(phone),
      'role': role,
      'avatarUrl': avatarUrl,
    };
  }
}
