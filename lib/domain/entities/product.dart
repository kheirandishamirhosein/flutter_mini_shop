enum ProductCategory { all, electronics, fashion, home, beauty }

/// A business object. It deliberately has no Flutter/UI dependencies.
class Product {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    this.oldPrice,
    this.rating = 0,
    this.reviewCount = 0,
  });

  final String id;
  final String title;
  final String description;
  final ProductCategory category;
  final int price;
  final int? oldPrice;
  final double rating;
  final int reviewCount;
}
