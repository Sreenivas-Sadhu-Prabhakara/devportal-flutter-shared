import '../entities/api_product.dart';

/// Read access to the API catalog. Implemented by a mock now and a live
/// Drupal-backed source later — the UI/Bloc layer depends only on this.
abstract interface class CatalogRepository {
  Future<List<ApiProduct>> getProducts();
  Future<ApiProduct> getProduct(String id);
}
