import 'package:flutter/material.dart';
import 'package:dj/models/product_models.dart';
import 'package:dj/models/category_models.dart';


class ProductRepository {
  static List<Category> categories = [
    Category(
      id: 1,
      name: "Électronique",
      image: "https://via.placeholder.com/400x300/3B82F6/FFFFFF?text=Electronique",
      icon: "devices",
      color: const Color(0xFF3B82F6),
    ),
    Category(
      id: 2,
      name: "Vêtements",
      image: "https://via.placeholder.com/400x300/EC4899/FFFFFF?text=Vetements",
      icon: "shopping_bag",
      color: const Color(0xFFEC4899),
    ),
    Category(
      id: 3,
      name: "Maison",
      image: "https://via.placeholder.com/400x300/10B981/FFFFFF?text=Maison",
      icon: "home",
      color: const Color(0xFF10B981),
    ),
    Category(
      id: 4,
      name: "Sports",
      image: "https://via.placeholder.com/400x300/F59E0B/FFFFFF?text=Sports",
      icon: "sports_soccer",
      color: const Color(0xFFF59E0B),
    ),
  ];

  static List<Product> products = [
    // Électronique (4 produits)
    Product(
      id: 1,
      title: "iPhone 15 Pro",
      price: 999.99,
      image: "📱",
      category: "Électronique",
      description: "Latest iPhone with amazing features",
      rating: 4.8,
      reviews: 256,
    ),
    Product(
      id: 2,
      title: "Samsung Galaxy Buds",
      price: 149.99,
      image: "🎧",
      category: "Électronique",
      description: "Premium wireless earbuds",
      rating: 4.6,
      reviews: 128,
    ),
    Product(
      id: 3,
      title: "Laptop ASUS",
      price: 1299.99,
      image: "💻",
      category: "Électronique",
      description: "Powerful laptop for work and gaming",
      rating: 4.7,
      reviews: 89,
    ),
    Product(
      id: 4,
      title: "iPad Air",
      price: 599.99,
      image: "📱",
      category: "Électronique",
      description: "Perfect tablet for creativity",
      rating: 4.9,
      reviews: 342,
    ),
    // Vêtements (4 produits)
    Product(
      id: 5,
      title: "T-Shirt Nike",
      price: 49.99,
      image: "👕",
      category: "Vêtements",
      description: "Comfortable cotton T-shirt",
      rating: 4.5,
      reviews: 512,
    ),
    Product(
      id: 6,
      title: "Jeans Levi's",
      price: 79.99,
      image: "👖",
      category: "Vêtements",
      description: "Classic denim jeans",
      rating: 4.6,
      reviews: 321,
    ),
    Product(
      id: 7,
      title: "Veste Adidas",
      price: 129.99,
      image: "🧥",
      category: "Vêtements",
      description: "Stylish sports jacket",
      rating: 4.4,
      reviews: 198,
    ),
    Product(
      id: 8,
      title: "Chaussures Puma",
      price: 99.99,
      image: "👟",
      category: "Vêtements",
      description: "Professional running shoes",
      rating: 4.7,
      reviews: 267,
    ),
    // Maison (4 produits)
    Product(
      id: 9,
      title: "Lampe LED",
      price: 39.99,
      image: "💡",
      category: "Maison",
      description: "Modern LED lighting solution",
      rating: 4.6,
      reviews: 145,
    ),
    Product(
      id: 10,
      title: "Canapé Moderne",
      price: 599.99,
      image: "🛋️",
      category: "Maison",
      description: "Comfortable modern sofa",
      rating: 4.8,
      reviews: 87,
    ),
    Product(
      id: 11,
      title: "Tapis Persan",
      price: 199.99,
      image: "🧶",
      category: "Maison",
      description: "Traditional Persian carpet",
      rating: 4.5,
      reviews: 63,
    ),
    Product(
      id: 12,
      title: "Tableau Déco",
      price: 89.99,
      image: "🖼️",
      category: "Maison",
      description: "Decorative wall painting",
      rating: 4.4,
      reviews: 112,
    ),
    // Sports (4 produits)
    Product(
      id: 13,
      title: "Ballon de Foot",
      price: 59.99,
      image: "⚽",
      category: "Sports",
      description: "Professional football",
      rating: 4.7,
      reviews: 234,
    ),
    Product(
      id: 14,
      title: "Raquette Tennis",
      price: 149.99,
      image: "🎾",
      category: "Sports",
      description: "High-performance tennis racket",
      rating: 4.6,
      reviews: 89,
    ),
    Product(
      id: 15,
      title: "Haltères",
      price: 299.99,
      image: "🏋️",
      category: "Sports",
      description: "Adjustable dumbbells set",
      rating: 4.8,
      reviews: 156,
    ),
    Product(
      id: 16,
      title: "Tapis Yoga",
      price: 39.99,
      image: "🧘",
      category: "Sports",
      description: "Premium yoga mat",
      rating: 4.5,
      reviews: 203,
    ),
  ];

  static List<Product> getProductsByCategory(String categoryName) {
    return products
        .where((product) => product.category == categoryName)
        .toList();
  }

  static List<Product> getPopularProducts({int limit = 4}) {
    return products
        .where((p) => p.category == "Électronique")
        .take(limit)
        .toList();
  }

  static List<Product> getAllProducts() {
    return products;
  }

  static Product? getProductById(int id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
