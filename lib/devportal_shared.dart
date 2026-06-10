/// devportal_shared — cinematic design system + domain + data layer shared by
/// the internal and external developer-portal Flutter apps.
library;

// Theme
export 'src/theme/tokens.dart';
export 'src/theme/app_theme.dart';

// Widgets
export 'src/widgets/portal_mark.dart';
export 'src/widgets/status_badge.dart';
export 'src/widgets/section_header.dart';
export 'src/widgets/poster_card.dart';
export 'src/widgets/carousel.dart';
export 'src/widgets/hero_spotlight.dart';
export 'src/widgets/metric_tile.dart';
export 'src/widgets/mini_chart.dart';

// Domain entities
export 'src/domain/entities/api_product.dart';
export 'src/domain/entities/credential.dart';
export 'src/domain/entities/developer_app.dart';
export 'src/domain/entities/analytics.dart';
export 'src/domain/entities/developer.dart';
export 'src/domain/entities/approval_request.dart';
export 'src/domain/entities/org_analytics.dart';
export 'src/domain/entities/flow_scenario.dart';

// Domain repositories (interfaces)
export 'src/domain/repositories/catalog_repository.dart';
export 'src/domain/repositories/apps_repository.dart';
export 'src/domain/repositories/analytics_repository.dart';
export 'src/domain/repositories/product_admin_repository.dart';
export 'src/domain/repositories/developers_repository.dart';
export 'src/domain/repositories/approvals_repository.dart';
export 'src/domain/repositories/org_analytics_repository.dart';
export 'src/domain/repositories/flows_repository.dart';

// Mock data implementations
export 'src/data/mock/mock_catalog_repository.dart';
export 'src/data/mock/mock_apps_repository.dart';
export 'src/data/mock/mock_analytics_repository.dart';
export 'src/data/mock/mock_product_admin_repository.dart';
export 'src/data/mock/mock_developers_repository.dart';
export 'src/data/mock/mock_approvals_repository.dart';
export 'src/data/mock/mock_org_analytics_repository.dart';
export 'src/data/mock/mock_flows_repository.dart';
