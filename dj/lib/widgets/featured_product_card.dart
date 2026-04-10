import 'package:flutter/material.dart';
import 'package:dj/models/product_models.dart';

class FeaturedProductCard extends StatefulWidget {
  final Product product;
  final int index;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onAddToCart;
  final VoidCallback? onBuyNow;

  const FeaturedProductCard({
    super.key,
    required this.product,
    required this.index,
    this.onTap,
    this.onFavorite,
    this.onAddToCart,
    this.onBuyNow,
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
                    onAddToCart: widget.onAddToCart,
                    onBuyNow: widget.onBuyNow,
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
          child: Image.network(
            product.image,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _ImagePlaceholder(height: sizes.imageHeight),
          ),
        ),

        // Discount badge (shown only if product has a discount)
        if (product.discount != null && product.discount! > 0)
          Positioned(
            top: 10,
            left: 10,
            child: _Badge(
              label: '-${product.discount}%',
              color: const Color(0xFFEF4444),
              fontSize: sizes.badgeSize,
            ),
          ),

        // Category badge
        if (product.category.isNotEmpty)
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
  final VoidCallback? onAddToCart;
  final VoidCallback? onBuyNow;

  const _DetailsSection({
    required this.product,
    required this.sizes,
    required this.isFavorited,
    required this.onFavorite,
    this.onAddToCart,
    this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    final p = sizes.padding;
    // Sur mobile (carte ~150px) : icônes seules pour gagner de la place
    // Sur tablette/desktop : icône + texte court
    final isMobileCard = sizes.cardWidth <= 160;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: p, vertical: p * 0.75),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: sizes.priceSize,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E3A8A),
                  letterSpacing: -0.3,
                ),
              ),
              if (product.originalPrice != null) ...[
                SizedBox(width: p * 0.4),
                Text(
                  '\$${product.originalPrice!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: sizes.priceSize - 3,
                    color: Colors.grey[400],
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),

          SizedBox(height: p * 0.65),

          // ── Boutons Panier + Acheter ─────────────────────────────────────
          _ActionButtons(
            sizes: sizes,
            isMobileCard: isMobileCard,
            onAddToCart: onAddToCart,
            onBuyNow: onBuyNow,
          ),
        ],
      ),
    );
  }
}

// ─── Boutons d'action (Panier + Acheter) ───────────────────────────────────

class _ActionButtons extends StatefulWidget {
  final _CardSizes sizes;
  final bool isMobileCard;
  final VoidCallback? onAddToCart;
  final VoidCallback? onBuyNow;

  const _ActionButtons({
    required this.sizes,
    required this.isMobileCard,
    this.onAddToCart,
    this.onBuyNow,
  });

  @override
  State<_ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<_ActionButtons>
    with SingleTickerProviderStateMixin {
  // Animation de confirmation "ajouté au panier" (✓ pendant 1.2s)
  late final AnimationController _checkCtrl;
  bool _added = false;

  @override
  void initState() {
    super.initState();
    _checkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..addStatusListener((s) {
        if (s == AnimationStatus.completed) {
          if (mounted) setState(() => _added = false);
          _checkCtrl.reset();
        }
      });
  }

  @override
  void dispose() {
    _checkCtrl.dispose();
    super.dispose();
  }

  void _handleAddToCart() {
    setState(() => _added = true);
    _checkCtrl.forward();
    widget.onAddToCart?.call();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.sizes;
    final p = s.padding;
    // Taille des boutons selon le breakpoint
    final btnHeight = s.cardWidth <= 160 ? 28.0 : 32.0;
    final iconSize = s.cardWidth <= 160 ? 14.0 : 15.0;
    final fontSize = s.titleSize - 1.0;
    final gap = p * 0.5;

    return Row(
      children: [
        // ── Bouton Panier ──────────────────────────────────────────────────
        Expanded(
          child: _CartButton(
            height: btnHeight,
            iconSize: iconSize,
            fontSize: fontSize,
            isMobile: widget.isMobileCard,
            added: _added,
            onTap: _handleAddToCart,
          ),
        ),

        SizedBox(width: gap),

        // ── Bouton Acheter maintenant ──────────────────────────────────────
        Expanded(
          child: _BuyButton(
            height: btnHeight,
            iconSize: iconSize,
            fontSize: fontSize,
            isMobile: widget.isMobileCard,
            onTap: widget.onBuyNow,
          ),
        ),
      ],
    );
  }
}

// ── Bouton Panier avec animation ✓ ─────────────────────────────────────────

class _CartButton extends StatelessWidget {
  final double height;
  final double iconSize;
  final double fontSize;
  final bool isMobile;
  final bool added;
  final VoidCallback onTap;

  const _CartButton({
    required this.height,
    required this.iconSize,
    required this.fontSize,
    required this.isMobile,
    required this.added,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: height,
      decoration: BoxDecoration(
        color: added ? const Color(0xFF16A34A) : const Color(0xFF1E3A8A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: added ? null : onTap,
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: added
                  ? Icon(
                      Icons.check_rounded,
                      key: const ValueKey('check'),
                      color: Colors.white,
                      size: iconSize,
                    )
                  : Row(
                      key: const ValueKey('cart'),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            color: Colors.white, size: iconSize),
                        if (!isMobile) ...[
                          const SizedBox(width: 4),
                          Text(
                            'Panier',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Bouton Acheter maintenant ───────────────────────────────────────────────

class _BuyButton extends StatelessWidget {
  final double height;
  final double iconSize;
  final double fontSize;
  final bool isMobile;
  final VoidCallback? onTap;

  const _BuyButton({
    required this.height,
    required this.iconSize,
    required this.fontSize,
    required this.isMobile,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF1E3A8A), width: 1.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt_rounded,
                      color: const Color(0xFF1E3A8A), size: iconSize),
                  if (!isMobile) ...[
                    const SizedBox(width: 3),
                    Text(
                      'Acheter',
                      style: TextStyle(
                        color: const Color(0xFF1E3A8A),
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Helpers ───────────────────────────────────────────────────────────────


class _ImagePlaceholder extends StatelessWidget {
  final double height;
  const _ImagePlaceholder({required this.height});

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        color: const Color(0xFFF3F4F6),
        child: const Center(
          child: Icon(Icons.image_outlined, size: 48, color: Color(0xFFD1D5DB)),
        ),
      );
}

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