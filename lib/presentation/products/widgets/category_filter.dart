import 'package:flutter/material.dart';

import '../../../domain/entities/product.dart';

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
    super.key,
  });

  final List<ProductCategory> categories;
  final ProductCategory selectedCategory;
  final ValueChanged<ProductCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (context, index) {
        final category = categories[index];
        final selected = selectedCategory == category;
        return ChoiceChip(
          label: Text(_labelFor(category)),
          selected: selected,
          showCheckmark: false,
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          labelStyle: TextStyle(
            color: selected ? Colors.white : const Color(0xFF585363),
            fontWeight: FontWeight.w700,
          ),
          selectedColor: const Color(0xFF5C4BFF),
          backgroundColor: Colors.white,
          onSelected: (_) => onSelected(category),
        );
      },
    );
  }

  String _labelFor(ProductCategory category) {
    return switch (category) {
      ProductCategory.all => 'All',
      ProductCategory.electronics => 'Electronics',
      ProductCategory.jewelry => 'Jewelry',
      ProductCategory.mensClothing => "Men's clothing",
      ProductCategory.womensClothing => "Women's clothing",
    };
  }
}
