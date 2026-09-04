import '../../domain/entities/product.dart';
import '../../domain/repo/product_repository.dart';
import '../remote/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._remoteDataSource);

  final ProductRemoteDataSource _remoteDataSource;

  @override
  Future<List<Product>> getProducts() async {
    final models = await _remoteDataSource.getProducts();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Product> getProductDetails({required String productId}) async {
    final model = await _remoteDataSource.getProductDetails(
      productId: productId,
    );
    return model.toEntity();
  }
}
