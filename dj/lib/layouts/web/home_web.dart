import 'dart:async';
import 'dart:ui';
import 'package:dj/layouts/web/pages_web/categories_web.dart';
import 'package:dj/layouts/web/pages_web/detail_product_popup.dart';
import 'package:dj/models/category_models.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:dj/widgets/web_header.dart';
import 'package:dj/data/product_repository.dart';
import 'package:url_launcher/url_launcher.dart';

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


Widget _buildBestSellers() {
  final bestSellers = ProductRepository.getBestSellers();

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 60),
    color: Colors.white,
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🔥 Best Sellers",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              height: 260, // 👈 hauteur compacte
              child: _BestSellerCarousel(products: bestSellers),
            ),
          ],
        ),
      ),
    ),
  );
}


  // ================= PROMO CAROUSEL =================
  Widget _buildPromoCarousel() {
    final promoCategories = ProductRepository.categories.where((cat) => cat.name != "New Arrivals").toList();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      color: lightGrey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Largeur adaptative selon la taille de l'écran
          double containerWidth;
          if (constraints.maxWidth > 1200) {
            containerWidth = 1250; // PC large
          } else if (constraints.maxWidth > 768) {
            containerWidth = constraints.maxWidth * 0.9; // Tablette
          } else {
            containerWidth = constraints.maxWidth * 0.95; // Mobile
          }

          return Center(
            child: SizedBox(
              width: containerWidth,
              child: Column(
                children: [
                  const Text(
                    "🎉 Promotions Spéciales",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Découvrez nos offres exceptionnelles par catégorie",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: promoCategories.length,
                      itemBuilder: (context, index) {
                        final category = promoCategories[index];
                        return Container(
                          width: 280,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: _PromoCard(
                            title: category.name,
                            description: "Jusqu'à -20% sur nos ${category.name.toLowerCase()}",
                            emoji: _getCategoryEmoji(category.icon),
                            color: category.color,
                            categoryName: category.name,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getCategoryEmoji(String iconName) {
    switch (iconName) {
      case 'devices':
        return '📱';
      case 'shopping_bag':
        return '👕';
      case 'home':
        return '🏠';
      case 'sports_soccer':
        return '⚽';
      default:
        return '🛍️';
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
            _buildBestSellers(),
            _buildPromoCarousel(),
            _buildCategoriesBar(),
            _buildFeaturedProducts(),
            _buildDownloadSection(),
            _buildWhyShop(),
            _buildNewsletterModern2(),
            _buildFooterAmazonStyle(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return const HeroGalaxy();
  }

Widget _buildCategoriesBar() {
  final allCategories = [
    ...categories,
    Category(
      name: "Toutes",
      icon: "list_alt",
      color: Colors.purpleAccent.shade400, id: 10000, image: '',
    ),
  ];

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
    child: Row(
      children: List.generate(allCategories.length, (i) {
        final cat = allCategories[i];

        return Flexible(
          fit: FlexFit.tight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: _AnimatedCategoryCard(
                icon: getIconData(cat.icon),
                title: cat.name,
                color: cat.color,
                delay: i * 80,
                onTap: () {
                  if (i == allCategories.length - 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CategoriesWeb()),
                    );
                  } else {
                    setState(() {
                      selectedCategory = cat.name;
                    });
                  }
                },
              ),
            ),
          ),
        );
      }),
    ),
  );
}

  // ================= FEATURED PRODUCTS =================
  Widget _buildFeaturedProducts() {
    final products = ProductRepository.getProductsByCategory(selectedCategory);
    final limitedProducts = products.length > 7 ? products.sublist(0, 7) : products;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selectedCategory,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: limitedProducts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.8),
            itemBuilder: (context, index) {
              final product = limitedProducts[index];
              return _ProductCard(product: product);
            },
          ),
          if (products.length > 7)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Navigate to category product page
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryProductsPage(category: selectedCategory)));
                },
                child: Text('Voir plus de produits', style: TextStyle(color: primaryBlue)),
              ),
            ),
        ],
      ),
    );
  }

  // ================= App download =================
 Widget _buildDownloadSection() {
  return Container(
    key: const ValueKey('appdownload-section'),
    padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 60),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFF0F172A),
          Color(0xFF1E293B),
          Color(0xFF1E3A8A),
        ],
      ),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 1100;

        return isSmall
            ? Column(
                children: [
                  _downloadTextSection(),
                  const SizedBox(height: 60),
                  _downloadDeviceSection(),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _downloadTextSection()),
                  const SizedBox(width: 40),
                  Expanded(child: _downloadDeviceSection()),
                ],
              );
      },
    ),
  );
}



  // ================= WHY SHOP =================
 Widget _buildWhyShop() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
    color: Colors.white,
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmall = constraints.maxWidth < 900;

            final items = [
              _WhyModernItem(
                icon: Icons.local_shipping,
                title: "Free Delivery",
                subtitle: "Fast shipping across Djibouti",
              ),
              _WhyModernItem(
                icon: Icons.lock,
                title: "Secure Payment",
                subtitle: "Encrypted & safe checkout",
              ),
              _WhyModernItem(
                icon: Icons.verified,
                title: "Quality Products",
                subtitle: "Verified sellers & brands",
              ),
              _WhyModernItem(
                icon: Icons.support_agent,
                title: "24/7 Support",
                subtitle: "We’re here anytime",
              ),
            ];

            return isSmall
                ? Column(
                    children: items
                        .map((e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: e,
                            ))
                        .toList(),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: items
                        .map((e) => Expanded(child: e))
                        .toList(),
                  );
          },
        ),
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
    return SizedBox(
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
                          Positioned(
                            right: 150,
                            bottom: 6,
                            child: Builder(
                              builder: (context) => ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.greenAccent.withOpacity(0.8),
                                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () {
                                  final keyContext = _findKeyContext(context, const ValueKey('appdownload-section'));
                                  if (keyContext != null) {
                                    Scrollable.ensureVisible(
                                      keyContext,
                                      duration: const Duration(milliseconds: 600),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                icon: const Icon(Icons.download, color: Colors.black),
                                label: const Text(
                                  "Télécharger l'app",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
  final double? width; // nouvelle
  final double? height; // nouvelle

  const _AnimatedCategoryCard({
    required this.icon,
    required this.title,
    required this.color,
    this.delay = 0,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  State<_AnimatedCategoryCard> createState() => _AnimatedCategoryCardState();
}

class _AnimatedCategoryCardState extends State<_AnimatedCategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  final bool _hovered = false;

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
            width: widget.width ?? 180,   // 👈 largeur fixe
            height: widget.height ?? 100, // 👈 hauteur fixe
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
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

// Best Seller Carousel (design inchangé)

class _BestSellerCarousel extends StatefulWidget {
  final List<dynamic> products;

  const _BestSellerCarousel({required this.products});

  @override
  State<_BestSellerCarousel> createState() => _BestSellerCarouselState();
}

class _BestSellerCarouselState extends State<_BestSellerCarousel> {
  late final PageController _controller;
  Timer? _timer;
  int _currentPage = 0;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _controller = PageController(viewportFraction: 0.25);

    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_isHovered) return;

      _currentPage++;
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _moveTo(int step) {
    final int newPage = (_currentPage + step).clamp(0, widget.products.length * 1000);
    setState(() {
      _currentPage = newPage;
    });
    _controller.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _isHovered = true,
      onExit: (_) => _isHovered = false,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _controller,
            itemBuilder: (context, index) {
              final product =
                  widget.products[index % widget.products.length];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _ModernBestSellerCard(product: product),
              );
            },
          ),
          Positioned(
            left: 4,
            child: IconButton(
              icon: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(Icons.chevron_left, color: Colors.black87),
              ),
              onPressed: () => _moveTo(-2),
              tooltip: 'Défiler vers la gauche',
            ),
          ),
          Positioned(
            right: 4,
            child: IconButton(
              icon: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(Icons.chevron_right, color: Colors.black87),
              ),
              onPressed: () => _moveTo(2),
              tooltip: 'Défiler vers la droite',
            ),
          ),
        ],
      ),
    );
  }
}



// Best Seller Card (design modernisé)
class _ModernBestSellerCard extends StatefulWidget {
  final dynamic product;
  const _ModernBestSellerCard({required this.product});

  @override
  State<_ModernBestSellerCard> createState() =>
      _ModernBestSellerCardState();
}

class _ModernBestSellerCardState extends State<_ModernBestSellerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _elevation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scale = Tween<double>(begin: 1, end: 1.04).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _elevation = Tween<double>(begin: 6, end: 18).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
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
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return Dialog(
                      insetPadding: const EdgeInsets.symmetric(horizontal: 120, vertical: 80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: DetailProductPopup(product: widget.product),
                    );
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.85),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: _elevation.value,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// TOP ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.redAccent, Colors.orange],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "HOT",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(Icons.favorite_border,
                            size: 18, color: Colors.grey),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// IMAGE
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.product.image,
                          style: const TextStyle(fontSize: 42),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// TITLE
                    Text(
                      widget.product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// PRICE ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${widget.product.price}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: primaryBlue,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: primaryBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}




// Product Card with hover animation (same as Best Seller)
class _ProductCard extends StatefulWidget {
  final dynamic product;
  const _ProductCard({required this.product});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _elevation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scale = Tween<double>(begin: 1, end: 1.04).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _elevation = Tween<double>(begin: 6, end: 18).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
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
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return Dialog(
                      insetPadding: const EdgeInsets.symmetric(horizontal: 120, vertical: 80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: DetailProductPopup(product: widget.product),
                    );
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: _elevation.value,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.product.image, // emoji ou image placeholder
                          style: const TextStyle(fontSize: 48),
                        ),
                      ),
                    ),
                    Text(widget.product.title),
                    const SizedBox(height: 8),
                    Text("\$${widget.product.price}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryBlue)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () {}, child: const Text("Add to Cart"))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}




// Promo Card with hover animation (same as Product and Best Seller)
class _PromoCard extends StatefulWidget {
  final String title;
  final String description;
  final String emoji;
  final Color color;
  final String categoryName;

  const _PromoCard({
    required this.title,
    required this.description,
    required this.emoji,
    required this.color,
    required this.categoryName,
  });

  @override
  State<_PromoCard> createState() => _PromoCardState();
}

class _PromoCardState extends State<_PromoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _elevation;
  late Animation<double> _gradientOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scale = Tween<double>(begin: 1, end: 1.04).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _elevation = Tween<double>(begin: 6, end: 18).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _gradientOpacity = Tween<double>(begin: 0, end: 0.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
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
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/promo', arguments: widget.categoryName);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: _elevation.value,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    // Image de fond avec gradient animé
                    AnimatedBuilder(
                      animation: _gradientOpacity,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _gradientOpacity.value,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/bg_stars_wb.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    // Contenu de la carte
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: widget.color.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                widget.emoji,
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}




 // DOWNLOAD SECTION - DEVICE IMAGES

Widget _featureItem(IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Icon(icon, color: Colors.greenAccent.shade400, size: 22),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}

Widget _downloadDeviceSection() {
  return SizedBox(
    height: 420,
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
                Colors.blueAccent.withOpacity(0.25),
                Colors.transparent,
              ],
            ),
          ),
        ),

        /// PC
        Positioned(
          left: 20,
          child: _deviceImage(
            image: "assets/images/swift_computer.png",
            height: 300,
            scale: 1.05,
            opacity: 0.95,
          ),
        ),

        /// Tablet
        Positioned(
          right: 50,
          bottom: 20,
          child: _deviceImage(
            image: "assets/images/swift_pad.png",
            height: 220,
            scale: 1.05,
          ),
        ),

        /// Phone (primary focus)
        Positioned(
          bottom: 10,
          child: _deviceImage(
            image: "assets/images/swift_phone.png",
            height: 230,
            scale: 1.1,
            isPrimary: true,
          ),
        ),
      ],
    ),
  );
}



// DOWNLOAD SECTION - TEXT

Widget _downloadTextSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Shop Smarter with\nDJIBSOUQ Mobile App",
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          height: 1.3,
        ),
      ),
      const SizedBox(height: 20),
      const Text(
        "Browse thousands of products, track orders instantly\nand get exclusive mobile-only deals.",
        style: TextStyle(
          fontSize: 18,
          color: Colors.white70,
          height: 1.6,
        ),
      ),
      const SizedBox(height: 30),

      /// BULLET POINTS
      _featureItem(Icons.flash_on, "Exclusive Flash Deals"),
      _featureItem(Icons.notifications_active, "Real-time Order Tracking"),
      _featureItem(Icons.security, "Secure & Fast Checkout"),

      const SizedBox(height: 40),

      /// PLAY STORE BUTTON
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.greenAccent.shade400,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {
          // 🔥 Remplace le lien par le vrai lien Play Store
          launchUrl(
            Uri.parse("https://play.google.com/store/apps/details?id=com.djibsouq.app"),
            mode: LaunchMode.externalApplication,
          );
        },
        icon: const Icon(Icons.android, color: Colors.black),
        label: const Text(
          "Download on Play Store",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}

class _WhyModernItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _WhyModernItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: primaryBlue, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}






// NEWSLETTER SIGNUP
Widget _buildNewsletterModern2() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF2A2D43),
          Color(0xFF1E3A8A),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmall = constraints.maxWidth < 700;
            return Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: isSmall
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _newsletterBox(),
                        const SizedBox(height: 30),
                        _socialRow(),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(flex: 3, child: _newsletterBox()),
                        const SizedBox(width: 40),
                        Expanded(flex: 2, child: _socialRow()),
                      ],
                    ),
            );
          },
        ),
      ),
    ),
  );
}

// ===== Newsletter box =====
Widget _newsletterBox() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Never Miss a Deal!",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 12),
      const Text(
        "Subscribe to get exclusive offers, new arrivals, and updates straight to your inbox.",
        style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
      ),
      const SizedBox(height: 24),
      Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Your email",
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              backgroundColor: Colors.greenAccent.shade400,
              elevation: 6,
            ),
            child: const Text(
              "Subscribe",
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    ],
  );
}

// ===== Social row moderne =====
Widget _socialRow() {
  final socials = [
    {"icon": Icons.facebook, "color": Colors.blue},
    {"icon": Icons.camera_alt, "color": Colors.purple},
    {"icon": Icons.chat, "color": Colors.lightBlue},
    {"icon": Icons.video_call, "color": Colors.red},
  ];

  return Wrap(
    spacing: 16,
    runSpacing: 16,
    alignment: WrapAlignment.center,
    children: socials
        .map((s) => _socialChip(s["icon"] as IconData, s["color"] as Color))
        .toList(),
  );
}

// ===== Social chip moderne =====
Widget _socialChip(IconData icon, Color color) {
  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.6),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    ),
  );
}



Widget _buildFooterAmazonStyle() {
  return Container(
    width: double.infinity,
    color: const Color(0xFF0F172A), // fond sombre
    padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmall = constraints.maxWidth < 900;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== Footer Top - 4 Columns =====
                isSmall
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _footerColumnLogo(),
                          const SizedBox(height: 30),
                          _footerColumnLinks(),
                          const SizedBox(height: 30),
                          _footerColumnCustomer(),
                          const SizedBox(height: 30),
                          _footerColumnSocials(),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: _footerColumnLogo()),
                          Expanded(flex: 2, child: _footerColumnLinks()),
                          Expanded(flex: 2, child: _footerColumnCustomer()),
                          Expanded(flex: 1, child: _footerColumnSocials()),
                        ],
                      ),
                const SizedBox(height: 50),
                Divider(color: Colors.white.withOpacity(0.2)),
                const SizedBox(height: 20),
                // ===== Footer Bottom =====
                Center(
                  child: Text(
                    "© 2026 DJIBSOUQ. All rights reserved.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
}

// ===== Column 1 : Logo + slogan =====
Widget _footerColumnLogo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Logo
      Row(
        children: [
          Image.asset(
            "assets/images/logo.png",
            height: 40,
          ),
          const SizedBox(width: 10),
          const Text(
            "DJIBSOUQ",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22),
          ),
        ],
      ),
      const SizedBox(height: 12),
      const Text(
        "Your Online Command Hub in Djibouti",
        style: TextStyle(color: Colors.white70, fontSize: 14),
      ),
      const SizedBox(height: 20),
      const Text(
        "Fast Delivery | Secure Payment | 24/7 Support",
        style: TextStyle(color: Colors.white70, fontSize: 13),
      ),
    ],
  );
}

// ===== Column 2 : Liens rapides =====
Widget _footerColumnLinks() {
  final links = ["Home", "Categories", "Best Sellers", "Featured Products", "Contact"];
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Quick Links",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      const SizedBox(height: 12),
      ...links.map(
        (link) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              foregroundColor: Colors.white70,
              textStyle: const TextStyle(fontSize: 14),
            ),
            child: Text(link),
          ),
        ),
      ),
    ],
  );
}

// ===== Column 3 : Customer Service =====
Widget _footerColumnCustomer() {
  final services = [
    "Help Center",
    "Returns",
    "Shipping Info",
    "Track Orders",
    "Gift Cards"
  ];
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Customer Service",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      const SizedBox(height: 12),
      ...services.map(
        (s) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              foregroundColor: Colors.white70,
              textStyle: const TextStyle(fontSize: 14),
            ),
            child: Text(s),
          ),
        ),
      ),
    ],
  );
}

// ===== Column 4 : Socials =====
Widget _footerColumnSocials() {
  final socials = [
    {"icon": Icons.facebook, "color": Colors.blue},
    {"icon": Icons.camera_alt, "color": Colors.purple},
    {"icon": Icons.chat, "color": Colors.lightBlue},
    {"icon": Icons.video_call, "color": Colors.red},
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Follow Us",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      const SizedBox(height: 12),
      Wrap(
        spacing: 12,
        children: socials
            .map((s) => _footerSocialChip(
                s["icon"] as IconData, s["color"] as Color))
            .toList(),
      ),
    ],
  );
}

// ===== Social Chip avec hover =====
Widget _footerSocialChip(IconData icon, Color color) {
  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    ),
  );
}

BuildContext? _findKeyContext(BuildContext context, Key key) {
  BuildContext? result;
  void search(Element element) {
    if (element.widget.key == key) {
      result = element;
    } else {
      element.visitChildren(search);
    }
  }
  context.findRootAncestorStateOfType<State>()?.context.visitChildElements(search);
  return result;
}
