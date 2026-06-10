import '../entities/api_product.dart';

/// Read + write access to API products for the internal portal. In the live
/// build, writes call Apigee X (create/update API Product) + Drupal content.
abstract interface class ProductAdminRepository {
  Future<List<ApiProduct>> list();
  Future<ApiProduct> get(String id);

  /// Upserts a product. An empty [ApiProduct.id] creates a new one.
  Future<ApiProduct> save(ApiProduct product);
}
