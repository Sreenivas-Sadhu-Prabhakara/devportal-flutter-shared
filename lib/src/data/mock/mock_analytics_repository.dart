import 'dart:math' as math;

import '../../domain/entities/analytics.dart';
import '../../domain/repositories/analytics_repository.dart';

/// Deterministic synthetic analytics derived from the app id, so charts are
/// stable per app without a backend.
class MockAnalyticsRepository implements AnalyticsRepository {
  @override
  Future<AppAnalytics> getAppAnalytics(String appId) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));

    final seed = appId.codeUnits.fold<int>(7, (a, c) => (a * 31 + c) & 0xffff);
    final rnd = math.Random(seed);

    const days = 14;
    final traffic = <UsagePoint>[];
    final latency = <UsagePoint>[];
    var total = 0;
    final base = 1800 + rnd.nextInt(2600);
    for (var i = 0; i < days; i++) {
      final wave = (math.sin(i / 2.2) * 0.25 + 1);
      final calls = (base * wave + rnd.nextInt(600)).round();
      total += calls;
      traffic.add(UsagePoint('D${i + 1}', calls.toDouble()));
      latency.add(UsagePoint('D${i + 1}', (70 + rnd.nextInt(90)).toDouble()));
    }

    final avgLatency =
        latency.map((p) => p.value).reduce((a, b) => a + b) / latency.length;
    final errorRate = (rnd.nextDouble() * 1.8) + 0.2;

    final ok = (total * (1 - errorRate / 100) * 0.97).round();
    final clientErr = (total * 0.02).round();
    final serverErr = total - ok - clientErr;

    return AppAnalytics(
      totalCalls: total,
      avgLatencyMs: avgLatency,
      errorRatePct: errorRate,
      quotaUsed: total,
      quotaLimit: 100000,
      traffic: traffic,
      latency: latency,
      statusBreakdown: [
        UsagePoint('2xx', ok.toDouble()),
        UsagePoint('4xx', clientErr.toDouble()),
        UsagePoint('5xx', serverErr.toDouble()),
      ],
    );
  }
}
