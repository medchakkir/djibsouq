import 'package:flutter/material.dart';
import '../detail_product.dart';
import '../products.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFE5E7EB);

class ElectronicsPage extends StatelessWidget {
  const ElectronicsPage({super.key});

  // 🔌 Liste des produits électroniques
  static const List<Map<String, dynamic>> products = [
    {
      'id': 1,
      'name': 'iPhone 14 Pro',
      'price': 1199.99,
      'rating': 4.8,
      'icon': Icons.phone_iphone,
    },
    {
      'id': 2,
      'name': 'Samsung Galaxy S23',
      'price': 999.99,
      'rating': 4.7,
      'icon': Icons.phone_android,
    },
    {
      'id': 3,
      'name': 'MacBook Air M2',
      'price': 1499.00,
      'rating': 4.9,
      'icon': Icons.laptop_mac,
    },
    {
      'id': 4,
      'name': 'Casque Sony WH-1000XM5',
      'price': 349.99,
      'rating': 4.6,
      'icon': Icons.headphones,
    },
    {
      'id': 5,
      'name': 'Apple Watch Series 9',
      'price': 429.99,
      'rating': 4.5,
      'icon': Icons.watch,
    },
    {
      'id': 6,
      'name': 'Télévision Smart 4K',
      'price': 799.99,
      'rating': 4.4,
      'icon': Icons.tv,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Électronique',
          style: TextStyle(
            color: primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildProductCard(context, product);
        },
      ),
    );
  }

  // 🧱 Carte produit
  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icône produit
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(product['icon'], size: 40, color: primaryBlue),
          ),
          const SizedBox(width: 16),

          // Infos produit
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primaryBlue,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      product['rating'].toString(),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${product['price']} \$',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Bouton voir détails
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: primaryBlue),
            onPressed: () {
              final detailProduct = Product(
                id: product['id'].toString(),
                name: product['name'],
                category: 'Électronique',
                price: product['price'],
                rating: product['rating'],
                image: '📱',
                reviews: 150,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailProductPage(product: detailProduct),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
