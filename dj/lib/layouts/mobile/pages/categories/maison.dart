import 'package:flutter/material.dart';
import '../detail_product.dart';
import '../products.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFE5E7EB);

class MaisonPage extends StatelessWidget {
  const MaisonPage({super.key});

  // 🏠 Liste des produits maison
  static const List<Map<String, dynamic>> products = [
    {
      'id': 201,
      'name': 'Canapé 3 places',
      'price': 899.99,
      'rating': 4.6,
      'icon': Icons.weekend,
    },
    {
      'id': 202,
      'name': 'Table à manger',
      'price': 599.99,
      'rating': 4.5,
      'icon': Icons.table_bar,
    },
    {
      'id': 203,
      'name': 'Lampe décorative',
      'price': 89.99,
      'rating': 4.4,
      'icon': Icons.lightbulb_outline,
    },
    {
      'id': 204,
      'name': 'Tapis moderne',
      'price': 149.99,
      'rating': 4.3,
      'icon': Icons.layers,
    },
    {
      'id': 205,
      'name': 'Rideaux élégants',
      'price': 69.99,
      'rating': 4.2,
      'icon': Icons.curtains,
    },
    {
      'id': 206,
      'name': 'Étagère murale',
      'price': 129.99,
      'rating': 4.5,
      'icon': Icons.view_quilt,
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
          'Maison',
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
                category: 'Maison',
                price: product['price'],
                rating: product['rating'],
                image: '🏠',
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
