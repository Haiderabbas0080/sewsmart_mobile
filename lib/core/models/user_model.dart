// ─── User Model ───────────────────────────────────────────────────────────────
// API-ready: matches expected JSON response from backend

enum UserRole { customer, tailor, rider }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final UserRole role;
  final bool isVerified;
  final String? city;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.isVerified,
    this.avatar,
    this.city,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    role: UserRole.values.byName(json['role']),
    isVerified: json['is_verified'] ?? false,
    avatar: json['avatar'],
    city: json['city'],
    createdAt: DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'email': email, 'phone': phone,
    'role': role.name, 'is_verified': isVerified,
    'avatar': avatar, 'city': city,
    'created_at': createdAt.toIso8601String(),
  };

  String get initials => name.split(' ').map((e) => e[0]).take(2).join().toUpperCase();
}
