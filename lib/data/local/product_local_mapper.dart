import '../../domain/entities/product.dart';

/// Converts products to and from the JSON shape used by local storage.
class ProductLocalMapper {
  const ProductLocalMapper._();

  static Product fromJson(Object? json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Product is not an object.');
    }

    final id = json['id'];
    final title = json['title'];
    final description = json['description'];
    final imageUrl = json['imageUrl'];
    final categoryName = json['category'];
    final price = json['price'];
    final rating = json['rating'];
    final reviewCount = json['reviewCount'];

    if (id is! String ||
        title is! String ||
        description is! String ||
        imageUrl is! String ||
        categoryName is! String ||
        price is! num ||
        rating is! num ||
        reviewCount is! int) {
      throw const FormatException('Product has invalid values.');
    }

    final category = ProductCategory.values
        .where((value) => value.name == categoryName)
        .firstOrNull;
    if (category == null) {
      throw const FormatException('Product has an invalid category.');
    }

    return Product(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      category: category,
      price: price.toDouble(),
      rating: rating.toDouble(),
      reviewCount: reviewCount,
    );
  }

  static Map<String, Object> toJson(Product product) {
    return <String, Object>{
      'id': product.id,
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'category': product.category.name,
      'price': product.price,
      'rating': product.rating,
      'reviewCount': product.reviewCount,
    };
  }
}
