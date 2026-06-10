import 'dart:convert';

import '../../domain/entities/developer.dart';
import '../../domain/repositories/developers_repository.dart';
import '../fixtures/developers_fixture.dart';

class MockDevelopersRepository implements DevelopersRepository {
  List<Developer>? _cache;

  @override
  Future<List<Developer>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _cache ??= (jsonDecode(developersJson) as List<dynamic>)
        .map((e) => Developer.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
