import 'package:flutter/material.dart';
import 'package:dj/widgets/web_header.dart';
import 'package:dj/data/product_repository.dart';
import 'package:dj/models/product_models.dart';
import 'package:dj/layouts/web/pages_web/detail_product_popup.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color textDark = Color(0xFF111827);

// ─────────────────────────────────────────────
//  PROMO PAGE
// ─────────────────────────────────────────────
class PromoWeb extends StatefulWidget {
  final String? initialCategory;
  const PromoWeb({super.key, this.initialCategory});

  @override
  State<PromoWeb> createState() => _PromoWebState();
}

class _PromoWebState extends State<PromoWeb> {
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? 'Toutes';
  }

  List<Product> get _filteredProducts {
    final all = ProductRepository.products;
    if (_selectedCategory == 'Toutes') return all.take(20).toList();
    return all.where((p) => p.category == _selectedCategory).take(20).toList();
  }

  List<String> get _categories => [
        'Toutes',
        ...ProductRepository.categories.map((c) => c.name),
      ];

  // ─────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: Column(
        children: [
          buildHeader(currentPage: 'Promo'),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeroBanner(),
                    const SizedBox(height: 60),
                    _buildSectionHeader(),
                    const SizedBox(height: 30),
                    _buildCategoryFilters(),
                    const SizedBox(height: 50),
                    _filteredProducts.isEmpty
                        ? _buildEmptyState()
                        : _buildGrid(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  HERO BANNER
  // ─────────────────────────────────────────────
  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withOpacity(0.35),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Cercles décoratifs
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Positioned(
            right: 80,
            bottom: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          Row(
            children: [
              // ── Texte ──
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: const Text(
                          '🎉  Offre limitée',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "PRÉPAREZ L'AÏD",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '-20% sur les vêtements d\'Aïd',
                        style: TextStyle(fontSize: 17, color: Colors.white70),
                      ),
                      const SizedBox(height: 28),
                      ElevatedButton(
                        onPressed: () => setState(() => _selectedCategory = 'Habits'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: primaryBlue,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Découvrir',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Image ──
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  child: Image.asset(
                    'assets/images/aid_banner.png',
                    fit: BoxFit.cover,
                    height: 280,
                    // FIX: errorBuilder pour éviter crash si image manquante
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.white.withOpacity(0.05),
                      child: const Center(
                        child: Text('🛍️', style: TextStyle(fontSize: 80)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  SECTION HEADER
  // ─────────────────────────────────────────────
  Widget _buildSectionHeader() {
    return Column(
      children: [
        const Text(
          'Produits en Promotion',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: textDark),
        ),
        const SizedBox(height: 10),
        Text(
          '${_filteredProducts.length} produit${_filteredProducts.length > 1 ? 's' : ''} disponible${_filteredProducts.length > 1 ? 's' : ''}',
          style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  CATEGORY FILTERS
  // ─────────────────────────────────────────────
  Widget _buildCategoryFilters() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: _categories.map((cat) {
        final isSelected = _selectedCategory == cat;
        return _FilterChip(
          label: cat,
          isSelected: isSelected,
          onTap: () => setState(() => _selectedCategory = cat),
        );
      }).toList(),
    );
  }

  // ─────────────────────────────────────────────
  //  GRID
  // ─────────────────────────────────────────────
  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (_, i) => _PromoCard(product: _filteredProducts[i]),
    );
  }

  // ─────────────────────────────────────────────
  //  EMPTY STATE
  // ─────────────────────────────────────────────
  Widget _buildEmptyState() {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_offer_outlined, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'Aucune promotion pour "$_selectedCategory"',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => setState(() => _selectedCategory = 'Toutes'),
              child: const Text('Voir toutes les promos'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  FILTER CHIP — hover animé
// ─────────────────────────────────────────────
class _FilterChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected || _hovered;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isSelected ? primaryBlue : active ? primaryBlue.withOpacity(0.08) : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: widget.isSelected ? primaryBlue : primaryBlue.withOpacity(0.3),
            ),
            boxShadow: widget.isSelected
                ? [BoxShadow(color: primaryBlue.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 4))]
                : [],
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: widget.isSelected ? Colors.white : primaryBlue,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PROMO CARD
// ─────────────────────────────────────────────
class _PromoCard extends StatefulWidget {
  final Product product;
  const _PromoCard({required this.product});

  @override
  State<_PromoCard> createState() => _PromoCardState();
}

class _PromoCardState extends State<_PromoCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _shadow;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 220));
    _scale = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _shadow = Tween<double>(begin: 8, end: 24).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Prix original simulé (+20%)
  double get _originalPrice => widget.product.price * 1.25;

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
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => Transform.scale(
          scale: _scale.value,
          child: GestureDetector(
            onTap: _openDetail,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: _shadow.value,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Image + Badge ──
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: lightGrey,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                          ),
                          child: Center(
                            child: Text(widget.product.image,
                                style: const TextStyle(fontSize: 56)),
                          ),
                        ),
                        // Badge -20%
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18),
                                bottomRight: Radius.circular(14),
                              ),
                            ),
                            child: const Text(
                              '-20%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Icone favoris
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6),
                              ],
                            ),
                            child: const Icon(Icons.favorite_border, size: 16, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Infos ──
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600, color: textDark),
                        ),
                        const SizedBox(height: 8),
                        // Prix barré + nouveau prix
                        Row(
                          children: [
                            Text(
                              '\$${_originalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade400,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 8),
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
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _openDetail,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryBlue,
                              padding: const EdgeInsets.symmetric(vertical: 11),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Ajouter au panier',
                              style: TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                        ),
                      ],
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