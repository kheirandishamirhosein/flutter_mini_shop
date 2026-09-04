enum ProductCategory { all, electronics, jewelry, mensClothing, womensClothing }

/// A business object. It deliberately has no Flutter/UI dependencies.
class Product {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.price,
    this.rating = 0,
    this.reviewCount = 0,
  });

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final ProductCategory category;
  final double price;
  final double rating;
  final int reviewCount;
}
