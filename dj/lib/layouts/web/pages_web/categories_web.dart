import 'package:flutter/material.dart';
import 'package:dj/data/product_repository.dart';
import '../home_web.dart';
import 'products_web.dart';
import 'cart_web.dart';
import 'favorites_web.dart';
import 'profile_web.dart';
import 'categories_web/electronique_web.dart';
import 'categories_web/vetements_web.dart';
import 'categories_web/maison_web.dart';
import 'categories_web/sports_web.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFFFFFFF);
const Color textDark = Color(0xFF111827);

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
      backgroundColor: lightGrey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildCategoriesList(categories),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomepageWeb()),
              );
            },
            child: Row(
              children: const [
                Icon(Icons.play_circle_fill, color: primaryBlue, size: 32),
                SizedBox(width: 8),
                Text("DJIBSOUQ",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue)),
              ],
            ),
          ),
          Row(
            children: [
              _NavItem("Home", onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomepageWeb()),
                );
              }),
              _NavItem("Categories", onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoriesWeb()),
                );
              }),
              _NavItem("Deals", onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductsWeb(),
                  ),
                );
              }),
              _NavItem("About", onTap: () {}),
              _NavItem("Contact", onTap: () {}),
              const SizedBox(width: 30),
              GestureDetector(
                onTap: () {},
                child: const Icon(Icons.search),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileWeb(),
                    ),
                  );
                },
                child: const Icon(Icons.person_outline),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesWeb(),
                    ),
                  );
                },
                child: const Icon(Icons.favorite_border),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartWeb(),
                    ),
                  );
                },
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ],
          )
        ],
      ),
    );
  }

  // ================= CATEGORIES GRID =================
  Widget _buildCategoriesList(List<dynamic> categories) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("TOUTES LES CATÉGORIES",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textDark)),
          const SizedBox(height: 30),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1),
            itemBuilder: (context, index) {
              final category = categories[index];
              return _buildCategoryCard(
                context: context,
                title: category.name,
                icon: _getIcon(category.icon),
              );
            },
          )
        ],
      ),
    );
  }

  // ================= CATEGORY CARD =================
  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardGrey,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to category page based on title
            if (title == "Électronique") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ElectroniqueCategoryWeb(),
                ),
              );
            } else if (title == "Vêtements") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VetementsCategoryWeb(),
                ),
              );
            } else if (title == "Maison") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MaisonCategoryWeb(),
                ),
              );
            } else if (title == "Sports") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SportsCategoryWeb(),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 60, color: primaryBlue),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Explore",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= FOOTER =================
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(40),
      color: primaryBlue,
      child: const Center(
        child: Text(
          "© 2026 MIZUX. All rights reserved.",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

// NAV ITEM
class _NavItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _NavItem(this.title, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: textDark)),
      ),
    );
  }
}
