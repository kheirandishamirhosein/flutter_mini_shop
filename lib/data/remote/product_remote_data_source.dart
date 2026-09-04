import 'models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();

  Future<ProductModel> getProductDetails({required String productId});
}
