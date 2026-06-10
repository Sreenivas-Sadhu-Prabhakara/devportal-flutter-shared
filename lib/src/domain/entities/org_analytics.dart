import 'package:equatable/equatable.dart';

import 'analytics.dart';

class TopItem extends Equatable {
  const TopItem(this.name, this.calls);
  final String name;
  final int calls;

  @override
  List<Object?> get props => [name, calls];
}

/// Org-wide analytics for the internal portal (live: Drupal REST → Apigee X
/// stats API aggregated across apps/products).
class OrgAnalytics extends Equatable {
  const OrgAnalytics({
    required this.totalCalls,
    required this.activeApps,
    required this.totalDevelopers,
    required this.avgLatencyMs,
    required this.errorRatePct,
    required this.traffic,
    required this.statusBreakdown,
    required this.topProducts,
    required this.topApps,
  });

  final int totalCalls;
  final int activeApps;
  final int totalDevelopers;
  final double avgLatencyMs;
  final double errorRatePct;
  final List<UsagePoint> traffic;
  final List<UsagePoint> statusBreakdown;
  final List<TopItem> topProducts;
  final List<TopItem> topApps;

  @override
  List<Object?> get props => [totalCalls, activeApps, totalDevelopers];
}
