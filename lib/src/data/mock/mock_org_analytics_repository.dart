import 'dart:math' as math;

import '../../domain/entities/analytics.dart';
import '../../domain/entities/org_analytics.dart';
import '../../domain/repositories/org_analytics_repository.dart';

class MockOrgAnalyticsRepository implements OrgAnalyticsRepository {
  @override
  Future<OrgAnalytics> get() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final rnd = math.Random(20260610);

    const days = 14;
    final traffic = <UsagePoint>[];
    var total = 0;
    for (var i = 0; i < days; i++) {
      final wave = math.sin(i / 2.4) * 0.2 + 1;
      final calls = (62000 * wave + rnd.nextInt(14000)).round();
      total += calls;
      traffic.add(UsagePoint('D${i + 1}', calls.toDouble()));
    }

    final errorRate = 0.9;
    final ok = (total * (1 - errorRate / 100) * 0.985).round();
    final clientErr = (total * 0.012).round();
    final serverErr = total - ok - clientErr;

    return OrgAnalytics(
      totalCalls: total,
      activeApps: 42,
      totalDevelopers: 18,
      avgLatencyMs: 108,
      errorRatePct: errorRate,
      traffic: traffic,
      statusBreakdown: [
        UsagePoint('2xx', ok.toDouble()),
        UsagePoint('4xx', clientErr.toDouble()),
        UsagePoint('5xx', serverErr.toDouble()),
      ],
      topProducts: const [
        TopItem('Payment Execution API', 384200),
        TopItem('Payment Initiation API', 291750),
        TopItem('Payment Order API', 268400),
        TopItem('Accounts API', 168400),
        TopItem('FX Rates API', 96300),
      ],
      topApps: const [
        TopItem('Aurora Mobile', 212900),
        TopItem('LedgerBot', 154300),
        TopItem('OpenBank KYC', 98700),
        TopItem('PayWave Pro', 73400),
        TopItem('CardStack Issuer', 51200),
      ],
    );
  }
}
