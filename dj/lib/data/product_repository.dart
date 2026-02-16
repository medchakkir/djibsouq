import 'package:flutter/material.dart';
import 'package:dj/models/product_models.dart';
import 'package:dj/models/category_models.dart';


class ProductRepository {
  static List<Category> categories = [
    Category(
    id: 0,
    name: "New Arrivals",
    image: "https://via.placeholder.com/400x300/3B82F6/FFFFFF?text=New+Arrivals",
    icon: "stars", // icône spécifique
    color: const Color(0xFF3B82F6),
  ),
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
      category: "New Arrivals",
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
  Product(id: 17, title: "Apple Watch", price: 399.99, image: "⌚", category: "Électronique", description: "Smartwatch with fitness tracking", rating: 4.7, reviews: 210),
  Product(id: 18, title: "Google Pixel 8", price: 899.99, image: "📱", category: "Électronique", description: "Latest Google phone with clean Android", rating: 4.6, reviews: 145),
  Product(id: 19, title: "Bose QC45", price: 329.99, image: "🎧", category: "Électronique", description: "Noise-cancelling headphones", rating: 4.8, reviews: 180),
  Product(id: 20, title: "MacBook Pro", price: 2399.99, image: "💻", category: "Électronique", description: "High-performance laptop", rating: 4.9, reviews: 95),
  Product(id: 21, title: "Kindle Paperwhite", price: 129.99, image: "📚", category: "Électronique", description: "E-reader with adjustable light", rating: 4.7, reviews: 112),
  Product(id: 22, title: "GoPro Hero 12", price: 499.99, image: "📷", category: "Électronique", description: "Action camera for adventure", rating: 4.8, reviews: 78),
  Product(id: 23, title: "Samsung Galaxy Watch", price: 349.99, image: "⌚", category: "Électronique", description: "Smartwatch with health tracking", rating: 4.6, reviews: 101),
  Product(id: 24, title: "Sony WH-1000XM5", price: 379.99, image: "🎧", category: "Électronique", description: "Top-notch wireless headphones", rating: 4.9, reviews: 132),
  Product(id: 25, title: "iMac 24\"", price: 1599.99, image: "💻", category: "Électronique", description: "All-in-one desktop computer", rating: 4.8, reviews: 67),
  Product(id: 26, title: "DJI Mini 4 Pro", price: 799.99, image: "🛸", category: "Électronique", description: "Compact drone with 4K camera", rating: 4.7, reviews: 88),
  Product(id: 27, title: "Echo Dot 5", price: 59.99, image: "🔊", category: "Électronique", description: "Smart speaker with Alexa", rating: 4.5, reviews: 201),
  Product(id: 28, title: "Fitbit Charge 6", price: 149.99, image: "⌚", category: "Électronique", description: "Fitness tracker with heart monitor", rating: 4.6, reviews: 153),
  Product(id: 29, title: "Nintendo Switch OLED", price: 349.99, image: "🎮", category: "Électronique", description: "Portable gaming console", rating: 4.9, reviews: 310),
  Product(id: 30, title: "Roku Streaming Stick", price: 49.99, image: "📺", category: "Électronique", description: "Streaming device for smart TVs", rating: 4.5, reviews: 98),
  Product(id: 31, title: "Logitech MX Master 3", price: 99.99, image: "🖱️", category: "Électronique", description: "Ergonomic wireless mouse", rating: 4.8, reviews: 145),
  Product(id: 32, title: "Anker Power Bank", price: 39.99, image: "🔋", category: "Électronique", description: "High-capacity portable charger", rating: 4.6, reviews: 176),
  Product(id: 33, title: "Samsung SSD 1TB", price: 129.99, image: "💾", category: "Électronique", description: "Fast internal storage", rating: 4.7, reviews: 67),
  Product(id: 34, title: "Canon EOS R10", price: 1199.99, image: "📷", category: "Électronique", description: "Mirrorless camera for photography", rating: 4.8, reviews: 53),
  Product(id: 35, title: "Apple AirPods Max", price: 549.99, image: "🎧", category: "Électronique", description: "Premium over-ear headphones", rating: 4.9, reviews: 102),
  Product(id: 36, title: "Raspberry Pi 5", price: 89.99, image: "🖥️", category: "Électronique", description: "Mini computer for projects", rating: 4.7, reviews: 87),

  // Vêtements (20 produits supplémentaires)
  Product(id: 37, title: "Pull H&M", price: 59.99, image: "🧥", category: "Vêtements", description: "Warm and stylish sweater", rating: 4.5, reviews: 143),
  Product(id: 38, title: "Casquette New Era", price: 29.99, image: "🧢", category: "Vêtements", description: "Classic baseball cap", rating: 4.4, reviews: 98),
  Product(id: 39, title: "Robe Zara", price: 79.99, image: "👗", category: "Vêtements", description: "Elegant evening dress", rating: 4.6, reviews: 111),
  Product(id: 40, title: "Short Puma", price: 39.99, image: "🩳", category: "Vêtements", description: "Light sports shorts", rating: 4.5, reviews: 76),
  Product(id: 41, title: "Veste North Face", price: 199.99, image: "🧥", category: "Vêtements", description: "Waterproof outdoor jacket", rating: 4.7, reviews: 65),
  Product(id: 42, title: "Sweatshirt Adidas", price: 89.99, image: "👕", category: "Vêtements", description: "Comfortable casual hoodie", rating: 4.6, reviews: 120),
  Product(id: 43, title: "Chaussures Nike Air", price: 129.99, image: "👟", category: "Vêtements", description: "Trendy running sneakers", rating: 4.8, reviews: 98),
  Product(id: 44, title: "Jean Skinny", price: 69.99, image: "👖", category: "Vêtements", description: "Slim fit jeans", rating: 4.5, reviews: 112),
  Product(id: 45, title: "Manteau Mango", price: 149.99, image: "🧥", category: "Vêtements", description: "Stylish winter coat", rating: 4.7, reviews: 77),
  Product(id: 46, title: "T-shirt Gap", price: 34.99, image: "👕", category: "Vêtements", description: "Casual cotton T-shirt", rating: 4.4, reviews: 142),
  Product(id: 47, title: "Baskets Converse", price: 79.99, image: "👟", category: "Vêtements", description: "Classic high-top sneakers", rating: 4.6, reviews: 125),
  Product(id: 48, title: "Pantalon Chino", price: 59.99, image: "👖", category: "Vêtements", description: "Smart casual chinos", rating: 4.5, reviews: 95),
  Product(id: 49, title: "Legging Sport", price: 49.99, image: "🩳", category: "Vêtements", description: "High-performance leggings", rating: 4.7, reviews: 123),
  Product(id: 50, title: "Chemise Ralph Lauren", price: 129.99, image: "👔", category: "Vêtements", description: "Elegant formal shirt", rating: 4.8, reviews: 88),
  Product(id: 51, title: "Veste en cuir", price: 199.99, image: "🧥", category: "Vêtements", description: "Classic leather jacket", rating: 4.9, reviews: 70),
  Product(id: 52, title: "Pull Col V", price: 59.99, image: "🧥", category: "Vêtements", description: "V-neck stylish sweater", rating: 4.6, reviews: 105),
  Product(id: 53, title: "T-shirt Oversize", price: 39.99, image: "👕", category: "Vêtements", description: "Trendy oversized tee", rating: 4.5, reviews: 140),
  Product(id: 54, title: "Short de Bain", price: 29.99, image: "🩳", category: "Vêtements", description: "Comfortable swim shorts", rating: 4.6, reviews: 92),
  Product(id: 55, title: "Chaussettes Sport", price: 12.99, image: "🧦", category: "Vêtements", description: "Soft athletic socks", rating: 4.5, reviews: 152),
  Product(id: 56, title: "Bonnet Hiver", price: 19.99, image: "🧢", category: "Vêtements", description: "Warm winter hat", rating: 4.4, reviews: 130),

  // Maison (20 produits supplémentaires)
  Product(id: 57, title: "Cafetière Nespresso", price: 199.99, image: "☕", category: "Maison", description: "Espresso machine for home", rating: 4.8, reviews: 102),
  Product(id: 58, title: "Aspirateur Dyson", price: 399.99, image: "🧹", category: "Maison", description: "High-efficiency vacuum cleaner", rating: 4.9, reviews: 87),
  Product(id: 59, title: "Oreiller Mémoire", price: 59.99, image: "🛏️", category: "Maison", description: "Comfortable memory foam pillow", rating: 4.7, reviews: 134),
  Product(id: 60, title: "Plaid Douillet", price: 39.99, image: "🛋️", category: "Maison", description: "Warm soft blanket", rating: 4.6, reviews: 101),
  Product(id: 61, title: "Rideaux Occultants", price: 69.99, image: "🪟", category: "Maison", description: "Block light efficiently", rating: 4.5, reviews: 78),
  Product(id: 62, title: "Service Vaisselle", price: 89.99, image: "🍽️", category: "Maison", description: "Elegant dinnerware set", rating: 4.7, reviews: 65),
  Product(id: 63, title: "Bougie Parfumée", price: 29.99, image: "🕯️", category: "Maison", description: "Scented decorative candle", rating: 4.6, reviews: 112),
  Product(id: 64, title: "Horloge Murale", price: 49.99, image: "🕰️", category: "Maison", description: "Stylish wall clock", rating: 4.5, reviews: 80),
  Product(id: 65, title: "Étagère Bois", price: 129.99, image: "🪵", category: "Maison", description: "Solid wooden shelf", rating: 4.7, reviews: 92),
  Product(id: 66, title: "Coussin Déco", price: 24.99, image: "🛋️", category: "Maison", description: "Decorative soft pillow", rating: 4.6, reviews: 115),
  Product(id: 67, title: "Table Basse", price: 149.99, image: "🛋️", category: "Maison", description: "Modern living room table", rating: 4.7, reviews: 73),
  Product(id: 68, title: "Chaise Design", price: 89.99, image: "🪑", category: "Maison", description: "Comfortable stylish chair", rating: 4.6, reviews: 66),
  Product(id: 69, title: "Vaisselle Quotidienne", price: 39.99, image: "🍽️", category: "Maison", description: "Everyday use dinnerware", rating: 4.5, reviews: 101),
  Product(id: 70, title: "Panier Rangement", price: 29.99, image: "🧺", category: "Maison", description: "Basket for home organization", rating: 4.6, reviews: 120),
  Product(id: 71, title: "Plante Artificielle", price: 49.99, image: "🌿", category: "Maison", description: "Decorative artificial plant", rating: 4.5, reviews: 85),
  Product(id: 72, title: "Support TV", price: 129.99, image: "📺", category: "Maison", description: "TV stand for living room", rating: 4.7, reviews: 74),
  Product(id: 73, title: "Linge de Lit", price: 99.99, image: "🛏️", category: "Maison", description: "Soft cotton bed sheets", rating: 4.8, reviews: 98),
  Product(id: 74, title: "Miroir Mural", price: 69.99, image: "🪞", category: "Maison", description: "Decorative wall mirror", rating: 4.6, reviews: 82),
  Product(id: 75, title: "Lampe de Chevet", price: 39.99, image: "💡", category: "Maison", description: "Bedside table lamp", rating: 4.5, reviews: 110),
  Product(id: 76, title: "Tapis Moderne", price: 129.99, image: "🧶", category: "Maison", description: "Stylish floor rug", rating: 4.7, reviews: 90),

  // Sports (20 produits supplémentaires)
  Product(id: 77, title: "Vélo de Route", price: 899.99, image: "🚴", category: "Sports", description: "Lightweight racing bike", rating: 4.8, reviews: 56),
  Product(id: 78, title: "Casque Vélo", price: 79.99, image: "⛑️", category: "Sports", description: "Safety cycling helmet", rating: 4.7, reviews: 88),
  Product(id: 79, title: "Ballon Basket", price: 49.99, image: "🏀", category: "Sports", description: "Official size basketball", rating: 4.6, reviews: 103),
  Product(id: 80, title: "Gants Boxe", price: 69.99, image: "🥊", category: "Sports", description: "Professional boxing gloves", rating: 4.7, reviews: 74),
  Product(id: 81, title: "Tapis Course", price: 799.99, image: "🏃", category: "Sports", description: "Electric treadmill", rating: 4.8, reviews: 52),
  Product(id: 82, title: "Raquettes Ping-Pong", price: 39.99, image: "🏓", category: "Sports", description: "Table tennis set", rating: 4.5, reviews: 91),
  Product(id: 83, title: "Haltères 10kg", price: 49.99, image: "🏋️", category: "Sports", description: "Adjustable dumbbells pair", rating: 4.6, reviews: 77),
  Product(id: 84, title: "Sac de Sport", price: 59.99, image: "🎒", category: "Sports", description: "Durable sports bag", rating: 4.5, reviews: 125),
  Product(id: 85, title: "Bande Élastique", price: 19.99, image: "🟢", category: "Sports", description: "Resistance bands for training", rating: 4.6, reviews: 142),
  Product(id: 86, title: "Gourde Sport", price: 14.99, image: "🥤", category: "Sports", description: "Reusable water bottle", rating: 4.7, reviews: 160),
  Product(id: 87, title: "Tapis Pilates", price: 59.99, image: "🧘", category: "Sports", description: "High-quality Pilates mat", rating: 4.6, reviews: 88),
  Product(id: 88, title: "Short Fitness", price: 34.99, image: "🩳", category: "Sports", description: "Breathable training shorts", rating: 4.5, reviews: 94),
  Product(id: 89, title: "Maillot Natation", price: 49.99, image: "🏊", category: "Sports", description: "Swimming suit for training", rating: 4.6, reviews: 102),
  Product(id: 90, title: "Corde à Sauter", price: 19.99, image: "🪢", category: "Sports", description: "Speed jump rope", rating: 4.5, reviews: 134),
  Product(id: 91, title: "Gants Fitness", price: 29.99, image: "🥊", category: "Sports", description: "Workout gloves", rating: 4.6, reviews: 117),
  Product(id: 92, title: "Vélo d’Appartement", price: 499.99, image: "🚴", category: "Sports", description: "Stationary exercise bike", rating: 4.7, reviews: 65),
  Product(id: 93, title: "Sac de Boxe", price: 129.99, image: "🥊", category: "Sports", description: "Durable punching bag", rating: 4.6, reviews: 74),
  Product(id: 94, title: "Ballon Volley", price: 39.99, image: "🏐", category: "Sports", description: "Professional volleyball", rating: 4.7, reviews: 82),
  Product(id: 95, title: "Raquettes Badminton", price: 49.99, image: "🏸", category: "Sports", description: "High-quality badminton set", rating: 4.6, reviews: 93),
  Product(id: 96, title: "Élastiques Yoga", price: 24.99, image: "🟢", category: "Sports", description: "Resistance bands for yoga", rating: 4.5, reviews: 121),
  Product(id: 97, title: "Casque Ski", price: 89.99, image: "🎿", category: "Sports", description: "Safety helmet for skiing", rating: 4.6, reviews: 60),
  Product(id: 98, title: "Lunettes Natation", price: 19.99, image: "🥽", category: "Sports", description: "Swim goggles", rating: 4.5, reviews: 108),
  Product(id: 99, title: "Tapis Escalade", price: 149.99, image: "🧗", category: "Sports", description: "Safety crash pad for climbing", rating: 4.7, reviews: 56),
  Product(id: 100, title: "Montre Sport", price: 199.99, image: "⌚", category: "Sports", description: "Multifunctional sports watch", rating: 4.8, reviews: 75),
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
