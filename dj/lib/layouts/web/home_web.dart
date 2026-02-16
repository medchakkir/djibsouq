import 'package:dj/layouts/web/Promotion_Section.dart';
import 'package:dj/models/category_models.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:dj/widgets/web_header.dart';
import 'package:dj/data/product_repository.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFFFFFFF);
const Color textDark = Color(0xFF111827);

List<Category> categories = ProductRepository.categories;

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
              color: Colors.black.withOpacity(isPrimary ? 0.25 : 0.15),
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

class HomepageWeb extends StatefulWidget {
  const HomepageWeb({super.key});

  @override
  State<HomepageWeb> createState() => _HomepageWebState();
}

class _HomepageWebState extends State<HomepageWeb> {
  // selected category pour filtrer les produits
  String selectedCategory = ProductRepository.categories.first.name;

  // Retourne l'IconData correspondant au nom d'icône de la catégorie
IconData getIconData(String iconName) {
  switch (iconName) {
    case 'star':
    case 'stars':
      return Icons.star;
    case 'devices':
      return Icons.devices;
    case 'shopping_bag':
      return Icons.shopping_bag;
    case 'home':
      return Icons.home;
    case 'sports_soccer':
      return Icons.sports_soccer;
    case 'add':
      return Icons.add;
    default:
      return Icons.category;
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(currentPage: "Home"),
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

  Widget _buildHeroSection() {
    return const HeroGalaxy();
  }

  // ================= CATEGORIES =================
  Widget _buildCategoriesBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(categories.length, (i) {
              final cat = categories[i];
              return AnimatedOpacity(
                opacity: 0.8,
                duration: const Duration(milliseconds: 400),
                child: _AnimatedCategoryCard(
                  icon: getIconData(cat.icon), // tu peux changer selon cat.icon si tu veux
                  title: cat.name,
                  color: cat.color,
                  delay: i * 80,
                  onTap: () {
                    setState(() {
                      selectedCategory = cat.name;
                    });
                  },
                ),
              );
            }),
          );
        },
      ),
    );
  }

  // ================= FEATURED PRODUCTS =================
  Widget _buildFeaturedProducts() {
    final products = ProductRepository.getProductsByCategory(selectedCategory);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "FEATURED PRODUCTS",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
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
                      child: Center(
                        child: Text(
                          product.image, // emoji ou image placeholder
                          style: const TextStyle(fontSize: 48),
                        ),
                      ),
                    ),
                    Text(product.title),
                    const SizedBox(height: 8),
                    Text("\$${product.price}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryBlue)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () {}, child: const Text("Add to Cart"))
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
      height: 280,
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
          /// LEFT TEXT
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

          /// RIGHT DEVICES
          SizedBox(
            height: 300,
            width: 700,
            child: Stack(
              alignment: Alignment.center,
              children: [
                /// Glow background
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

                /// PC
                Positioned(
                  left: 40,
                  child: _deviceImage(
                    image: "assets/images/swift_computer.png",
                    height: 280,
                    scale: 1.1,
                    opacity: 0.95,
                  ),
                ),

                /// Tablette
                Positioned(
                  right: 80,
                  bottom: 20,
                  child: _deviceImage(
                    image: "assets/images/swift_pad.png",
                    height: 200,
                    scale: 1.05,
                  ),
                ),

                /// Téléphone
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
  late final List<Offset> _stars;
  late final List<double> _starSizes;
  late final List<double> _starOpacities;
  static const int _starCount = 180;
  static const double _movementRange = 120.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(count: 5000);

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
          /// Dark overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0F172A).withOpacity(0.95),
                    const Color(0xFF1E293B).withOpacity(0.95),
                  ],
                ),
              ),
            ),
          ),
          /// Stars
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
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
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
  final List<Offset> stars;
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

// Animated Category Card (design inchangé)
class _AnimatedCategoryCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color color;
  final int delay;
  final VoidCallback? onTap;
  const _AnimatedCategoryCard({
    required this.icon,
    required this.title,
    required this.color,
    this.delay = 0,
    this.onTap,
  });

  @override
  State<_AnimatedCategoryCard> createState() => _AnimatedCategoryCardState();
}

class _AnimatedCategoryCardState extends State<_AnimatedCategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnim = Tween<double>(begin: 1, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 18),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(
                color: _hovered ? widget.color : Colors.transparent,
                width: 2,
              ),
              image: const DecorationImage(
                image: AssetImage("assets/images/bg_stars_wb.png"),
                fit: BoxFit.cover,
                opacity: 1,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Icon(widget.icon, color: widget.color, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
