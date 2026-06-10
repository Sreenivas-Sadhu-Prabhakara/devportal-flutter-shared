import 'dart:convert';

import '../../domain/entities/approval_request.dart';
import '../../domain/repositories/approvals_repository.dart';
import '../fixtures/approvals_fixture.dart';

/// In-memory approval queue. `decide` removes the request so the dashboard
/// pending count and the queue stay consistent within a session.
class MockApprovalsRepository implements ApprovalsRepository {
  List<ApprovalRequest>? _queue;

  List<ApprovalRequest> _store() {
    return _queue ??= (jsonDecode(approvalsJson) as List<dynamic>)
        .map((e) => ApprovalRequest.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ApprovalRequest>> pending() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_store());
  }

  @override
  Future<void> decide(String id, {required bool approve}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    _store().removeWhere((r) => r.id == id);
  }
}
