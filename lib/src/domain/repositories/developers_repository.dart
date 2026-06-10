import '../entities/developer.dart';

/// Lists registered developers (live: Apigee developers via Drupal).
abstract interface class DevelopersRepository {
  Future<List<Developer>> list();
}
