import 'dart:convert';

import '../../domain/entities/credential.dart';
import '../../domain/entities/developer_app.dart';
import '../../domain/repositories/apps_repository.dart';
import '../fixtures/apps_fixture.dart';

/// In-memory apps store. Seeds from [appsJson] and supports in-session
/// registration so the happy path (register → get key) is fully clickable.
class MockAppsRepository implements AppsRepository {
  List<DeveloperApp>? _apps;
  int _counter = 0;

  List<DeveloperApp> _store() {
    return _apps ??= (jsonDecode(appsJson) as List<dynamic>)
        .map((e) => DeveloperApp.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<DeveloperApp>> getApps(String developerEmail) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _store().where((a) => a.developerEmail == developerEmail).toList();
  }

  @override
  Future<DeveloperApp> getApp(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _store().firstWhere(
      (a) => a.id == id,
      orElse: () => throw StateError('App not found: $id'),
    );
  }

  @override
  Future<DeveloperApp> registerApp({
    required String developerEmail,
    required String name,
    required String description,
    required List<String> productIds,
    required bool restricted,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    _counter++;
    final id = 'app_${name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '')}_$_counter';
    final status = restricted ? AppStatus.pending : AppStatus.approved;

    // Restricted product sets land in the (stubbed) approval queue: an app is
    // created but no live key is issued until approved.
    final credentials = restricted
        ? const <Credential>[]
        : [
            Credential(
              key: _fakeKey(id, 32),
              secret: 's_${_fakeKey(id, 18)}',
              status: 'approved',
              productIds: productIds,
            ),
          ];

    final app = DeveloperApp(
      id: id,
      name: name,
      developerEmail: developerEmail,
      status: status,
      description: description,
      productIds: productIds,
      credentials: credentials,
      createdAt: '2026-06-10',
      colorIndex: _counter % 6,
    );
    _store().insert(0, app);
    return app;
  }

  // Deterministic pseudo-key so the demo is stable across rebuilds.
  String _fakeKey(String seed, int len) {
    const alphabet =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    var h = 0x811c9dc5;
    for (final c in seed.codeUnits) {
      h = (h ^ c) * 0x01000193 & 0x7fffffff;
    }
    final sb = StringBuffer();
    for (var i = 0; i < len; i++) {
      h = (h * 1103515245 + 12345) & 0x7fffffff;
      sb.write(alphabet[h % alphabet.length]);
    }
    return sb.toString();
  }
}
