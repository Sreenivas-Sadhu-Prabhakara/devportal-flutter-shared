import 'package:equatable/equatable.dart';

/// A pending app/product-access request awaiting review (the stubbed governance
/// queue). Pairs with the external app registering against a restricted product.
class ApprovalRequest extends Equatable {
  const ApprovalRequest({
    required this.id,
    required this.appName,
    required this.developerName,
    required this.developerEmail,
    required this.products,
    required this.requestedAt,
    required this.note,
  });

  final String id;
  final String appName;
  final String developerName;
  final String developerEmail;
  final List<String> products; // display names
  final String requestedAt;
  final String note;

  factory ApprovalRequest.fromJson(Map<String, dynamic> j) => ApprovalRequest(
        id: j['id'] as String,
        appName: j['appName'] as String,
        developerName: j['developerName'] as String,
        developerEmail: j['developerEmail'] as String,
        products: (j['products'] as List<dynamic>? ?? const [])
            .map((e) => e as String)
            .toList(),
        requestedAt: j['requestedAt'] as String? ?? '',
        note: j['note'] as String? ?? '',
      );

  @override
  List<Object?> get props => [id];
}
