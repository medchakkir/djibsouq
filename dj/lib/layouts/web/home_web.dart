import 'package:flutter/material.dart';
import 'pages_web/categories_web.dart';
import 'pages_web/products_web.dart';
import 'pages_web/cart_web.dart';
import 'pages_web/favorites_web.dart';
import 'pages_web/profile_web.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFFFFFFF);
const Color textDark = Color(0xFF111827);

class HomepageWeb extends StatelessWidget {
  const HomepageWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildHeroSection(),
            _buildCategoriesBar(),
            _buildFeaturedProducts(),
            _buildWhyShop(),
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
                Navigator.push(
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

  // ================= HERO =================
  Widget _buildHeroSection() {
    return Container(
      height: 400,
      padding: const EdgeInsets.symmetric(horizontal: 60),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LEFT TEXT
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "SUMMER SALE!\nUP TO 50% OFF",
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: primaryBlue,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 15),
                ),
                onPressed: () {},
                child: const Text("Shop Now"),
              )
            ],
          ),

          // RIGHT PRODUCT
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              SizedBox(
                height: 280,
                width: 500,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 💻 PC (gauche)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.scale(
                            scale: 1.5,
                            child: Image.asset(
                              "assets/images/swift_computer.png",
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Desktop",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 20),

                    // 📱 Téléphone (centre - principal)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.scale(
                            scale: 1.0,
                            child: Image.asset(
                              "assets/images/swift_phone.png",
                              height: 150,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Mobile",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 20),

                    // 📱 Tablette (droite)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.tablet_mac,
                              color: Colors.white,
                              size: 60,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Tablet",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )

            ],
          )
        ],
      ),
    );
  }

  // ================= CATEGORIES =================
  Widget _buildCategoriesBar() {
    List<Map<String, dynamic>> categories = [
      {"icon": Icons.new_releases, "title": "New Arrivals"},
      {"icon": Icons.star, "title": "Best Sellers"},
      {"icon": Icons.headphones, "title": "Headphones"},
      {"icon": Icons.devices, "title": "Smart Devices"},
      {"icon": Icons.gamepad, "title": "Gaming"},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: categories
            .map((cat) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(cat["icon"], color: primaryBlue),
                      const SizedBox(width: 10),
                      Text(cat["title"]),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  // ================= FEATURED PRODUCTS =================
  Widget _buildFeaturedProducts() {
    List<Map<String, dynamic>> products = [
      {"title": "Smart Watch", "price": "199.00"},
      {"title": "Headphones", "price": "129.00"},
      {"title": "Smart Speaker", "price": "79.00"},
      {"title": "Gaming Pad", "price": "59.00"},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("FEATURED PRODUCTS",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textDark)),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.8),
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                          "https://i.imgur.com/Y9QZ6Gg.png"),
                    ),
                    Text(product["title"]),
                    const SizedBox(height: 8),
                    Text("\$${product["price"]}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryBlue)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () {},
                        child: const Text("Add to Cart"))
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  // ================= WHY SHOP =================
  Widget _buildWhyShop() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 60),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _WhyItem(Icons.local_shipping, "Free Delivery"),
          _WhyItem(Icons.lock, "Secure Payment"),
          _WhyItem(Icons.verified, "Quality Products"),
          _WhyItem(Icons.support_agent, "24/7 Support"),
        ],
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

// WHY ITEM
class _WhyItem extends StatelessWidget {
  final IconData icon;
  final String title;
  const _WhyItem(this.icon, this.title);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 40, color: primaryBlue),
        const SizedBox(height: 10),
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: textDark)),
      ],
    );
  }
}
