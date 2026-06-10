import 'package:equatable/equatable.dart';

class UsagePoint extends Equatable {
  const UsagePoint(this.label, this.value);
  final String label;
  final double value;

  @override
  List<Object?> get props => [label, value];
}

/// Per-app usage analytics. In the live build this is served by a custom Drupal
/// REST endpoint that proxies the Apigee X stats API.
class AppAnalytics extends Equatable {
  const AppAnalytics({
    required this.totalCalls,
    required this.avgLatencyMs,
    required this.errorRatePct,
    required this.quotaUsed,
    required this.quotaLimit,
    required this.traffic,
    required this.latency,
    required this.statusBreakdown,
  });

  final int totalCalls;
  final double avgLatencyMs;
  final double errorRatePct;
  final int quotaUsed;
  final int quotaLimit;

  final List<UsagePoint> traffic; // calls per day
  final List<UsagePoint> latency; // p95 ms per day
  final List<UsagePoint> statusBreakdown; // 2xx / 4xx / 5xx counts

  @override
  List<Object?> get props => [totalCalls, avgLatencyMs, errorRatePct];
}
