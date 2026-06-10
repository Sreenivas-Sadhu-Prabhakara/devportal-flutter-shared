import 'package:equatable/equatable.dart';

enum FlowKind { internal, external }

FlowKind _kindFrom(String? v) =>
    v == 'external' ? FlowKind.external : FlowKind.internal;

/// One call in an end-to-end flow (maps to a BIAN payment API request).
class FlowStep extends Equatable {
  const FlowStep({
    required this.title,
    required this.apiName,
    required this.method,
    required this.path,
    required this.request,
    required this.response,
    required this.note,
  });

  final String title;
  final String apiName;
  final String method;
  final String path;
  final String request; // JSON string, may be empty (e.g. GET)
  final String response; // JSON string
  final String note;

  factory FlowStep.fromJson(Map<String, dynamic> j) => FlowStep(
        title: j['title'] as String,
        apiName: j['apiName'] as String,
        method: j['method'] as String,
        path: j['path'] as String,
        request: j['request'] as String? ?? '',
        response: j['response'] as String? ?? '',
        note: j['note'] as String? ?? '',
      );

  @override
  List<Object?> get props => [title, apiName, method, path];
}

/// An end-to-end orchestration of the BIAN payment APIs (e.g. an internal or
/// external fund transfer).
class FlowScenario extends Equatable {
  const FlowScenario({
    required this.id,
    required this.name,
    required this.summary,
    required this.kind,
    required this.colorIndex,
    required this.steps,
  });

  final String id;
  final String name;
  final String summary;
  final FlowKind kind;
  final int colorIndex;
  final List<FlowStep> steps;

  factory FlowScenario.fromJson(Map<String, dynamic> j) => FlowScenario(
        id: j['id'] as String,
        name: j['name'] as String,
        summary: j['summary'] as String,
        kind: _kindFrom(j['kind'] as String?),
        colorIndex: (j['colorIndex'] as num?)?.toInt() ?? 0,
        steps: (j['steps'] as List<dynamic>)
            .map((e) => FlowStep.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [id, steps];
}
