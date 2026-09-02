class ProductApiException implements Exception {
  const ProductApiException(this.message);

  final String message;

  @override
  String toString() => 'ProductApiException: $message';
}
