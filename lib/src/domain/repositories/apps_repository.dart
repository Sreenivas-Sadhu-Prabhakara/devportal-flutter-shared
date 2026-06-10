import '../entities/developer_app.dart';

/// Manages a developer's apps and credentials (maps to Apigee Developer Apps).
abstract interface class AppsRepository {
  Future<List<DeveloperApp>> getApps(String developerEmail);
  Future<DeveloperApp> getApp(String id);

  /// Registers a new app. Public-only product sets are auto-approved and get
  /// keys immediately; sets containing a restricted product return a pending
  /// app (the stubbed approval queue). [restricted] flags that case.
  Future<DeveloperApp> registerApp({
    required String developerEmail,
    required String name,
    required String description,
    required List<String> productIds,
    required bool restricted,
  });
}
