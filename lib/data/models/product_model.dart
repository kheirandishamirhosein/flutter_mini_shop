import '../../domain/entities/product.dart';

class ProductModel {
  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.ratingCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final ratingJson = json['rating'];
    final rating = ratingJson is Map<String, dynamic> ? ratingJson : null;

    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      imageUrl: json['image'] as String,
      rating: (rating?['rate'] as num?)?.toDouble() ?? 0,
      ratingCount: (rating?['count'] as num?)?.toInt() ?? 0,
    );
  }

  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;
  final int ratingCount;

  Product toEntity() {
    return Product(
      id: id.toString(),
      title: title,
      description: description,
      imageUrl: imageUrl,
      category: _mapCategory(category),
      price: price,
      rating: rating,
      reviewCount: ratingCount,
    );
  }

  ProductCategory _mapCategory(String apiCategory) {
    return switch (apiCategory) {
      'electronics' => ProductCategory.electronics,
      'jewelery' => ProductCategory.jewelry,
      "men's clothing" => ProductCategory.mensClothing,
      "women's clothing" => ProductCategory.womensClothing,
      _ => ProductCategory.all,
    };
  }
}
