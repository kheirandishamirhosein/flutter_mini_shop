import '../entities/product.dart';

/// The contract that the presentation layer uses to obtain products.
abstract class ProductRepository {
  Future<List<Product>> getProducts();

  Future<Product> getProductDetails({required String productId});
}
