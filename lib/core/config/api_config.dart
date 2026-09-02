/// Shared network configuration.
///
/// Keep host-level values here so the rest of the app never hard-codes URLs.
abstract final class ApiConfig {
  static const String baseUrl = 'https://fakestoreapi.com';

  static Uri get productsUri => Uri.parse('$baseUrl/products');
}
