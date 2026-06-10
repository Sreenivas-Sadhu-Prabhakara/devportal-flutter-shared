import 'package:equatable/equatable.dart';

import 'credential.dart';

enum AppStatus { approved, pending, revoked }

AppStatus _statusFrom(String? v) => switch (v) {
      'pending' => AppStatus.pending,
      'revoked' => AppStatus.revoked,
      _ => AppStatus.approved,
    };

/// A developer's registered application (maps to an Apigee Developer App).
class DeveloperApp extends Equatable {
  const DeveloperApp({
    required this.id,
    required this.name,
    required this.developerEmail,
    required this.status,
    required this.description,
    required this.productIds,
    required this.credentials,
    required this.createdAt,
    required this.colorIndex,
  });

  final String id;
  final String name;
  final String developerEmail;
  final AppStatus status;
  final String description;
  final List<String> productIds;
  final List<Credential> credentials;
  final String createdAt;
  final int colorIndex;

  DeveloperApp copyWith({AppStatus? status, List<Credential>? credentials}) {
    return DeveloperApp(
      id: id,
      name: name,
      developerEmail: developerEmail,
      status: status ?? this.status,
      description: description,
      productIds: productIds,
      credentials: credentials ?? this.credentials,
      createdAt: createdAt,
      colorIndex: colorIndex,
    );
  }

  factory DeveloperApp.fromJson(Map<String, dynamic> j) => DeveloperApp(
        id: j['id'] as String,
        name: j['name'] as String,
        developerEmail: j['developerEmail'] as String,
        status: _statusFrom(j['status'] as String?),
        description: j['description'] as String? ?? '',
        productIds: (j['productIds'] as List<dynamic>? ?? const [])
            .map((e) => e as String)
            .toList(),
        credentials: (j['credentials'] as List<dynamic>? ?? const [])
            .map((e) => Credential.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdAt: j['createdAt'] as String? ?? '',
        colorIndex: (j['colorIndex'] as num?)?.toInt() ?? 0,
      );

  @override
  List<Object?> get props => [id, status, credentials];
}
