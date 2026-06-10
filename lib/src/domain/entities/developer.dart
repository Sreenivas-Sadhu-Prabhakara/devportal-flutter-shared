import 'package:equatable/equatable.dart';

enum DeveloperStatus { active, pending, blocked }

DeveloperStatus _statusFrom(String? v) => switch (v) {
      'pending' => DeveloperStatus.pending,
      'blocked' => DeveloperStatus.blocked,
      _ => DeveloperStatus.active,
    };

/// A registered developer (maps to an Apigee developer / Drupal user).
class Developer extends Equatable {
  const Developer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.company,
    required this.status,
    required this.appCount,
    required this.joinedAt,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String company;
  final DeveloperStatus status;
  final int appCount;
  final String joinedAt;

  String get fullName => '$firstName $lastName';

  factory Developer.fromJson(Map<String, dynamic> j) => Developer(
        id: j['id'] as String,
        firstName: j['firstName'] as String,
        lastName: j['lastName'] as String,
        email: j['email'] as String,
        company: j['company'] as String? ?? '',
        status: _statusFrom(j['status'] as String?),
        appCount: (j['appCount'] as num?)?.toInt() ?? 0,
        joinedAt: j['joinedAt'] as String? ?? '',
      );

  @override
  List<Object?> get props => [id, status, appCount];
}
