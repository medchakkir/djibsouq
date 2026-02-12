import 'package:flutter/material.dart';
import 'detail_product.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFE5E7EB);

// Modèle de produit
class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final String image;
  final int reviews;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.image,
    required this.reviews,
  });
}

// Données des produits optimisées - Pas créées au démarrage!
class ProductsData {
  // Cache pour stocker les produits chargés
  static final Map<String, List<Product>> _cache = {};

  // Données brutes (pas d'objets Product créés au démarrage)
  static const List<Map<String, dynamic>> _productMaps = [
    // Électronique (4 produits principaux)
    {
      'id': '1',
      'name': 'iPhone 15 Pro',
      'category': 'Électronique',
      'price': 999.99,
      'rating': 4.8,
      'icon': '📱',
      'reviews': 256,
    },
    {
      'id': '2',
      'name': 'Samsung Galaxy Buds',
      'category': 'Électronique',
      'price': 149.99,
      'rating': 4.6,
      'icon': '🎧',
      'reviews': 128,
    },
    {
      'id': '3',
      'name': 'Laptop ASUS',
      'category': 'Électronique',
      'price': 1299.99,
      'rating': 4.7,
      'icon': '💻',
      'reviews': 89,
    },
    {
      'id': '4',
      'name': 'iPad Air',
      'category': 'Électronique',
      'price': 599.99,
      'rating': 4.9,
      'icon': '📱',
      'reviews': 342,
    },
    // Vêtements (4 produits)
    {
      'id': '5',
      'name': 'T-Shirt Nike',
      'category': 'Vêtements',
      'price': 49.99,
      'rating': 4.5,
      'icon': '👕',
      'reviews': 512,
    },
    {
      'id': '6',
      'name': 'Jeans Levi\'s',
      'category': 'Vêtements',
      'price': 79.99,
      'rating': 4.6,
      'icon': '👖',
      'reviews': 321,
    },
    {
      'id': '7',
      'name': 'Veste Adidas',
      'category': 'Vêtements',
      'price': 129.99,
      'rating': 4.4,
      'icon': '🧥',
      'reviews': 198,
    },
    {
      'id': '8',
      'name': 'Chaussures Puma',
      'category': 'Vêtements',
      'price': 99.99,
      'rating': 4.7,
      'icon': '👟',
      'reviews': 267,
    },
    // Maison (4 produits)
    {
      'id': '9',
      'name': 'Lampe LED',
      'category': 'Maison',
      'price': 39.99,
      'rating': 4.6,
      'icon': '💡',
      'reviews': 145,
    },
    {
      'id': '10',
      'name': 'Canapé Moderne',
      'category': 'Maison',
      'price': 599.99,
      'rating': 4.8,
      'icon': '🛋️',
      'reviews': 87,
    },
    {
      'id': '11',
      'name': 'Tapis Persan',
      'category': 'Maison',
      'price': 199.99,
      'rating': 4.5,
      'icon': '🧶',
      'reviews': 63,
    },
    {
      'id': '12',
      'name': 'Tableau Déco',
      'category': 'Maison',
      'price': 89.99,
      'rating': 4.4,
      'icon': '🖼️',
      'reviews': 112,
    },
    // Sports (4 produits)
    {
      'id': '13',
      'name': 'Ballon de Foot',
      'category': 'Sports',
      'price': 59.99,
      'rating': 4.7,
      'icon': '⚽',
      'reviews': 234,
    },
    {
      'id': '14',
      'name': 'Raquette Tennis',
      'category': 'Sports',
      'price': 149.99,
      'rating': 4.6,
      'icon': '🎾',
      'reviews': 89,
    },
    {
      'id': '15',
      'name': 'Haltères',
      'category': 'Sports',
      'price': 299.99,
      'rating': 4.8,
      'icon': '🏋️',
      'reviews': 156,
    },
    {
      'id': '16',
      'name': 'Tapis Yoga',
      'category': 'Sports',
      'price': 39.99,
      'rating': 4.5,
      'icon': '🧘',
      'reviews': 203,
    },
  ];

  // ✔️ LAZY LOADING: Convertit les maps en Product objects uniquement au besoin
  static List<Product> getProductsByCategory(String category) {
    // Première vérification du cache
    if (_cache.containsKey(category)) {
      return _cache[category]!;
    }

    // Filtrer et créer les products uniquement pour cette catégorie
    final products = _productMaps
        .where((p) => p['category'] == category)
        .map((p) => Product(
              id: p['id'] as String,
              name: p['name'] as String,
              category: p['category'] as String,
              price: p['price'] as double,
              rating: p['rating'] as double,
              image: p['icon'] as String,
              reviews: p['reviews'] as int,
            ))
        .toList();

    // Mémoriser dans le cache
    _cache[category] = products;
    return products;
  }

  // Obtain popular products (only first 4)
  static List<Product> getPopularProducts() {
    return getProductsByCategory('Électronique').take(4).toList();
  }

  // Obtain all products (rare usage - loads everything)
  static List<Product> getAllProducts() {
    final allProducts = <Product>[];
    final categories = _productMaps.map((p) => p['category']).toSet();
    for (final category in categories) {
      allProducts.addAll(getProductsByCategory(category));
    }
    return allProducts;
  }
}

// Widget pour afficher une carte produit
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({required this.product, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cardGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: cardGrey,
                    child: Center(
                      child: Text(
                        product.image,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 12, color: Colors.amber),
                const SizedBox(width: 2),
                Text(
                  '${product.rating}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget pour afficher une liste de produits horizontale
class ProductsHorizontalList extends StatelessWidget {
  final List<Product> products;
  final String title;

  const ProductsHorizontalList({
    required this.products,
    required this.title,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailProductPage(product: products[index]),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
