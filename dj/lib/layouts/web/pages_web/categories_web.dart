
import 'package:flutter/material.dart';
import 'package:dj/data/product_repository.dart';
import 'package:dj/widgets/web_header.dart';

const Color primaryBlue = Color(0xFF1E3A8A);

class CategoriesWeb extends StatelessWidget {
  const CategoriesWeb({super.key});

  // Fonction pour récupérer l'icône depuis le nom
  static IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'devices':
        return Icons.devices;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'home':
        return Icons.home;
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'library_books':
        return Icons.library_books;
      case 'spa':
        return Icons.spa;
      case 'key':
        return Icons.key;
      case 'build':
        return Icons.build;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ProductRepository.categories;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          buildHeader(currentPage: "Categories"),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1300),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
                  child: Column(
                    children: [
                      /// TITRE
                      const Text(
                        "Explore Our Categories",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 70),
                      /// GRID
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 4;

                      if (constraints.maxWidth < 1100) crossAxisCount = 3;
                      if (constraints.maxWidth < 800) crossAxisCount = 2;
                      if (constraints.maxWidth < 500) crossAxisCount = 1;

                      return GridView.builder(
                        itemCount: categories.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 30,
                          mainAxisSpacing: 30,
                          childAspectRatio: 1.1,
                        ),
                        itemBuilder: (context, index) {
                          final category = categories[index];

                          return _buildCategoryCard(
                            name: category.name,
                            icon: _getIcon(category.icon),
                            color: category.color,
                            imageUrl: category.image,
                            onTap: () {},
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
        ],
    ),
    );
  }

  /// Carte individuelle pour chaque catégorie
  Widget _buildCategoryCard({
    required String name,
    required IconData icon,
    required Color color,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image en arrière-plan
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: color.withOpacity(0.1),
                      child: Icon(icon, size: 48, color: color),
                    );
                  },
                ),
              ),
              // Overlay gradient
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                  ),
                ),
              ),
              // Contenu
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
