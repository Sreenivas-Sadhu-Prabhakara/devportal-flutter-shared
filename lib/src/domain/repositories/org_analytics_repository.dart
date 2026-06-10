import '../entities/org_analytics.dart';

/// Org-wide analytics for the internal portal.
abstract interface class OrgAnalyticsRepository {
  Future<OrgAnalytics> get();
}
