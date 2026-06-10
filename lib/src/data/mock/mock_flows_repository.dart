import 'dart:convert';

import '../../domain/entities/flow_scenario.dart';
import '../../domain/repositories/flows_repository.dart';
import '../fixtures/flows_fixture.dart';

class MockFlowsRepository implements FlowsRepository {
  List<FlowScenario>? _cache;

  List<FlowScenario> _load() {
    return _cache ??= (jsonDecode(flowsJson) as List<dynamic>)
        .map((e) => FlowScenario.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<FlowScenario>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _load();
  }

  @override
  Future<FlowScenario> get(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _load().firstWhere((f) => f.id == id,
        orElse: () => throw StateError('Flow not found: $id'));
  }
}
