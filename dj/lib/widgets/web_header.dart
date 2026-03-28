import 'package:dj/layouts/web/pages_web/promo_web.dart';
import 'package:flutter/material.dart';
import 'package:dj/layouts/web/home_web.dart';
import 'package:dj/layouts/web/pages_web/cart_web.dart';
import 'package:dj/layouts/web/pages_web/categories_web.dart';
import 'package:dj/layouts/web/pages_web/favorites_web.dart';
import 'package:dj/layouts/web/pages_web/products_web.dart';
import 'package:dj/layouts/web/pages_web/profile_web.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color textDark = Color(0xFF111827);

// ================= HEADER =================
class buildHeader extends StatefulWidget {
  final String currentPage; // Page active à afficher

  const buildHeader({super.key, required this.currentPage});

  @override
  State<buildHeader> createState() => _buildHeaderState();
}

class _buildHeaderState extends State<buildHeader> {
  late String selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.currentPage;
  }

  @override
  Widget build(BuildContext context) {
    final navItems = ["Home", "Categories", "Products", "Promo", ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LOGO
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomepageWeb()),
              );
            },
            child: Row(
              children: [
                Image.asset("assets/images/logo.png", width: 40),
                const SizedBox(width: 8),
                const Text(
                  "DJIBSOUQ",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue),
                ),
              ],
            ),
          ),
          // NAVIGATION
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: navItems.map((title) {
                return NavItemWeb(
                  title: title,
                  isSelected: selectedItem == title,
                  onTap: () {
                    setState(() {
                      selectedItem = title;
                    });
                    // Navigation selon l'onglet
                    switch (title) {
                      case "Home":
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomepageWeb()),
                        );
                        break;
                      case "Categories":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CategoriesWeb()),
                        );
                        break;
                      case "Products":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProductsWeb()),
                        );
                        break;
                      case "Promo":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PromoWeb()),
                        );
                        break;
                      
                      case "Contact":
                        // Ajouter page Contact
                        break;
                    }
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 30),
          // ICONS
          Row(
            children: [
              GestureDetector(onTap: () {}, child: const Icon(Icons.search)),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileWeb()),
                  );
                },
                child: const Icon(Icons.person_outline),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FavoritesWeb()),
                  );
                },
                child: const Icon(Icons.favorite_border),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartWeb()),
                  );
                },
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ================= NAV ITEM ANIMÉ =================
class NavItemWeb extends StatefulWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const NavItemWeb({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<NavItemWeb> createState() => _NavItemWebState();
}

class _NavItemWebState extends State<NavItemWeb> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 15),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: widget.isSelected
                    ? primaryBlue
                    : isHover
                        ? primaryBlue.withOpacity(0.6)
                        : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: TextStyle(
              fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w500,
              color: widget.isSelected
                  ? primaryBlue
                  : isHover
                      ? primaryBlue.withOpacity(0.8)
                      : textDark,
              fontSize: 16,
            ),
            child: Text(widget.title),
          ),
        ),
      ),
    );
  }
}
