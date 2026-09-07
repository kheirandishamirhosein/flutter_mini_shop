/// Shared network configuration.
///
/// Keep host-level values here so the rest of the app never hard-codes URLs.
abstract final class ApiConfig {
  static const String baseUrl = 'https://fakestoreapi.com';

  static Uri get productsUri => Uri.parse('$baseUrl/products');

  static Uri get productCategoriesUri =>
      Uri.parse('$baseUrl/products/categories');

  static Uri productsByCategoryUri(String categoryName) {
    final normalizedCategoryName = categoryName.trim();
    if (normalizedCategoryName.isEmpty) {
      throw ArgumentError.value(
        categoryName,
        'categoryName',
        'Must not be empty.',
      );
    }

    return Uri.parse(baseUrl).replace(
      pathSegments: ['products', 'category', normalizedCategoryName],
    );
  }

  static Uri productDetailsUri(String productId) {
    final normalizedProductId = productId.trim();
    if (normalizedProductId.isEmpty) {
      throw ArgumentError.value(productId, 'productId', 'Must not be empty.');
    }

    return Uri.parse(baseUrl).replace(
      pathSegments: ['products', normalizedProductId],
    );
  }
}
