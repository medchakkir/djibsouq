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
    Product(
      id: 1,
      title: "Smart Watch",
      price: 79,
      image: "https://via.placeholder.com/150",
      category: "Électronique",
      description: "High quality smart watch",
    ),
    Product(
      id: 2,
      title: "T-Shirt Nike",
      price: 29,
      image: "https://via.placeholder.com/150",
      category: "Vêtements",
      description: "Original cotton T-shirt",
    ),
    Product(
      id: 3,
      title: "Sofa Modern",
      price: 299,
      image: "https://via.placeholder.com/150",
      category: "Maison",
      description: "Comfortable modern sofa",
    ),
    Product(
      id: 4,
      title: "Football",
      price: 25,
      image: "https://via.placeholder.com/150",
      category: "Sports",
      description: "Professional football",
    ),
  ];

  static List<Product> getProductsByCategory(String categoryName) {
    return products
        .where((product) => product.category == categoryName)
        .toList();
  }
}
