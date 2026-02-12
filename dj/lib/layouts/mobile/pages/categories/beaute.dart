import 'package:flutter/material.dart';
import '../detail_product.dart';
import '../products.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFE5E7EB);

class BeautePage extends StatelessWidget {
  const BeautePage({super.key});

  // 💄 Liste des produits beauté
  static const List<Map<String, dynamic>> products = [
    {
      'id': 501,
      'name': 'Parfum Femme',
      'price': 79.99,
      'rating': 4.7,
      'icon': Icons.local_florist,
    },
    {
      'id': 502,
      'name': 'Parfum Homme',
      'price': 84.99,
      'rating': 4.6,
      'icon': Icons.local_florist,
    },
    {
      'id': 503,
      'name': 'Crème hydratante',
      'price': 29.99,
      'rating': 4.5,
      'icon': Icons.spa,
    },
    {
      'id': 504,
      'name': 'Maquillage complet',
      'price': 59.99,
      'rating': 4.4,
      'icon': Icons.brush,
    },
    {
      'id': 505,
      'name': 'Shampoing naturel',
      'price': 19.99,
      'rating': 4.3,
      'icon': Icons.opacity,
    },
    {
      'id': 506,
      'name': 'Huile essentielle',
      'price': 24.99,
      'rating': 4.6,
      'icon': Icons.water_drop,
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
          'Beauté',
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
                category: 'Beauté',
                price: product['price'],
                rating: product['rating'],
                image: '💄',
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
