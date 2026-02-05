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

// Liste des produits par catégorie
class ProductsData {
  static final List<Product> products = [
    // Électronique
    Product(
      id: '1',
      name: 'iPhone 15 Pro',
      category: 'Électronique',
      price: 999.99,
      rating: 4.8,
      image:
          'https://via.placeholder.com/300x300/1E3A8A/FFFFFF?text=iPhone+15+Pro',
      reviews: 256,
    ),
    Product(
      id: '2',
      name: 'Samsung Galaxy Buds',
      category: 'Électronique',
      price: 149.99,
      rating: 4.6,
      image:
          'https://via.placeholder.com/300x300/1E3A8A/FFFFFF?text=Galaxy+Buds',
      reviews: 128,
    ),
    Product(
      id: '3',
      name: 'Laptop ASUS',
      category: 'Électronique',
      price: 1299.99,
      rating: 4.7,
      image:
          'https://via.placeholder.com/300x300/1E3A8A/FFFFFF?text=Laptop+ASUS',
      reviews: 89,
    ),
    Product(
      id: '4',
      name: 'iPad Air',
      category: 'Électronique',
      price: 599.99,
      rating: 4.9,
      image: 'https://via.placeholder.com/300x300/1E3A8A/FFFFFF?text=iPad+Air',
      reviews: 342,
    ),

    // Vêtements
    Product(
      id: '5',
      name: 'T-Shirt Nike',
      category: 'Vêtements',
      price: 49.99,
      rating: 4.5,
      image:
          'https://via.placeholder.com/300x300/EC4899/FFFFFF?text=T-Shirt+Nike',
      reviews: 512,
    ),
    Product(
      id: '6',
      name: 'Jeans Levi\'s',
      category: 'Vêtements',
      price: 79.99,
      rating: 4.6,
      image:
          'https://via.placeholder.com/300x300/EC4899/FFFFFF?text=Jeans+Levis',
      reviews: 321,
    ),
    Product(
      id: '7',
      name: 'Veste Adidas',
      category: 'Vêtements',
      price: 129.99,
      rating: 4.4,
      image:
          'https://via.placeholder.com/300x300/EC4899/FFFFFF?text=Veste+Adidas',
      reviews: 198,
    ),
    Product(
      id: '8',
      name: 'Chaussures Puma',
      category: 'Vêtements',
      price: 99.99,
      rating: 4.7,
      image:
          'https://via.placeholder.com/300x300/EC4899/FFFFFF?text=Chaussures+Puma',
      reviews: 267,
    ),

    // Maison
    Product(
      id: '9',
      name: 'Lampe LED',
      category: 'Maison',
      price: 39.99,
      rating: 4.6,
      image: 'https://via.placeholder.com/300x300/10B981/FFFFFF?text=Lampe+LED',
      reviews: 145,
    ),
    Product(
      id: '10',
      name: 'Canapé Moderne',
      category: 'Maison',
      price: 599.99,
      rating: 4.8,
      image:
          'https://via.placeholder.com/300x300/10B981/FFFFFF?text=Canape+Moderne',
      reviews: 87,
    ),
    Product(
      id: '11',
      name: 'Tapis Persan',
      category: 'Maison',
      price: 199.99,
      rating: 4.5,
      image:
          'https://via.placeholder.com/300x300/10B981/FFFFFF?text=Tapis+Persan',
      reviews: 63,
    ),
    Product(
      id: '12',
      name: 'Tableau Déco',
      category: 'Maison',
      price: 89.99,
      rating: 4.4,
      image:
          'https://via.placeholder.com/300x300/10B981/FFFFFF?text=Tableau+Deco',
      reviews: 112,
    ),

    // Sports
    Product(
      id: '13',
      name: 'Ballon de Foot',
      category: 'Sports',
      price: 59.99,
      rating: 4.7,
      image:
          'https://via.placeholder.com/300x300/F59E0B/FFFFFF?text=Ballon+Foot',
      reviews: 234,
    ),
    Product(
      id: '14',
      name: 'Raquette Tennis',
      category: 'Sports',
      price: 149.99,
      rating: 4.6,
      image:
          'https://via.placeholder.com/300x300/F59E0B/FFFFFF?text=Raquette+Tennis',
      reviews: 89,
    ),
    Product(
      id: '15',
      name: 'Haltères',
      category: 'Sports',
      price: 299.99,
      rating: 4.8,
      image: 'https://via.placeholder.com/300x300/F59E0B/FFFFFF?text=Halteres',
      reviews: 156,
    ),
    Product(
      id: '16',
      name: 'Tapis Yoga',
      category: 'Sports',
      price: 39.99,
      rating: 4.5,
      image:
          'https://via.placeholder.com/300x300/F59E0B/FFFFFF?text=Tapis+Yoga',
      reviews: 203,
    ),

    // Livres
    Product(
      id: '17',
      name: 'Le Seigneur des Anneaux',
      category: 'Livres',
      price: 29.99,
      rating: 4.9,
      image:
          'https://via.placeholder.com/300x300/8B5CF6/FFFFFF?text=Seigneur+Anneaux',
      reviews: 523,
    ),
    Product(
      id: '18',
      name: 'Harry Potter Tome 1',
      category: 'Livres',
      price: 24.99,
      rating: 4.8,
      image:
          'https://via.placeholder.com/300x300/8B5CF6/FFFFFF?text=Harry+Potter',
      reviews: 612,
    ),
    Product(
      id: '19',
      name: 'Sapiens',
      category: 'Livres',
      price: 32.99,
      rating: 4.7,
      image: 'https://via.placeholder.com/300x300/8B5CF6/FFFFFF?text=Sapiens',
      reviews: 378,
    ),
    Product(
      id: '20',
      name: 'Dune',
      category: 'Livres',
      price: 28.99,
      rating: 4.6,
      image: 'https://via.placeholder.com/300x300/8B5CF6/FFFFFF?text=Dune',
      reviews: 267,
    ),

    // Beauté
    Product(
      id: '21',
      name: 'Crème Hydratante',
      category: 'Beauté',
      price: 34.99,
      rating: 4.6,
      image:
          'https://via.placeholder.com/300x300/F43F5E/FFFFFF?text=Creme+Hydratante',
      reviews: 289,
    ),
    Product(
      id: '22',
      name: 'Shampoing Bio',
      category: 'Beauté',
      price: 19.99,
      rating: 4.5,
      image:
          'https://via.placeholder.com/300x300/F43F5E/FFFFFF?text=Shampoing+Bio',
      reviews: 167,
    ),
    Product(
      id: '23',
      name: 'Parfum Luxe',
      category: 'Beauté',
      price: 89.99,
      rating: 4.8,
      image:
          'https://via.placeholder.com/300x300/F43F5E/FFFFFF?text=Parfum+Luxe',
      reviews: 234,
    ),
    Product(
      id: '24',
      name: 'Maquillage',
      category: 'Beauté',
      price: 44.99,
      rating: 4.7,
      image:
          'https://via.placeholder.com/300x300/F43F5E/FFFFFF?text=Maquillage',
      reviews: 345,
    ),
  ];

  // Obtenir les produits d'une catégorie
  static List<Product> getProductsByCategory(String category) {
    return products.where((p) => p.category == category).toList();
  }

  // Obtenir les produits populaires (premiers 4)
  static List<Product> getPopularProducts() {
    return products.take(4).toList();
  }

  // Obtenir tous les produits
  static List<Product> getAllProducts() {
    return products;
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
                    child: const Center(
                      child: Icon(Icons.image, color: Colors.grey, size: 48),
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
