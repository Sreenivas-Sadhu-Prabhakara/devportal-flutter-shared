import '../entities/flow_scenario.dart';

/// End-to-end flow scenarios (developer guides that chain the BIAN payment
/// APIs). Content lives in Drupal in the live build.
abstract interface class FlowsRepository {
  Future<List<FlowScenario>> list();
  Future<FlowScenario> get(String id);
}
