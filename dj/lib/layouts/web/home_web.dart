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
//  BREAKPOINTS
// ─────────────────────────────────────────────
// mobile  : < 600
// tablet  : 600 – 1024
// desktop : > 1024

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color textDark = Color(0xFF111827);

const double mobileBreakpoint = 600.0;
const double tabletBreakpoint = 900.0;

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

  Widget _buildBestSellers() {
    final bestSellers = ProductRepository.getBestSellers();
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < mobileBreakpoint;
      return Container(
        padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 60),
        color: Colors.white,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
                  child: _SectionLabel(label: '🔥 Best Sellers'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: isMobile ? 200 : 220,
                  child: _BestSellerCarousel(products: bestSellers, isMobile: isMobile),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // ─────────────────────────────────────────────
  // PROMO CAROUSEL — OPTIMISÉ & RESPONSIVE
  // ─────────────────────────────────────────────
  Widget _buildPromoCarousel() {
    final promoCategories =
        ProductRepository.categories.where((c) => c.name != 'New Arrivals').toList();

    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < mobileBreakpoint;

      return Container(
        padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 60),
        color: lightGrey,
        child: Center(
          child: SizedBox(
            width: constraints.maxWidth > 1200
                ? 1250
                : constraints.maxWidth * (isMobile ? 0.95 : 0.9),
            child: Column(
              children: [
                _SectionLabel(label: '🎉 Promotions Spéciales', center: true),
                const SizedBox(height: 8),
                const Text(
                  'Découvrez nos offres exceptionnelles par catégorie',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isMobile ? 28 : 40),

                // Liste horizontale
                SizedBox(
                  height: isMobile ? 185 : 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
                    itemCount: promoCategories.length,
                    itemBuilder: (context, i) {
                      final cat = promoCategories[i];
                      return SizedBox(
                        width: isMobile ? 175 : 280,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 8 : 15,
                          ),
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
        ),
      );
    });
  }

  // ─────────────────────────────────────────────
  //  CATEGORIES BAR
  // ─────────────────────────────────────────────
  Widget _buildCategoriesBar() {
    final allCategories = [
      ...ProductRepository.categories,
      Category(name: 'Toutes', icon: 'list_alt', color: Colors.purpleAccent.shade400, id: 10000, image: ''),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < mobileBreakpoint;

      if (isMobile) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allCategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.1,
            ),
            itemBuilder: (context, i) {
              final cat = allCategories[i];
              final isLast = i == allCategories.length - 1;
              return _AnimatedCategoryCard(
                icon: _iconFromName(cat.icon),
                title: cat.name,
                color: cat.color,
                delay: i * 60,
                isMobile: true,
                isSelected: !isLast && _selectedCategory == cat.name,
                onTap: isLast
                    ? () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const CategoriesWeb()))
                    : () => setState(() => _selectedCategory = cat.name),
              );
            },
          ),
        );
      }

      // Tablet & Desktop
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Row(
          children: List.generate(allCategories.length, (i) {
            final cat = allCategories[i];
            final isLast = i == allCategories.length - 1;
            return Flexible(
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
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
            );
          }),
        ),
      );
    });
  }

  // ─────────────────────────────────────────────
  //  FEATURED PRODUCTS
  // ─────────────────────────────────────────────
  Widget _buildFeaturedProducts() {
    final products = ProductRepository.getProductsByCategory(_selectedCategory);
    final limited = products.length > 8 ? products.sublist(0, 8) : products;

    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < mobileBreakpoint;
      final isTablet = constraints.maxWidth < tabletBreakpoint;

      int crossAxis = 4;
      double aspectRatio = 0.85;

      if (isMobile) {
        crossAxis = 2;
        aspectRatio = 0.68; // 🔥 plus de hauteur
      } else if (isTablet) {
        crossAxis = 3;
        aspectRatio = 0.72;
      }

      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 24,
          vertical: isMobile ? 32 : 40,
        ),
        color: Colors.white,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedCategory,
                            style: TextStyle(
                              fontSize: isMobile ? 22 : 26,
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
                                decoration: BoxDecoration(color: primaryBlue, borderRadius: BorderRadius.circular(10)),
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
                const SizedBox(height: 24),
                limited.isEmpty
                    ? _EmptyCategory(category: _selectedCategory)
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: limited.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxis,
                          mainAxisSpacing: isMobile ? 16 : 20,
                          crossAxisSpacing: isMobile ? 16 : 20,
                          childAspectRatio: aspectRatio,
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
    });
  }

  // ─────────────────────────────────────────────
  //  DOWNLOAD SECTION
  // ─────────────────────────────────────────────
  Widget _buildDownloadSection() {
    return Container(
      key: _downloadKey,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF1E3A8A)],
        ),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final isMobile = constraints.maxWidth < mobileBreakpoint;

        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 60 : 80,
            horizontal: isMobile ? 24 : 60,
          ),
          child: isMobile
              ? Column(
                  children: [
                    _downloadTextSection(isMobile: true),
                    const SizedBox(height: 40),
                    Center(
                      child: _deviceImage(
                        image: 'assets/images/swift_phone.png',
                        height: 260,
                        scale: 1.05,
                        isPrimary: true,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _downloadTextSection()),
                    const SizedBox(width: 50),
                    Expanded(child: _downloadDeviceSection()),
                  ],
                ),
        );
      }),
    );
  }

  Widget _downloadTextSection({bool isMobile = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shop Smarter with\nDJIBSOUQ Mobile App',
          style: TextStyle(
            fontSize: isMobile ? 32 : 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Browse thousands of products, track orders instantly\nand get exclusive mobile-only deals.',
          style: TextStyle(fontSize: isMobile ? 15.5 : 18, color: Colors.white70, height: 1.55),
        ),
        const SizedBox(height: 28),
        _featureItem(Icons.flash_on, 'Exclusive Flash Deals'),
        _featureItem(Icons.notifications_active, 'Real-time Order Tracking'),
        _featureItem(Icons.security, 'Secure & Fast Checkout'),
        const SizedBox(height: 40),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent.shade400,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 28,
              vertical: isMobile ? 16 : 18,
            ),
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
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final stackH = w < 500 ? w * 0.95 : 420.0;
      final computerH = stackH * 0.70;
      final padH = stackH * 0.52;
      final phoneH = stackH * 0.55;

      return SizedBox(
        height: stackH,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: stackH, height: stackH,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.blueAccent.withOpacity(0.25), Colors.transparent],
                ),
              ),
            ),
            Positioned(
              left: w * 0.04,
              top: 0, bottom: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _deviceImage(
                  image: 'assets/images/swift_computer.png',
                  height: computerH,
                  scale: 1.05,
                  opacity: 0.95,
                ),
              ),
            ),
            Positioned(
              right: w * 0.10,
              bottom: stackH * 0.05,
              child: _deviceImage(
                image: 'assets/images/swift_pad.png',
                height: padH,
                scale: 1.05,
              ),
            ),
            Positioned(
              bottom: stackH * 0.02,
              child: _deviceImage(
                image: 'assets/images/swift_phone.png',
                height: phoneH,
                scale: 1.1,
                isPrimary: true,
              ),
            ),
          ],
        ),
      );
    });
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

    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < mobileBreakpoint;
      return Container(
        padding: EdgeInsets.symmetric(vertical: isMobile ? 32 : 40, horizontal: isMobile ? 16 : 40),
        color: lightGrey,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: isMobile
                ? Column(children: items.map((e) => Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: e)).toList())
                : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: items.map((e) => Expanded(child: e)).toList()),
          ),
        ),
      );
    });
  }

  // ─────────────────────────────────────────────
  //  NEWSLETTER
  // ─────────────────────────────────────────────
  Widget _buildNewsletterSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF2A2D43), Color(0xFF1E3A8A)]),
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
              ),
              child: isSmall
                  ? Column(children: [_newsletterBox(isMobile: true), const SizedBox(height: 30), _socialRow()])
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

  Widget _newsletterBox({bool isMobile = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Never Miss a Deal!',
            style: TextStyle(fontSize: isMobile ? 22 : 30, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 12),
        const Text(
          'Subscribe to get exclusive offers, new arrivals, and updates straight to your inbox.',
          style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
        ),
        const SizedBox(height: 24),
        isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _emailField(),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      backgroundColor: Colors.greenAccent.shade400,
                    ),
                    child: const Text('Subscribe',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(child: _emailField()),
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

  Widget _emailField() {
    return TextField(
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
          LayoutBuilder(builder: (context, constraints) {
            final isMobile = constraints.maxWidth < mobileBreakpoint;
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: 64,
                horizontal: isMobile ? 24 : 60,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1300),
                  child: LayoutBuilder(builder: (context, c) {
                    final isSmall = c.maxWidth < 900;
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
                        LayoutBuilder(builder: (context, c2) {
                          final narrow = c2.maxWidth < 700;
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
            );
          }),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HERO GALAXY — responsive
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
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 600;
      final isTablet = constraints.maxWidth < 900;
      final heroHeight = isMobile ? 480.0 : (isTablet ? 400.0 : 350.0);

      return SizedBox(
        height: heroHeight,
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
            // Mobile : layout vertical centré
            if (isMobile)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                                fontSize: 30, fontWeight: FontWeight.bold,
                                color: Colors.white, height: 1.3)),
                        const SizedBox(height: 14),
                        const Text('Latest Electronics, Exclusive Deals',
                            style: TextStyle(fontSize: 15, color: Colors.white70)),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade400,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {},
                              child: const Text('Start Shopping'),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.greenAccent.withOpacity(0.8),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: widget.onDownloadTap,
                              icon: const Icon(Icons.download, color: Colors.black, size: 16),
                              label: const Text("App", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              // Tablet / Desktop : layout horizontal
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32 : 60,
                  vertical: 10,
                ),
                child: Row(
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
                              Text('Your Online Command Hub\nin Djibouti',
                                  style: TextStyle(
                                      fontSize: isTablet ? 30 : 42,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 1.3)),
                              const SizedBox(height: 20),
                              const Text('Latest Electronics, Exclusive Deals',
                                  style: TextStyle(fontSize: 18, color: Colors.white70)),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade400,
                                  padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 18),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () {},
                                child: const Text('Start Shopping'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Tablette : image réduite visible — Desktop : taille normale
                    ...[
                      const SizedBox(width: 50),
                      SizedBox(
                        height: isTablet ? 300 : 420,
                        width: isTablet
                            ? constraints.maxWidth * 0.38
                            : min(650, constraints.maxWidth * 0.55),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              right: 0, top: 0, bottom: 0,
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: _deviceImage(
                                  image: 'assets/images/group.png',
                                  height: isTablet ? 260 : 400,
                                  isPrimary: true,
                                ),
                              ),
                            ),
                            Positioned(
                              right: isTablet ? 60 : 150,
                              bottom: 6,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.greenAccent.withOpacity(0.8),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 14 : 28,
                                    vertical: isTablet ? 12 : 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                ),
                                onPressed: widget.onDownloadTap,
                                icon: const Icon(Icons.download, color: Colors.black),
                                label: Text(
                                  isTablet ? "Télécharger" : "Télécharger l'app",
                                  style: const TextStyle(
                                      color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────
//  GALAXY PAINTER (inchangé)
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
// FEATURED PRODUCT CARD — OPTIMISÉ MOBILE
// ─────────────────────────────────────────────
class _FeaturedProductCard extends StatefulWidget {
  final Product product;
  final int index;

  const _FeaturedProductCard({
    required this.product,
    required this.index,
  });

  @override
  State<_FeaturedProductCard> createState() => _FeaturedProductCardState();
}

class _FeaturedProductCardState extends State<_FeaturedProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  bool _hovered = false;
  bool _favorited = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scale = Tween<double>(begin: 1, end: 1.04).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openDetail() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: DetailProductPopup(product: widget.product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1024;

    return MouseRegion(
      onEnter: (_) {
        if (!isMobile) {
          _controller.forward();
          setState(() => _hovered = true);
        }
      },
      onExit: (_) {
        if (!isMobile) {
          _controller.reverse();
          setState(() => _hovered = false);
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Transform.scale(
            scale: _scale.value,
            child: GestureDetector(
              onTap: _openDetail,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isMobile ? 14 : 18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        _hovered ? 0.15 : 0.08,
                      ),
                      blurRadius: _hovered ? 18 : 10,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IMAGE
                    AspectRatio(
                      aspectRatio: isMobile ? 1.1 : 1.2,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: lightGrey,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(isMobile ? 16 : 20),
                              ),
                            ),
                            child: Center(
                              child: AnimatedScale(
                                scale: (_hovered && !isMobile) ? 1.08 : 1.0,
                                duration: const Duration(milliseconds: 300),
                                child: Text(
                                  widget.product.image,
                                  style: TextStyle(
                                    fontSize: isMobile ? 48 : 56,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // BADGE
                          if (widget.product.isBestSeller)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Colors.redAccent, Colors.orange],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'HOT',
                                  style: TextStyle(color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ),

                          // FAVORITE
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => setState(() => _favorited = !_favorited),
                              child: Icon(
                                _favorited ? Icons.favorite : Icons.favorite_border,
                                size: 18,
                                color: _favorited ? Colors.red : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // CONTENT (flexible)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(isMobile ? 10 : 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // CATEGORY
                            Text(
                              widget.product.category,
                              style: TextStyle(
                                fontSize: isMobile ? 10 : 11,
                                color: primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 4),

                            // TITLE
                            Text(
                              widget.product.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: isMobile ? 12 : 13,
                                fontWeight: FontWeight.w600,
                                color: textDark,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // RATING
                            Row(
                              children: [
                                ...List.generate(
                                  5,
                                  (i) => Icon(
                                    i < widget.product.rating.floor()
                                        ? Icons.star
                                        : Icons.star_border,
                                    size: 12,
                                    color: Colors.amber,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "(${widget.product.reviews})",
                                  style: TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),

                            const Spacer(),

                            // PRICE + BTN
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${widget.product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: isMobile ? 14 : 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryBlue,
                                  ),
                                ),

                                InkWell(
                                  onTap: _openDetail,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: primaryBlue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.add_shopping_cart,
                                      color: Colors.white,
                                      size: 16,
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
          );
        },
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
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                    color: _hovered ? Colors.white : primaryBlue),
                child: const Text('Voir tout'),
              ),
              const SizedBox(width: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.translationValues(_hovered ? 3 : 0, 0, 0),
                child: Icon(Icons.arrow_forward, size: 14, color: _hovered ? Colors.white : primaryBlue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  EMPTY CATEGORY
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
//  ANIMATED CATEGORY CARD — responsive
// ─────────────────────────────────────────────
class _AnimatedCategoryCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color color;
  final int delay;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isMobile;

  const _AnimatedCategoryCard({
    required this.icon,
    required this.title,
    required this.color,
    this.delay = 0,
    this.onTap,
    this.isSelected = false,
    this.isMobile = false,
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
      onEnter: (_) { _controller.forward(); setState(() => _hovered = true); },
      onExit: (_) { _controller.reverse(); setState(() => _hovered = false); },
      child: GestureDetector(
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: widget.isMobile ? double.infinity : 180,
            height: widget.isMobile ? 60 : 100,
            margin: EdgeInsets.symmetric(horizontal: widget.isMobile ? 0 : 6),
            padding: EdgeInsets.symmetric(
              horizontal: widget.isMobile ? 12 : 16,
              vertical: widget.isMobile ? 8 : 12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(widget.isSelected ? 0.35 : 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(
                color: (_hovered || widget.isSelected) ? widget.color : Colors.transparent,
                width: 2,
              ),
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
                    padding: EdgeInsets.all(widget.isMobile ? 6 : 10),
                    child: Icon(widget.icon, color: widget.color, size: widget.isMobile ? 18 : 28),
                  ),
                  SizedBox(width: widget.isMobile ? 8 : 14),
                  Expanded(
                    child: Text(widget.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: widget.isMobile ? 13 : 16,
                        ),
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
//  BEST SELLER CAROUSEL — responsive
// ─────────────────────────────────────────────
class _BestSellerCarousel extends StatefulWidget {
  final List<Product> products;
  final bool isMobile;
  const _BestSellerCarousel({required this.products, this.isMobile = false});

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
    _pageController = PageController(viewportFraction: widget.isMobile ? 0.6 : 0.25);
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
          Positioned(
            left: 4,
            child: IconButton(
              icon: const CircleAvatar(radius: 18, backgroundColor: Colors.white,
                  child: Icon(Icons.chevron_left, color: Colors.black87)),
              onPressed: () => _moveTo(-2),
            ),
          ),
          Positioned(
            right: 4,
            child: IconButton(
              icon: const CircleAvatar(radius: 18, backgroundColor: Colors.white,
                  child: Icon(Icons.chevron_right, color: Colors.black87)),
              onPressed: () => _moveTo(2),
            ),
          ),
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
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return HoverScaleCard(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.promo,
        arguments: categoryName,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 6),
            )
          ],
        ),
        child: AspectRatio(
          aspectRatio: isMobile ? 1.1 : 1.2,
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 14 : 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ICON
                Container(
                  width: isMobile ? 50 : 60,
                  height: isMobile ? 50 : 60,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: TextStyle(
                        fontSize: isMobile ? 24 : 30,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // TITLE
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 6),

                // DESCRIPTION (flexible)
                Expanded(
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    maxLines: isMobile ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 13,
                      color: Colors.black54,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // CTA (optionnel stylé)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Voir",
                    style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
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
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,
                          color: _hovered ? primaryBlue : textDark)),
                  const SizedBox(height: 4),
                  Text(widget.subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
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
//  FOOTER WIDGETS (inchangés)
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
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1.5)),
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
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 0.5));
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
            style: TextStyle(fontSize: 14, color: _hovered ? Colors.white : Colors.white.withOpacity(0.4)),
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
          style: TextStyle(fontSize: 13, color: _hovered ? Colors.white : Colors.white.withOpacity(0.35)),
          child: Text(widget.label),
        ),
      ),
    );
  }
}