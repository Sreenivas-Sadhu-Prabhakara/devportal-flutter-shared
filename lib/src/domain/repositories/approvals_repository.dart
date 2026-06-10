import '../entities/approval_request.dart';

/// The app/product-access approval queue (stubbed governance).
abstract interface class ApprovalsRepository {
  Future<List<ApprovalRequest>> pending();

  /// Resolves a request. Both approve and reject remove it from the queue;
  /// approve would issue keys in the live build.
  Future<void> decide(String id, {required bool approve});
}
