import '../../../domain/entities/product.dart';

/// Translates Fake Store API category names into domain categories.
///
/// Keeping API-specific strings in data prevents them from leaking into the
/// domain and presentation layers.
abstract final class ProductCategoryMapper {
  static const Map<String, ProductCategory> _categoriesByApiName = {
    'electronics': ProductCategory.electronics,
    'jewelery': ProductCategory.jewelry,
    "men's clothing": ProductCategory.mensClothing,
    "women's clothing": ProductCategory.womensClothing,
  };

  static ProductCategory? fromApiName(String apiName) {
    return _categoriesByApiName[apiName];
  }

  static String toApiName(ProductCategory category) {
    return _categoriesByApiName.entries
        .firstWhere((entry) => entry.value == category)
        .key;
  }
}
