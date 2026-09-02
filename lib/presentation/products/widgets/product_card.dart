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
                      child: Center(
                        child: Icon(
                          visual.icon,
                          color: Colors.white,
                          size: 62,
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
                    if (product.oldPrice != null)
                      PositionedDirectional(
                        bottom: 7,
                        start: 7,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xFF2C2850),
                          ),
                          child: const Text(
                            'پیشنهاد ویژه',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
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
                    _formatPrice(product.price),
                    style: const TextStyle(
                      color: Color(0xFF4336D0),
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              if (product.oldPrice != null)
                Text(
                  '${_formatPrice(product.oldPrice!)} تومان',
                  style: const TextStyle(
                    color: Color(0xFFAAA5B2),
                    fontSize: 10,
                    decoration: TextDecoration.lineThrough,
                  ),
                )
              else
                const SizedBox(height: 12),
              const Text(
                'تومان',
                style: TextStyle(color: Color(0xFF777285), fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    final digits = price.toString();
    final buffer = StringBuffer();
    for (var index = 0; index < digits.length; index++) {
      final remaining = digits.length - index;
      buffer.write(digits[index]);
      if (remaining > 1 && remaining % 3 == 1) {
        buffer.write(',');
      }
    }
    return buffer.toString();
  }

  _ProductVisual _visualFor(ProductCategory category) {
    return switch (category) {
      ProductCategory.electronics => const _ProductVisual(
          color: Color(0xFF6254DC),
          icon: Icons.headphones_rounded,
        ),
      ProductCategory.fashion => const _ProductVisual(
          color: Color(0xFFD46A89),
          icon: Icons.checkroom_rounded,
        ),
      ProductCategory.home => const _ProductVisual(
          color: Color(0xFF3B9E96),
          icon: Icons.light_rounded,
        ),
      ProductCategory.beauty => const _ProductVisual(
          color: Color(0xFFD98C47),
          icon: Icons.spa_rounded,
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
