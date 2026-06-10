import 'dart:convert';

import '../../domain/entities/api_product.dart';
import '../../domain/repositories/product_admin_repository.dart';
import '../fixtures/catalog_fixture.dart';

/// In-memory product store for the internal portal. Seeded from the catalog
/// fixture; create/update mutate the list so the UI reflects changes live.
class MockProductAdminRepository implements ProductAdminRepository {
  List<ApiProduct>? _products;
  int _counter = 0;

  List<ApiProduct> _store() {
    return _products ??= (jsonDecode(catalogJson) as List<dynamic>)
        .map((e) => ApiProduct.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ApiProduct>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_store());
  }

  @override
  Future<ApiProduct> get(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _store().firstWhere((p) => p.id == id,
        orElse: () => throw StateError('Product not found: $id'));
  }

  @override
  Future<ApiProduct> save(ApiProduct product) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final store = _store();
    if (product.id.isEmpty) {
      _counter++;
      final slug = product.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-');
      final created = ApiProduct(
        id: 'prod-$slug-$_counter',
        name: product.name,
        tagline: product.tagline,
        description: product.description,
        category: product.category,
        version: product.version,
        colorIndex: product.colorIndex,
        visibility: product.visibility,
        featured: product.featured,
        specUrl: product.specUrl,
        basePath: product.basePath,
        endpoints: product.endpoints,
        docsMarkdown: product.docsMarkdown,
        tierName: product.tierName,
        quotaLimit: product.quotaLimit,
        quotaInterval: product.quotaInterval,
        sampleResponse: product.sampleResponse,
      );
      store.insert(0, created);
      return created;
    }
    final idx = store.indexWhere((p) => p.id == product.id);
    if (idx >= 0) {
      store[idx] = product;
    } else {
      store.insert(0, product);
    }
    return product;
  }
}
