import '../entities/product.dart';

/// The contract that the presentation layer uses to obtain products.
abstract class ProductRepository {
  Future<List<Product>> getProducts();

  Future<List<ProductCategory>> getProductCategories();

  Future<List<Product>> getProductsByCategory({
    required ProductCategory category,
  });

  Future<Product> getProductDetails({required String productId});
}
