import 'package:flutter/material.dart';

import '../../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    required this.isFavorite,
    required this.onFavoriteTap,
    super.key,
  });

  final Product product;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final visual = _visualFor(product.category);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [visual.color, visual.color.withOpacity(.58)],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                      ),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Center(
                          child:
                              Icon(visual.icon, color: Colors.white, size: 62),
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      top: 7,
                      end: 7,
                      child: Material(
                        color: Colors.white.withOpacity(.9),
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: onFavoriteTap,
                          customBorder: const CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(7),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isFavorite
                                  ? const Color(0xFFE05072)
                                  : const Color(0xFF5F5A6B),
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 3),
              Text(
                product.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF817C8C), fontSize: 11),
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  const Icon(Icons.star_rounded,
                      color: Color(0xFFFFB22C), size: 16),
                  const SizedBox(width: 2),
                  Text(
                    product.rating.toStringAsFixed(1),
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFF4336D0),
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                '${product.reviewCount} reviews',
                style: const TextStyle(color: Color(0xFF777285), fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _ProductVisual _visualFor(ProductCategory category) {
    return switch (category) {
      ProductCategory.electronics => const _ProductVisual(
          color: Color(0xFF6254DC),
          icon: Icons.headphones_rounded,
        ),
      ProductCategory.jewelry => const _ProductVisual(
          color: Color(0xFFD98C47),
          icon: Icons.diamond_outlined,
        ),
      ProductCategory.mensClothing => const _ProductVisual(
          color: Color(0xFF3B9E96),
          icon: Icons.checkroom_rounded,
        ),
      ProductCategory.womensClothing => const _ProductVisual(
          color: Color(0xFFD46A89),
          icon: Icons.checkroom_rounded,
        ),
      ProductCategory.all => const _ProductVisual(
          color: Color(0xFF6254DC),
          icon: Icons.storefront_rounded,
        ),
    };
  }
}

class _ProductVisual {
  const _ProductVisual({required this.color, required this.icon});

  final Color color;
  final IconData icon;
}
