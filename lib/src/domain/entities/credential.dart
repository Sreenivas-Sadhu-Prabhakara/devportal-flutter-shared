import 'package:equatable/equatable.dart';

/// An app credential pair (consumer key/secret) issued by Apigee. In the mock
/// these are generated locally; in the live build they come from `apigee_edge`.
class Credential extends Equatable {
  const Credential({
    required this.key,
    required this.secret,
    required this.status,
    required this.productIds,
    this.expiresAt,
  });

  final String key;
  final String secret;
  final String status; // approved | pending | revoked
  final List<String> productIds;
  final String? expiresAt;

  factory Credential.fromJson(Map<String, dynamic> j) => Credential(
        key: j['key'] as String,
        secret: j['secret'] as String,
        status: j['status'] as String? ?? 'approved',
        productIds: (j['productIds'] as List<dynamic>? ?? const [])
            .map((e) => e as String)
            .toList(),
        expiresAt: j['expiresAt'] as String?,
      );

  @override
  List<Object?> get props => [key];
}
