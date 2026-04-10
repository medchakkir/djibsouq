import 'package:flutter/material.dart';

import '../models/product_models.dart';

import '../layouts/web/pages_web/detail_product_popup.dart';

import 'hover_scale_card.dart';

const Color primaryBlue = Color(0xFF1E3A8A);

class BestSellerCard extends StatelessWidget {
  final Product product;
  const BestSellerCard({required this.product});

  void _openDetail(BuildContext context) {
    DetailProductPopup.show(context, product: product);
  }

  @override
  Widget build(BuildContext context) {
    return HoverScaleCard(
      onTap: () => _openDetail(context),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.85),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 10))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.redAccent, Colors.orange]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('HOT',
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              const Icon(Icons.favorite_border, size: 18, color: Colors.grey),
            ]),
            const SizedBox(height: 10),
            Expanded(child: Center(child: Text(product.image, style: const TextStyle(fontSize: 42)))),
            const SizedBox(height: 10),
            Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('\$${product.price}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: primaryBlue)),
              Container(
                decoration: BoxDecoration(color: primaryBlue, borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.shopping_cart, color: Colors.white, size: 16),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}