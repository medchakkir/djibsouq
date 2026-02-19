import 'package:flutter/material.dart';
import 'package:dj/data/product_repository.dart';
import 'package:dj/widgets/web_header.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightBlueBg = Color(0xFFE8F1FF);

class CategoriesWeb extends StatelessWidget {
  const CategoriesWeb({super.key});

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
      backgroundColor: lightBlueBg,
      body: Column(
        children: [
          buildHeader(currentPage: "Categories"),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // TITRE
                    const Text(
                      "Découvrez toutes nos catégories",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Trouvez tout ce dont vous avez besoin !",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 50),

                    // GRID PRINCIPALE
                    LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = 3;
                        double aspectRatio = 1.2;

                        if (constraints.maxWidth < 900) {
                          crossAxisCount = 2;
                          aspectRatio = 1;
                        }
                        if (constraints.maxWidth < 600) {
                          crossAxisCount = 1;
                          aspectRatio = 1.5;
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: categories.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 30,
                            mainAxisSpacing: 30,
                            childAspectRatio: aspectRatio,
                          ),
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return _buildHybridCard(
                              name: category.name,
                              icon: _getIcon(category.icon),
                              imageUrl: category.image,
                              description: category.description ?? "",
                              onTap: () {},
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 40),

                    // CATÉGORIES POPULAIRES
                    const Text(
                      "Catégories Populaires",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 120,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...List.generate(categories.length, (index) {
                              final cat = categories[index];
                              final List<Color> popularColors = [
                                Colors.blue,
                                Colors.green,
                                Colors.orange,
                                Colors.purple,
                                Colors.red,
                                Colors.teal,
                                Colors.amber,
                                Colors.indigo,
                              ];
                              final color = popularColors[index % popularColors.length];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                            color: color.withOpacity(0.3),
                                            width: 2),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          _getIcon(cat.icon),
                                          color: color,
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        cat.name,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: color,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),

                    // CTA
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        "Explorer DJIBSOUQ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),

                    const SizedBox(height: 60),

                    // FOOTER
                    _buildFooterAmazonStyle(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHybridCard({
    required String name,
    required IconData icon,
    required String imageUrl,
    required String description,
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
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // IMAGE
                Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
                  return Container(color: primaryBlue.withOpacity(0.1));
                }),

                // OVERLAY DÉGRADÉ
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                    ),
                  ),
                ),

                // CONTENU
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      if (description.isNotEmpty)
                        Text(description,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Explorer",
                            style: TextStyle(color: Colors.black87)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterAmazonStyle() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("DJIBSOUQ",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22)),
                    SizedBox(height: 10),
                    Text(
                        "Marketplace moderne pour découvrir les meilleurs produits.",
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Quick Links",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const SizedBox(height: 12),
                    ...["Home", "Categories", "Best Sellers", "Featured", "Contact"]
                        .map(
                      (link) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(link,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    ...[Icons.facebook, Icons.camera_alt, Icons.chat, Icons.video_call]
                        .map(
                      (icon) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white24,
                            child: Icon(icon, color: Colors.white, size: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Divider(color: Colors.white24),
          const SizedBox(height: 15),
          const Center(
              child: Text("© 2026 DJIBSOUQ. Tous droits réservés.",
                  style: TextStyle(color: Colors.white60, fontSize: 13))),
        ],
      ),
    );
  }
}
