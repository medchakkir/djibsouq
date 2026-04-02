import 'package:flutter/material.dart';
import 'package:dj/models/product_models.dart';

class FeaturedProductCard extends StatefulWidget {
  final Product product;
  final int index;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;

  const FeaturedProductCard({
    super.key,
    required this.product,
    required this.index,
    this.onTap,
    this.onFavorite,
  });

  @override
  State<FeaturedProductCard> createState() => _FeaturedProductCardState();
}

class _FeaturedProductCardState extends State<FeaturedProductCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.reverse();
  void _onTapUp(TapUpDetails _) => _controller.forward();
  void _onTapCancel() => _controller.forward();

  // ─── Responsive breakpoints (basé sur la largeur de l'écran réel) ──────────
  static const double _kMobile = 600;
  static const double _kTablet = 1024;

  _CardSizes _sizes(double screenWidth) {
    if (screenWidth < _kMobile) {
      // Mobile : carte étroite dans une ListView horizontale (~150px de large)
      return const _CardSizes(
        cardWidth: 150,
        imageHeight: 120,
        titleSize: 11.5,
        priceSize: 13,
        badgeSize: 9,
        padding: 8,
        starSize: 11,
        radius: 12,
      );
    } else if (screenWidth < _kTablet) {
      // Tablette
      return const _CardSizes(
        cardWidth: 190,
        imageHeight: 160,
        titleSize: 13,
        priceSize: 15,
        badgeSize: 10,
        padding: 11,
        starSize: 13,
        radius: 14,
      );
    } else {
      // Desktop
      return const _CardSizes(
        cardWidth: 250,
        imageHeight: 210,
        titleSize: 15,
        priceSize: 18,
        badgeSize: 11,
        padding: 15,
        starSize: 15,
        radius: 16,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // On utilise MediaQuery.of(context).size.width pour les breakpoints
    // plutôt que constraints (qui reflète la taille du parent, pas de l'écran).
    final screenWidth = MediaQuery.of(context).size.width;
    final s = _sizes(screenWidth);

    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onTap,
        child: SizedBox(
          // Largeur fixe : la carte s'adapte selon le breakpoint
          width: s.cardWidth,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(s.radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(s.radius),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize.min → la carte prend exactement la hauteur
                // de son contenu, sans jamais déborder.
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ImageSection(product: widget.product, sizes: s),
                  _DetailsSection(
                    product: widget.product,
                    sizes: s,
                    isFavorited: _isFavorited,
                    onFavorite: () {
                      setState(() => _isFavorited = !_isFavorited);
                      widget.onFavorite?.call();
                    },
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

// ─── Image Section ─────────────────────────────────────────────────────────

class _ImageSection extends StatelessWidget {
  final Product product;
  final _CardSizes sizes;

  const _ImageSection({required this.product, required this.sizes});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Product image
        SizedBox(
          height: sizes.imageHeight,
          width: double.infinity,
          child: Container(
            color: const Color(0xFFF3F4F6),
            child: const Center(
              child: Icon(Icons.image_outlined, size: 48, color: Color(0xFFD1D5DB)),
            ),
          ),
        ),

        // Category badge
        Positioned(
          top: 10,
          right: 10,
          child: _Badge(
            label: product.category,
            color: const Color(0xFF1E3A8A).withOpacity(0.85),
            fontSize: sizes.badgeSize,
          ),
        ),
      ],
    );
  }
}

// ─── Details Section ───────────────────────────────────────────────────────

class _DetailsSection extends StatelessWidget {
  final Product product;
  final _CardSizes sizes;
  final bool isFavorited;
  final VoidCallback onFavorite;

  const _DetailsSection({
    required this.product,
    required this.sizes,
    required this.isFavorited,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final p = sizes.padding;

    return Padding(
      // Padding uniforme et compact, proportionnel au breakpoint
      padding: EdgeInsets.symmetric(horizontal: p, vertical: p * 0.75),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,   // ← clé : ne jamais prendre plus de place que nécessaire
        children: [
          // ── Titre + Favori ──────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product.title,
                  style: TextStyle(
                    fontSize: sizes.titleSize,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onFavorite,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    isFavorited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    key: ValueKey(isFavorited),
                    color: isFavorited ? const Color(0xFFEF4444) : Colors.grey[400],
                    size: sizes.starSize + 2,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: p * 0.4),

          // ── Rating ──────────────────────────────────────────────────────
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...List.generate(5, (i) {
                final fill = i < product.rating.floor();
                final half = !fill && i < product.rating;
                return Icon(
                  half
                      ? Icons.star_half_rounded
                      : (fill ? Icons.star_rounded : Icons.star_outline_rounded),
                  color: const Color(0xFFF59E0B),
                  size: sizes.starSize,
                );
              }),
              SizedBox(width: p * 0.35),
              Flexible(
                child: Text(
                  '${product.rating.toStringAsFixed(1)} (${product.reviews})',
                  style: TextStyle(
                    fontSize: sizes.titleSize - 1.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: p * 0.45),

          // ── Prix ────────────────────────────────────────────────────────
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: sizes.priceSize,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E3A8A),
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Helpers ───────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final double fontSize;

  const _Badge({required this.label, required this.color, required this.fontSize});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      );
}

// ─── Responsive size config ────────────────────────────────────────────────

@immutable
class _CardSizes {
  final double cardWidth;
  final double imageHeight;
  final double titleSize;
  final double priceSize;
  final double badgeSize;
  final double padding;
  final double starSize;
  final double radius;

  const _CardSizes({
    required this.cardWidth,
    required this.imageHeight,
    required this.titleSize,
    required this.priceSize,
    required this.badgeSize,
    required this.padding,
    required this.starSize,
    required this.radius,
  });
}