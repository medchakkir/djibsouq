import 'package:flutter/material.dart';
import 'package:dj/models/product_models.dart';
import 'product_card.dart';

const Color primaryBlue = Color(0xFF1E3A8A);

class ProductsHorizontalList extends StatelessWidget {
  final List<Product> products;
  final String title;
  final Function(Product)? onProductTap;
  final Widget Function(Product)? detailPageBuilder;

  const ProductsHorizontalList({
    required this.products,
    required this.title,
    this.onProductTap,
    this.detailPageBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, index) {
              return ProductCard(
                product: products[index],
                onTap: () {
                  if (detailPageBuilder != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => detailPageBuilder!(products[index]),
                      ),
                    );
                  } else if (onProductTap != null) {
                    onProductTap!(products[index]);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
