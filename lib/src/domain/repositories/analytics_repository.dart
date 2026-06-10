import '../entities/analytics.dart';

/// Usage analytics for an app (live: Drupal REST → Apigee X stats API).
abstract interface class AnalyticsRepository {
  Future<AppAnalytics> getAppAnalytics(String appId);
}
