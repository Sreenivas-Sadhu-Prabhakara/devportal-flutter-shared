import 'package:equatable/equatable.dart';

enum ProductVisibility { public, partner, internal }

ProductVisibility _visibilityFrom(String? v) => switch (v) {
      'partner' => ProductVisibility.partner,
      'internal' => ProductVisibility.internal,
      _ => ProductVisibility.public,
    };

class ApiEndpoint extends Equatable {
  const ApiEndpoint({
    required this.method,
    required this.path,
    required this.summary,
  });

  final String method;
  final String path;
  final String summary;

  factory ApiEndpoint.fromJson(Map<String, dynamic> j) => ApiEndpoint(
        method: j['method'] as String,
        path: j['path'] as String,
        summary: j['summary'] as String,
      );

  @override
  List<Object?> get props => [method, path, summary];
}

/// A published API product (catalog entry). In the live build this maps to an
/// Apigee API Product + its Drupal `apigee_api_catalog` doc node.
class ApiProduct extends Equatable {
  const ApiProduct({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.category,
    required this.version,
    required this.colorIndex,
    required this.visibility,
    required this.featured,
    required this.specUrl,
    required this.basePath,
    required this.endpoints,
    required this.docsMarkdown,
    required this.tierName,
    required this.quotaLimit,
    required this.quotaInterval,
    required this.sampleResponse,
  });

  final String id;
  final String name;
  final String tagline;
  final String description;
  final String category;
  final String version;
  final int colorIndex;
  final ProductVisibility visibility;
  final bool featured;
  final String specUrl;
  final String basePath;
  final List<ApiEndpoint> endpoints;
  final String docsMarkdown;

  // Tier / quota — modelled now so monetization slots in later (not billed yet).
  final String tierName;
  final int quotaLimit;
  final String quotaInterval;

  /// Canned response body returned by the mock "Try it" console.
  final String sampleResponse;

  ApiProduct copyWith({
    String? name,
    String? tagline,
    String? description,
    String? category,
    String? version,
    int? colorIndex,
    ProductVisibility? visibility,
    bool? featured,
    String? basePath,
    String? tierName,
    int? quotaLimit,
    String? quotaInterval,
  }) {
    return ApiProduct(
      id: id,
      name: name ?? this.name,
      tagline: tagline ?? this.tagline,
      description: description ?? this.description,
      category: category ?? this.category,
      version: version ?? this.version,
      colorIndex: colorIndex ?? this.colorIndex,
      visibility: visibility ?? this.visibility,
      featured: featured ?? this.featured,
      specUrl: specUrl,
      basePath: basePath ?? this.basePath,
      endpoints: endpoints,
      docsMarkdown: docsMarkdown,
      tierName: tierName ?? this.tierName,
      quotaLimit: quotaLimit ?? this.quotaLimit,
      quotaInterval: quotaInterval ?? this.quotaInterval,
      sampleResponse: sampleResponse,
    );
  }

  factory ApiProduct.fromJson(Map<String, dynamic> j) => ApiProduct(
        id: j['id'] as String,
        name: j['name'] as String,
        tagline: j['tagline'] as String,
        description: j['description'] as String,
        category: j['category'] as String,
        version: j['version'] as String,
        colorIndex: (j['colorIndex'] as num).toInt(),
        visibility: _visibilityFrom(j['visibility'] as String?),
        featured: (j['featured'] as bool?) ?? false,
        specUrl: j['specUrl'] as String? ?? '',
        basePath: j['basePath'] as String,
        endpoints: (j['endpoints'] as List<dynamic>)
            .map((e) => ApiEndpoint.fromJson(e as Map<String, dynamic>))
            .toList(),
        docsMarkdown: j['docsMarkdown'] as String,
        tierName: j['tierName'] as String? ?? 'Standard',
        quotaLimit: (j['quotaLimit'] as num?)?.toInt() ?? 0,
        quotaInterval: j['quotaInterval'] as String? ?? 'month',
        sampleResponse: j['sampleResponse'] as String? ?? '{}',
      );

  @override
  List<Object?> get props => [id, version];
}
