import 'package:dj/layouts/web/Promotion_Section.dart';
import 'package:flutter/material.dart';
import 'pages_web/categories_web.dart';
import 'pages_web/products_web.dart';
import 'pages_web/cart_web.dart';
import 'pages_web/favorites_web.dart';
import 'pages_web/profile_web.dart';
import 'dart:math';


const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFFFFFFF);
const Color textDark = Color(0xFF111827);

Widget _deviceImage({
  required String image,
  required double height,
  double scale = 1.0,
  double opacity = 1.0,
  bool isPrimary = false,
}) {
  return Opacity(
    opacity: opacity,
    child: Transform.scale(
      scale: scale,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                  isPrimary ? 0.25 : 0.15),
              blurRadius: isPrimary ? 40 : 25,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Image.asset(
          image,
          height: height,
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}


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
            PromotionSection(),
            _buildCategoriesBar(),
            _buildFeaturedProducts(),
            _buildWhyShop(),
            _buildDownloadSection(),
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
              children: [
                Image.asset("assets/images/logo.png", width: 40),
                SizedBox(width: 8),
                Text("DJIBSOUQ",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue)),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
              ],
            ),
          ),
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
      ),
    );
  }

Widget _buildHeroSection() {
  return const HeroGalaxy();
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

    // ================= App download =================
 Widget _buildDownloadSection() {
  return Container(
    height: 280, // ✅ hauteur augmentée
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color.fromARGB(255, 226, 226, 228),
          Color.fromARGB(255, 43, 62, 90),
        ],
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        /// ================= LEFT TEXT =================
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/personne.png",
              width: 200,
              scale: 1.2,
              fit: BoxFit.contain,
            ),
            
          ],
        ),

        /// ================= RIGHT DEVICES =================
        SizedBox(
          height: 300,
          width: 700,
          child: Stack(
            alignment: Alignment.center,
            children: [

              /// Glow background (effet premium)
              Container(
                width: 420,
                height: 420,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              /// 💻 PC (arrière)
              Positioned(
                left: 40,
                child: _deviceImage(
                  image: "assets/images/swift_computer.png",
                  height: 280,
                  scale: 1.1,
                  opacity: 0.95,
                ),
              ),

              /// 📱 Tablette (milieu)
              Positioned(
                right: 80,
                bottom: 20,
                child: _deviceImage(
                  image: "assets/images/swift_pad.png",
                  height: 200,
                  scale: 1.05,
                ),
              ),

              /// 📱 Téléphone (avant focus)
              Positioned(
                bottom: 20,
                child: _deviceImage(
                  image: "assets/images/swift_phone.png",
                  height: 200,
                  scale: 1.05,
                  isPrimary: true,
                ),
              ),
            ],
          ),
        ),
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





// HERO GALAXY BACKGROUND

class HeroGalaxy extends StatefulWidget {
  const HeroGalaxy({super.key});

  @override
  State<HeroGalaxy> createState() => _HeroGalaxyState();
}

class _HeroGalaxyState extends State<HeroGalaxy>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;
  final Random _random = Random();
  late final List<Offset> _stars; // normalized positions (0..1)
  late final List<double> _starSizes;
  late final List<double> _starOpacities;
  static const int _starCount = 180;
  static const double _movementRange = 120.0; // pixels moved over full cycle

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(count: 5000);

    // Pre-generate star positions/sizes/opacities so the animation is smooth
    _stars = List.generate(
      _starCount,
      (_) => Offset(_random.nextDouble(), _random.nextDouble()),
    );

    _starSizes = List.generate(
      _starCount,
      (_) => _random.nextDouble() * 1.5,
    );

    _starOpacities = List.generate(
      _starCount,
      (_) => 0.25 + _random.nextDouble() * 0.75,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: Stack(
        children: [

          /// 🌑 Dark overlay (background)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0F172A).withOpacity(0.95),
                    const Color(0xFF1E293B).withOpacity(0.95),
                  ],
                ),
              ),
            ),
          ),

          /// 🌌 Animated background (stars on top of overlay)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) => CustomPaint(
                painter: GalaxyPainter(
                  progress: _controller.value,
                  stars: _stars,
                  sizes: _starSizes,
                  opacities: _starOpacities,
                  movementRange: _movementRange,
                ),
              ),
            ),
          ),

          /// CONTENT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60 ,vertical: 10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double maxW = constraints.maxWidth;
                final double deviceWidth = min(650, maxW * 0.55);
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Your Online Command Hub\nin Djibouti",
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Latest Electronics, Exclusive Deals",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade400,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 35,
                                vertical: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text("Start Shopping"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 50),
                    SizedBox(
                      height: 420,
                      width: deviceWidth,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: _deviceImage(
                                image: "assets/images/group.png",
                                opacity: 1.0,
                                height: 400,
                                isPrimary: true,
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GalaxyPainter extends CustomPainter {
  final double progress;
  final List<Offset> stars; // normalized positions (0..1)
  final List<double> sizes;
  final List<double> opacities;
  final double movementRange;

  GalaxyPainter({
    required this.progress,
    required this.stars,
    required this.sizes,
    required this.opacities,
    this.movementRange = 120.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (int i = 0; i < stars.length; i++) {
      final x = stars[i].dx * size.width;
      final y = (stars[i].dy * size.height + progress * movementRange) %
          size.height;

      paint.color = Colors.white.withOpacity(opacities[i]);

      canvas.drawCircle(Offset(x, y), sizes[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant GalaxyPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
