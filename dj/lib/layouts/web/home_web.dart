import 'dart:async';
import 'dart:math';
import 'package:dj/layouts/web/pages_web/categories_web.dart';
import 'package:dj/layouts/web/pages_web/detail_product_popup.dart';
import 'package:dj/models/category_models.dart';
import 'package:dj/models/product_models.dart';
import 'package:dj/widgets/web_header.dart';
import 'package:dj/data/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dj/routes.dart';

// ─────────────────────────────────────────────
//  CONSTANTS
// ─────────────────────────────────────────────
const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color textDark = Color(0xFF111827);

// ─────────────────────────────────────────────
//  HOMEPAGE
// ─────────────────────────────────────────────
class HomepageWeb extends StatefulWidget {
  const HomepageWeb({super.key});

  @override
  State<HomepageWeb> createState() => _HomepageWebState();
}

class _HomepageWebState extends State<HomepageWeb> with TickerProviderStateMixin {
  String _selectedCategory = ProductRepository.categories.first.name;
  final GlobalKey _downloadKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _fadeController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fadeIn = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideIn = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
        .animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic));
    WidgetsBinding.instance.addPostFrameCallback((_) => _fadeController.forward());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _scrollToDownload() {
    final ctx = _downloadKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
    }
  }

  IconData _iconFromName(String name) {
    const map = {
      'star': Icons.star, 'stars': Icons.star,
      'devices': Icons.devices, 'shopping_bag': Icons.shopping_bag,
      'home': Icons.home, 'sports_soccer': Icons.sports_soccer,
      'add': Icons.add,
    };
    return map[name] ?? Icons.category;
  }

  String _emojiFromIcon(String iconName) {
    const map = {
      'devices': '📱', 'shopping_bag': '👕',
      'home': '🏠', 'sports_soccer': '⚽',
    };
    return map[iconName] ?? '🛍️';
  }

  // ─────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            buildHeader(currentPage: 'Home'),
            HeroGalaxy(onDownloadTap: _scrollToDownload),
            FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideIn,
                child: Column(
                  children: [
                    _buildBestSellers(),
                    _buildPromoCarousel(),
                    _buildCategoriesBar(),
                    _buildFeaturedProducts(),
                    _buildDownloadSection(),
                    _buildWhyShop(),
                    _buildNewsletterSection(),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  BEST SELLERS
  // ─────────────────────────────────────────────
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
              _SectionLabel(label: '🔥 Best Sellers'),
              const SizedBox(height: 30),
              SizedBox(height: 260, child: _BestSellerCarousel(products: bestSellers)),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  PROMO CAROUSEL
  // ─────────────────────────────────────────────
  Widget _buildPromoCarousel() {
    final promoCategories =
        ProductRepository.categories.where((c) => c.name != 'New Arrivals').toList();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      color: lightGrey,
      child: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth > 1200
            ? 1250.0
            : constraints.maxWidth > 768
                ? constraints.maxWidth * 0.9
                : constraints.maxWidth * 0.95;
        return Center(
          child: SizedBox(
            width: width,
            child: Column(
              children: [
                _SectionLabel(label: '🎉 Promotions Spéciales', center: true),
                const SizedBox(height: 8),
                const Text('Découvrez nos offres exceptionnelles par catégorie',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center),
                const SizedBox(height: 40),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: promoCategories.length,
                    itemBuilder: (context, i) {
                      final cat = promoCategories[i];
                      return SizedBox(
                        width: 280,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: _PromoCard(
                            title: cat.name,
                            description: "Jusqu'à -20% sur nos ${cat.name.toLowerCase()}",
                            emoji: _emojiFromIcon(cat.icon),
                            color: cat.color,
                            categoryName: cat.name,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ─────────────────────────────────────────────
  //  CATEGORIES BAR
  // ─────────────────────────────────────────────
  Widget _buildCategoriesBar() {
    final allCategories = [
      ...ProductRepository.categories,
      Category(name: 'Toutes', icon: 'list_alt', color: Colors.purpleAccent.shade400, id: 10000, image: ''),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Row(
        children: List.generate(allCategories.length, (i) {
          final cat = allCategories[i];
          final isLast = i == allCategories.length - 1;
          return Flexible(
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: _AnimatedCategoryCard(
                  icon: _iconFromName(cat.icon),
                  title: cat.name,
                  color: cat.color,
                  delay: i * 80,
                  isSelected: !isLast && _selectedCategory == cat.name,
                  onTap: isLast
                      ? () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const CategoriesWeb()))
                      : () => setState(() => _selectedCategory = cat.name),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  FEATURED PRODUCTS — section modernisée
  // ─────────────────────────────────────────────
  Widget _buildFeaturedProducts() {
    final products = ProductRepository.getProductsByCategory(_selectedCategory);
    final limited = products.length > 8 ? products.sublist(0, 8) : products;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header de section ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedCategory,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 3,
                            decoration: BoxDecoration(
                              color: primaryBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 8,
                            height: 3,
                            decoration: BoxDecoration(
                              color: primaryBlue.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (products.length > 8)
                    _SeeMoreButton(
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.products,
                        arguments: _selectedCategory,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 28),

              // ── Grille ──
              limited.isEmpty
                  ? _EmptyCategory(category: _selectedCategory)
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: limited.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.78,
                      ),
                      itemBuilder: (_, i) => _FeaturedProductCard(
                        product: limited[i],
                        index: i,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  DOWNLOAD SECTION
  // ─────────────────────────────────────────────
  Widget _buildDownloadSection() {
    return Container(
      key: _downloadKey,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 60),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF1E3A8A)],
        ),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 1100;
        return isSmall
            ? Column(children: [_downloadTextSection(), const SizedBox(height: 60), _downloadDeviceSection()])
            : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: _downloadTextSection()),
                const SizedBox(width: 40),
                Expanded(child: _downloadDeviceSection()),
              ]);
      }),
    );
  }

  Widget _downloadTextSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Shop Smarter with\nDJIBSOUQ Mobile App',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white, height: 1.3)),
        const SizedBox(height: 20),
        const Text(
          'Browse thousands of products, track orders instantly\nand get exclusive mobile-only deals.',
          style: TextStyle(fontSize: 18, color: Colors.white70, height: 1.6),
        ),
        const SizedBox(height: 30),
        _featureItem(Icons.flash_on, 'Exclusive Flash Deals'),
        _featureItem(Icons.notifications_active, 'Real-time Order Tracking'),
        _featureItem(Icons.security, 'Secure & Fast Checkout'),
        const SizedBox(height: 40),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent.shade400,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: () => launchUrl(
            Uri.parse('https://play.google.com/store/apps/details?id=com.djibsouq.app'),
            mode: LaunchMode.externalApplication,
          ),
          icon: const Icon(Icons.android, color: Colors.black),
          label: const Text('Download on Play Store',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _downloadDeviceSection() {
    return SizedBox(
      height: 420,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 420, height: 420,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Colors.blueAccent.withOpacity(0.25), Colors.transparent],
              ),
            ),
          ),
          Positioned(left: 20,
              child: _deviceImage(image: 'assets/images/swift_computer.png', height: 300, scale: 1.05, opacity: 0.95)),
          Positioned(right: 50, bottom: 20,
              child: _deviceImage(image: 'assets/images/swift_pad.png', height: 220, scale: 1.05)),
          Positioned(bottom: 10,
              child: _deviceImage(image: 'assets/images/swift_phone.png', height: 230, scale: 1.1, isPrimary: true)),
        ],
      ),
    );
  }

  Widget _featureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.greenAccent.shade400, size: 22),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  WHY SHOP
  // ─────────────────────────────────────────────
  Widget _buildWhyShop() {
    final items = [
      _WhyItem(icon: Icons.local_shipping, title: 'Free Delivery', subtitle: 'Fast shipping across Djibouti'),
      _WhyItem(icon: Icons.lock, title: 'Secure Payment', subtitle: 'Encrypted & safe checkout'),
      _WhyItem(icon: Icons.verified, title: 'Quality Products', subtitle: 'Verified sellers & brands'),
      _WhyItem(icon: Icons.support_agent, title: '24/7 Support', subtitle: "We're here anytime"),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
      color: lightGrey,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(builder: (context, constraints) {
            return constraints.maxWidth < 900
                ? Column(children: items.map((e) =>
                    Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: e)).toList())
                : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: items.map((e) => Expanded(child: e)).toList());
          }),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  NEWSLETTER
  // ─────────────────────────────────────────────
  Widget _buildNewsletterSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2A2D43), Color(0xFF1E3A8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: LayoutBuilder(builder: (context, constraints) {
            final isSmall = constraints.maxWidth < 700;
            return Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: isSmall
                  ? Column(children: [_newsletterBox(), const SizedBox(height: 30), _socialRow()])
                  : Row(children: [
                      Expanded(flex: 3, child: _newsletterBox()),
                      const SizedBox(width: 40),
                      Expanded(flex: 2, child: _socialRow()),
                    ]),
            );
          }),
        ),
      ),
    );
  }

  Widget _newsletterBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Never Miss a Deal!',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 12),
        const Text(
          'Subscribe to get exclusive offers, new arrivals, and updates straight to your inbox.',
          style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Your email',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                backgroundColor: Colors.greenAccent.shade400,
              ),
              child: const Text('Subscribe',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _socialRow() {
    const socials = [
      (icon: Icons.facebook, color: Colors.blue),
      (icon: Icons.camera_alt, color: Colors.purple),
      (icon: Icons.chat, color: Colors.lightBlue),
      (icon: Icons.video_call, color: Colors.red),
    ];
    return Wrap(
      spacing: 16, runSpacing: 16, alignment: WrapAlignment.center,
      children: socials.map((s) => _SocialChip(icon: s.icon, color: s.color)).toList(),
    );
  }

  // ─────────────────────────────────────────────
  //  FOOTER
  // ─────────────────────────────────────────────
  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF080F1E),
      child: Column(
        children: [
          Container(
            height: 3,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6), Color(0xFF1E3A8A)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 60),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1300),
                child: LayoutBuilder(builder: (context, constraints) {
                  final isSmall = constraints.maxWidth < 900;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isSmall
                          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              _FooterColumnLogo(),
                              const SizedBox(height: 40),
                              _FooterColumnLinks(),
                              const SizedBox(height: 40),
                              _FooterColumnCustomer(),
                              const SizedBox(height: 40),
                              _FooterColumnSocials(),
                            ])
                          : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Expanded(flex: 3, child: _FooterColumnLogo()),
                              Expanded(flex: 2, child: _FooterColumnLinks()),
                              Expanded(flex: 2, child: _FooterColumnCustomer()),
                              Expanded(flex: 2, child: _FooterColumnSocials()),
                            ]),
                      const SizedBox(height: 56),
                      Container(height: 1, color: Colors.white.withOpacity(0.08)),
                      const SizedBox(height: 28),
                      LayoutBuilder(builder: (context, c) {
                        final narrow = c.maxWidth < 700;
                        return narrow
                            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('© 2026 DJIBSOUQ. All rights reserved.',
                                    style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13)),
                                const SizedBox(height: 12),
                                Wrap(spacing: 16, children: [
                                  _FooterLink('Privacy'),
                                  _FooterLink('Terms'),
                                  _FooterLink('Cookies'),
                                ]),
                              ])
                            : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text('© 2026 DJIBSOUQ. All rights reserved.',
                                    style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13)),
                                Row(children: [
                                  _FooterLink('Privacy Policy'),
                                  const SizedBox(width: 24),
                                  _FooterLink('Terms of Service'),
                                  const SizedBox(width: 24),
                                  _FooterLink('Cookies'),
                                ]),
                              ]);
                      }),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  FEATURED PRODUCT CARD — modernisée
// ─────────────────────────────────────────────
class _FeaturedProductCard extends StatefulWidget {
  final Product product;
  final int index;

  const _FeaturedProductCard({required this.product, required this.index});

  @override
  State<_FeaturedProductCard> createState() => _FeaturedProductCardState();
}

class _FeaturedProductCardState extends State<_FeaturedProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _shadow;
  bool _hovered = false;
  bool _favorited = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 220));
    _scale = Tween<double>(begin: 1.0, end: 1.04)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _shadow = Tween<double>(begin: 6, end: 20)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openDetail() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 120, vertical: 80),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: DetailProductPopup(product: widget.product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        _controller.forward();
        setState(() => _hovered = true);
      },
      onExit: (_) {
        _controller.reverse();
        setState(() => _hovered = false);
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => Transform.scale(
          scale: _scale.value,
          child: GestureDetector(
            onTap: _openDetail,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withOpacity(_hovered ? 0.12 : 0.05),
                    blurRadius: _shadow.value,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: _hovered ? primaryBlue.withOpacity(0.15) : Colors.transparent,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Image zone ──
                  Expanded(
                    flex: 5,
                    child: Stack(
                      children: [
                        // Fond image
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: _hovered
                                ? const Color(0xFFEEF2FF)
                                : lightGrey,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: Center(
                            child: AnimatedScale(
                              scale: _hovered ? 1.08 : 1.0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutCubic,
                              child: Text(widget.product.image,
                                  style: const TextStyle(fontSize: 60)),
                            ),
                          ),
                        ),

                        // Badge best seller
                        if (widget.product.isBestSeller)
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    colors: [Colors.redAccent, Colors.orange]),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text('HOT',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),

                        // Bouton favori
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () => setState(() => _favorited = !_favorited),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: _favorited
                                    ? Colors.red.withOpacity(0.1)
                                    : Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 6)
                                ],
                              ),
                              child: Icon(
                                _favorited ? Icons.favorite : Icons.favorite_border,
                                size: 15,
                                color: _favorited ? Colors.redAccent : Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Info zone ──
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Catégorie pill
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: primaryBlue.withOpacity(0.07),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.product.category,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: primaryBlue.withOpacity(0.8)),
                            ),
                          ),

                          const SizedBox(height: 6),

                          // Titre
                          Text(
                            widget.product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: textDark,
                                height: 1.3),
                          ),

                          const SizedBox(height: 6),

                          // Rating
                          Row(
                            children: [
                              ...List.generate(5, (i) => Icon(
                                    i < widget.product.rating.floor()
                                        ? Icons.star_rounded
                                        : Icons.star_outline_rounded,
                                    size: 12,
                                    color: Colors.amber.shade600,
                                  )),
                              const SizedBox(width: 4),
                              Text(
                                '(${widget.product.reviews})',
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                              ),
                            ],
                          ),

                          const Spacer(),

                          // Prix + panier
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '\$${widget.product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: primaryBlue,
                                    ),
                                  ),
                                ],
                              ),
                              // Bouton panier animé
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: _hovered ? primaryBlue : primaryBlue.withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: _hovered
                                      ? [BoxShadow(
                                          color: primaryBlue.withOpacity(0.4),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4))]
                                      : [],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: _openDetail,
                                    borderRadius: BorderRadius.circular(12),
                                    child: const Padding(
                                      padding: EdgeInsets.all(9),
                                      child: Icon(Icons.add_shopping_cart,
                                          color: Colors.white, size: 17),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

// ─────────────────────────────────────────────
//  SEE MORE BUTTON
// ─────────────────────────────────────────────
class _SeeMoreButton extends StatefulWidget {
  final VoidCallback onTap;
  const _SeeMoreButton({required this.onTap});

  @override
  State<_SeeMoreButton> createState() => _SeeMoreButtonState();
}

class _SeeMoreButtonState extends State<_SeeMoreButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered ? primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: primaryBlue),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _hovered ? Colors.white : primaryBlue,
                ),
                child: const Text('Voir tout'),
              ),
              const SizedBox(width: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.translationValues(_hovered ? 3 : 0, 0, 0),
                child: Icon(Icons.arrow_forward,
                    size: 14,
                    color: _hovered ? Colors.white : primaryBlue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  EMPTY CATEGORY STATE
// ─────────────────────────────────────────────
class _EmptyCategory extends StatelessWidget {
  final String category;
  const _EmptyCategory({required this.category});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text('Aucun produit dans "$category"',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade400)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SECTION LABEL
// ─────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  final bool center;
  const _SectionLabel({required this.label, this.center = false});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        textAlign: center ? TextAlign.center : TextAlign.start,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textDark));
  }
}

// ─────────────────────────────────────────────
//  DEVICE IMAGE
// ─────────────────────────────────────────────
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
        child: Image.asset(image, height: height, fit: BoxFit.contain),
      ),
    ),
  );
}

// ─────────────────────────────────────────────
//  HOVER SCALE CARD
// ─────────────────────────────────────────────
class HoverScaleCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleEnd;
  final Duration duration;

  const HoverScaleCard({
    super.key,
    required this.child,
    this.onTap,
    this.scaleEnd = 1.04,
    this.duration = const Duration(milliseconds: 250),
  });

  @override
  State<HoverScaleCard> createState() => _HoverScaleCardState();
}

class _HoverScaleCardState extends State<HoverScaleCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scale = Tween<double>(begin: 1, end: widget.scaleEnd)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
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
        child: ScaleTransition(scale: _scale, child: widget.child),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HERO GALAXY
// ─────────────────────────────────────────────
class HeroGalaxy extends StatefulWidget {
  final VoidCallback onDownloadTap;
  const HeroGalaxy({super.key, required this.onDownloadTap});

  @override
  State<HeroGalaxy> createState() => _HeroGalaxyState();
}

class _HeroGalaxyState extends State<HeroGalaxy> with TickerProviderStateMixin {
  late final AnimationController _starsController;
  late final AnimationController _textController;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  final Random _random = Random();
  late final List<Offset> _stars;
  late final List<double> _starSizes;
  late final List<double> _starOpacities;
  static const int _starCount = 180;
  static const double _movementRange = 120.0;

  @override
  void initState() {
    super.initState();
    _starsController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    _textController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _textFade = CurvedAnimation(parent: _textController, curve: Curves.easeOut);
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic));

    _stars = List.generate(_starCount, (_) => Offset(_random.nextDouble(), _random.nextDouble()));
    _starSizes = List.generate(_starCount, (_) => _random.nextDouble() * 1.5);
    _starOpacities = List.generate(_starCount, (_) => 0.25 + _random.nextDouble() * 0.75);

    WidgetsBinding.instance.addPostFrameCallback((_) => _textController.forward());
  }

  @override
  void dispose() {
    _starsController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Stack(
        children: [
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
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _starsController,
              builder: (_, __) => CustomPaint(
                painter: GalaxyPainter(
                  progress: _starsController.value,
                  stars: _stars,
                  sizes: _starSizes,
                  opacities: _starOpacities,
                  movementRange: _movementRange,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
            child: LayoutBuilder(builder: (context, constraints) {
              final deviceWidth = min(650, constraints.maxWidth * 0.55) as double;
              return Row(
                children: [
                  Expanded(
                    child: FadeTransition(
                      opacity: _textFade,
                      child: SlideTransition(
                        position: _textSlide,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Your Online Command Hub\nin Djibouti',
                                style: TextStyle(
                                    fontSize: 42, fontWeight: FontWeight.bold,
                                    color: Colors.white, height: 1.3)),
                            const SizedBox(height: 20),
                            const Text('Latest Electronics, Exclusive Deals',
                                style: TextStyle(fontSize: 18, color: Colors.white70)),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade400,
                                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 18),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {},
                              child: const Text('Start Shopping'),
                            ),
                          ],
                        ),
                      ),
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
                          right: 0, top: 0, bottom: 0,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: _deviceImage(
                                image: 'assets/images/group.png', height: 400, isPrimary: true),
                          ),
                        ),
                        Positioned(
                          right: 150, bottom: 6,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent.withOpacity(0.8),
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: widget.onDownloadTap,
                            icon: const Icon(Icons.download, color: Colors.black),
                            label: const Text("Télécharger l'app",
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  GALAXY PAINTER
// ─────────────────────────────────────────────
class GalaxyPainter extends CustomPainter {
  final double progress;
  final List<Offset> stars;
  final List<double> sizes;
  final List<double> opacities;
  final double movementRange;

  const GalaxyPainter({
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
      final y = (stars[i].dy * size.height + progress * movementRange) % size.height;
      paint.color = Colors.white.withOpacity(opacities[i]);
      canvas.drawCircle(Offset(x, y), sizes[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant GalaxyPainter old) => old.progress != progress;
}

// ─────────────────────────────────────────────
//  ANIMATED CATEGORY CARD
// ─────────────────────────────────────────────
class _AnimatedCategoryCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color color;
  final int delay;
  final VoidCallback? onTap;
  final bool isSelected;

  const _AnimatedCategoryCard({
    required this.icon,
    required this.title,
    required this.color,
    this.delay = 0,
    this.onTap,
    this.isSelected = false,
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
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _scaleAnim = Tween<double>(begin: 1, end: 1.08)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _controller.forward();
        setState(() => _hovered = true);
      },
      onExit: (_) {
        _controller.reverse();
        setState(() => _hovered = false);
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 180,
            height: 100,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: widget.color.withOpacity(widget.isSelected ? 0.35 : 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 6)),
              ],
              border: Border.all(
                  color: (_hovered || widget.isSelected) ? widget.color : Colors.transparent,
                  width: 2),
              image: const DecorationImage(
                image: AssetImage('assets/images/bg_stars_wb.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(widget.isSelected ? 0.55 : 0.4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: widget.color.withOpacity(0.2), shape: BoxShape.circle),
                    padding: const EdgeInsets.all(10),
                    child: Icon(widget.icon, color: widget.color, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(widget.title,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                        overflow: TextOverflow.ellipsis),
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

// ─────────────────────────────────────────────
//  BEST SELLER CAROUSEL
// ─────────────────────────────────────────────
class _BestSellerCarousel extends StatefulWidget {
  final List<Product> products;
  const _BestSellerCarousel({required this.products});

  @override
  State<_BestSellerCarousel> createState() => _BestSellerCarouselState();
}

class _BestSellerCarouselState extends State<_BestSellerCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.25);
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_isHovered) return;
      _currentPage++;
      _pageController.animateToPage(_currentPage,
          duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _moveTo(int step) {
    _currentPage = (_currentPage + step).clamp(0, widget.products.length * 1000);
    _pageController.animateToPage(_currentPage,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
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
            controller: _pageController,
            itemBuilder: (_, i) {
              final product = widget.products[i % widget.products.length];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _BestSellerCard(product: product),
              );
            },
          ),
          Positioned(left: 4,
              child: IconButton(
                icon: const CircleAvatar(radius: 18, backgroundColor: Colors.white,
                    child: Icon(Icons.chevron_left, color: Colors.black87)),
                onPressed: () => _moveTo(-2),
              )),
          Positioned(right: 4,
              child: IconButton(
                icon: const CircleAvatar(radius: 18, backgroundColor: Colors.white,
                    child: Icon(Icons.chevron_right, color: Colors.black87)),
                onPressed: () => _moveTo(2),
              )),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  BEST SELLER CARD
// ─────────────────────────────────────────────
class _BestSellerCard extends StatelessWidget {
  final Product product;
  const _BestSellerCard({required this.product});

  void _openDetail(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 120, vertical: 80),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: DetailProductPopup(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HoverScaleCard(
      onTap: () => _openDetail(context),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.85),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 10))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.redAccent, Colors.orange]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('HOT',
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              const Icon(Icons.favorite_border, size: 18, color: Colors.grey),
            ]),
            const SizedBox(height: 10),
            Expanded(child: Center(child: Text(product.image, style: const TextStyle(fontSize: 42)))),
            const SizedBox(height: 10),
            Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('\$${product.price}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: primaryBlue)),
              Container(
                decoration: BoxDecoration(color: primaryBlue, borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.shopping_cart, color: Colors.white, size: 16),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PROMO CARD
// ─────────────────────────────────────────────
class _PromoCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return HoverScaleCard(
      onTap: () => Navigator.pushNamed(context, AppRoutes.promo, arguments: categoryName),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 6))],
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(
                    color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
                child: Center(child: Text(emoji, style: const TextStyle(fontSize: 30))),
              ),
              const SizedBox(height: 15),
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 8),
              Text(description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  WHY ITEM
// ─────────────────────────────────────────────
class _WhyItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _WhyItem({required this.icon, required this.title, required this.subtitle});

  @override
  State<_WhyItem> createState() => _WhyItemState();
}

class _WhyItemState extends State<_WhyItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: _hovered ? primaryBlue.withOpacity(0.04) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _hovered ? primaryBlue.withOpacity(0.15) : primaryBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(widget.icon, color: primaryBlue, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: _hovered ? primaryBlue : textDark)),
                  const SizedBox(height: 4),
                  Text(widget.subtitle,
                      style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SOCIAL CHIP
// ─────────────────────────────────────────────
class _SocialChip extends StatefulWidget {
  final IconData icon;
  final Color color;
  const _SocialChip({required this.icon, required this.color});

  @override
  State<_SocialChip> createState() => _SocialChipState();
}

class _SocialChipState extends State<_SocialChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(_hovered ? 16 : 14),
          decoration: BoxDecoration(
            color: widget.color.withOpacity(_hovered ? 1.0 : 0.85),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(_hovered ? 0.7 : 0.4),
                blurRadius: _hovered ? 18 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(widget.icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  FOOTER WIDGETS
// ─────────────────────────────────────────────
class _FooterColumnLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Image.asset('assets/images/logo.png', height: 36),
          const SizedBox(width: 10),
          const Text('DJIBSOUQ',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                  fontSize: 20, letterSpacing: 1.5)),
        ]),
        const SizedBox(height: 16),
        Text('Your Online Command Hub\nin Djibouti.',
            style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 14, height: 1.7)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.android, color: Colors.greenAccent.shade400, size: 20),
              const SizedBox(width: 8),
              Text('Available on Play Store',
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }
}

class _FooterColumnLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const links = ['Home', 'Categories', 'Best Sellers', 'Featured Products', 'Contact'];
    return _FooterColumn(title: 'Quick Links', children: links.map((l) => _FooterNavLink(l)).toList());
  }
}

class _FooterColumnCustomer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const services = ['Help Center', 'Returns', 'Shipping Info', 'Track Orders', 'Gift Cards'];
    return _FooterColumn(title: 'Customer Service', children: services.map((s) => _FooterNavLink(s)).toList());
  }
}

class _FooterColumnSocials extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const socials = [
      (icon: Icons.facebook, color: Color(0xFF1877F2)),
      (icon: Icons.camera_alt, color: Color(0xFFE1306C)),
      (icon: Icons.chat, color: Color(0xFF29B6F6)),
      (icon: Icons.video_call, color: Color(0xFFFF0000)),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FooterSectionTitle('Follow Us'),
        const SizedBox(height: 20),
        Wrap(spacing: 12, runSpacing: 12,
            children: socials.map((s) => _SocialChip(icon: s.icon, color: s.color)).toList()),
        const SizedBox(height: 28),
        _FooterSectionTitle('Contact'),
        const SizedBox(height: 12),
        _FooterContactRow(Icons.email_outlined, 'hello@djibsouq.dj'),
        const SizedBox(height: 8),
        _FooterContactRow(Icons.phone_outlined, '+253 77 00 00 00'),
      ],
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _FooterColumn({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_FooterSectionTitle(title), const SizedBox(height: 16), ...children],
    );
  }
}

class _FooterSectionTitle extends StatelessWidget {
  final String text;
  const _FooterSectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 0.5));
  }
}

class _FooterNavLink extends StatefulWidget {
  final String label;
  const _FooterNavLink(this.label);

  @override
  State<_FooterNavLink> createState() => _FooterNavLinkState();
}

class _FooterNavLinkState extends State<_FooterNavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            style: TextStyle(
                fontSize: 14,
                color: _hovered ? Colors.white : Colors.white.withOpacity(0.4)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: _hovered ? 12 : 0,
                  child: _hovered
                      ? const Icon(Icons.arrow_forward, size: 10, color: Colors.white)
                      : const SizedBox.shrink(),
                ),
                if (_hovered) const SizedBox(width: 4),
                Text(widget.label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FooterContactRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: Colors.white.withOpacity(0.35)),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.4))),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  const _FooterLink(this.label);

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {},
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          style: TextStyle(
              fontSize: 13,
              color: _hovered ? Colors.white : Colors.white.withOpacity(0.35)),
          child: Text(widget.label),
        ),
      ),
    );
  }
}