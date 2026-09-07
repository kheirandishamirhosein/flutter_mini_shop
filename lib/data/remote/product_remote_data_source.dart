import 'models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();

  Future<List<String>> getProductCategories();

  Future<List<ProductModel>> getProductsByCategory({
    required String categoryName,
  });

  Future<ProductModel> getProductDetails({required String productId});
}
