import 'dart:convert';

import '../../domain/entities/api_product.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../fixtures/catalog_fixture.dart';

/// In-memory catalog backed by [catalogJson]. Mirrors the decode path a live
/// HTTP data source would use.
class MockCatalogRepository implements CatalogRepository {
  List<ApiProduct>? _cache;

  List<ApiProduct> _load() {
    return _cache ??= (jsonDecode(catalogJson) as List<dynamic>)
        .map((e) => ApiProduct.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ApiProduct>> getProducts() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return _load();
  }

  @override
  Future<ApiProduct> getProduct(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _load().firstWhere(
      (p) => p.id == id,
      orElse: () => throw StateError('Product not found: $id'),
    );
  }
}
