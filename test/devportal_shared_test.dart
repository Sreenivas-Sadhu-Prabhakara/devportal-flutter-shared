import 'package:devportal_shared/devportal_shared.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mock catalog decodes fixtures', () async {
    final repo = MockCatalogRepository();
    final products = await repo.getProducts();
    expect(products, isNotEmpty);
    expect(products.first.endpoints, isNotEmpty);
  });

  test('mock catalog finds a product by id', () async {
    final repo = MockCatalogRepository();
    final product = await repo.getProduct('payment-initiation-v1');
    expect(product.name, 'Payment Initiation API');
  });

  test('flows fixture has internal and external transfers', () async {
    final repo = MockFlowsRepository();
    final flows = await repo.list();
    expect(flows.map((f) => f.id),
        containsAll(['internal-transfer', 'external-transfer']));
    final external = await repo.get('external-transfer');
    expect(external.steps.length, greaterThan(3)); // adds a settlement step
  });

  test('registering a public app issues a credential immediately', () async {
    final repo = MockAppsRepository();
    final app = await repo.registerApp(
      developerEmail: 'dev@example.com',
      name: 'Test App',
      description: '',
      productIds: const ['accounts-v2'],
      restricted: false,
    );
    expect(app.status, AppStatus.approved);
    expect(app.credentials, isNotEmpty);
  });

  test('registering a restricted app is pending with no credential', () async {
    final repo = MockAppsRepository();
    final app = await repo.registerApp(
      developerEmail: 'dev@example.com',
      name: 'Restricted App',
      description: '',
      productIds: const ['cards-v1'],
      restricted: true,
    );
    expect(app.status, AppStatus.pending);
    expect(app.credentials, isEmpty);
  });
}
