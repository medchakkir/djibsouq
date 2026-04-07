import 'package:flutter/material.dart';
import 'package:dj/models/product_models.dart';

// ─── Tokens ────────────────────────────────────────────────────────────────
const Color _kBlue       = Color(0xFF1E3A8A);
const Color _kBlueBg     = Color(0xFFE6F1FB);
const Color _kRedBg      = Color(0xFFFCEBEB);
const Color _kRedText    = Color(0xFFA32D2D);
const Color _kGreenBg    = Color(0xFFE1F5EE);
const Color _kGreenText  = Color(0xFF0F6E56);
const Color _kSurface    = Color(0xFFF9FAFB);
const Color _kBorder     = Color(0xFFE5E7EB);
const Color _kTextDark   = Color(0xFF111827);
const Color _kTextMuted  = Color(0xFF6B7280);
const Color _kAmber      = Color(0xFFF59E0B);

// ─── Entry point ───────────────────────────────────────────────────────────
/// Show the popup: `DetailProductPopup.show(context, product: p)`
class DetailProductPopup extends StatelessWidget {
  const DetailProductPopup._({required this.product});

  final Product product;

  static Future<void> show(BuildContext context, {required Product product}) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, anim, _, child) => FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          scale: Tween(begin: 0.94, end: 1.0).animate(
            CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
          ),
          child: child,
        ),
      ),
      pageBuilder: (ctx, _, __) => DetailProductPopup._(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: LayoutBuilder(builder: (context, constraints) {
          final width  = MediaQuery.of(context).size.width;
          final height = MediaQuery.of(context).size.height;
          final isMobile = width < 640;

          return Container(
            width:  (isMobile ? width * 0.96 : width * 0.88).clamp(0, 920),
            height: height * (isMobile ? 0.9 : 0.88),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 40,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: isMobile
                  ? _MobileLayout(product: product)
                  : _DesktopLayout(product: product),
            ),
          );
        }),
      ),
    );
  }
}

// ─── Desktop layout : 2 colonnes ──────────────────────────────────────────
class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _ImagePanel(product: product)),
        Container(width: 0.5, color: _kBorder),
        Expanded(
          child: _InfoPanel(
            product: product,
            onClose: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}

// ─── Mobile layout : colonne scrollable ────────────────────────────────────
class _MobileLayout extends StatelessWidget {
  const _MobileLayout({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              _ImagePanel(product: product, maxHeight: 280),
              Positioned(
                top: 12, right: 12,
                child: _CircleBtn(child: Icon(Icons.close_rounded, size: 18, color: _kTextMuted), onTap: () => Navigator.of(context).pop()),
              ),
            ],
          ),
          _InfoPanel(product: product, showClose: false),
        ],
      ),
    );
  }
}

// ─── IMAGE PANEL ──────────────────────────────────────────────────────────
class _ImagePanel extends StatefulWidget {
  const _ImagePanel({required this.product, this.maxHeight});
  final Product product;
  final double? maxHeight;

  @override
  State<_ImagePanel> createState() => _ImagePanelState();
}

class _ImagePanelState extends State<_ImagePanel> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    // En l'absence de liste d'images dans le modèle, on répète l'image principale
    final images = List.generate(4, (_) => widget.product.image);

    return Container(
      color: _kSurface,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Image principale
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: widget.maxHeight ?? double.infinity),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  images[_selected],
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Thumbnails
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (i) {
              final active = i == _selected;
              return GestureDetector(
                onTap: () => setState(() => _selected = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width:  active ? 64 : 54,
                  height: active ? 64 : 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: active ? _kBlue : _kBorder,
                      width: active ? 2 : 1,
                    ),
                    color: Colors.white,
                    boxShadow: active
                        ? [BoxShadow(color: _kBlue.withOpacity(0.2), blurRadius: 8)]
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image.network(images[i], fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox()),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─── INFO PANEL ───────────────────────────────────────────────────────────
class _InfoPanel extends StatefulWidget {
  const _InfoPanel({
    required this.product,
    this.onClose,
    this.showClose = true,
  });

  final Product product;
  final VoidCallback? onClose;
  final bool showClose;

  @override
  State<_InfoPanel> createState() => _InfoPanelState();
}

class _InfoPanelState extends State<_InfoPanel> {
  int  _qty      = 1;
  int  _variant  = 0;
  bool _favorited = false;

  static const _variants = ['Midnight Black', 'Pearl White', 'Ocean Blue'];

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final hasDiscount = p.discount != null && p.discount! > 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row ───────────────────────────────────────────────────
          if (widget.showClose)
            Align(
              alignment: Alignment.topRight,
              child: _CircleBtn(child: Icon(Icons.close_rounded, size: 18, color: _kTextMuted), onTap: widget.onClose),
            ),

          // ── Badges ────────────────────────────────────────────────────
          Wrap(spacing: 6, children: [
            _Pill(p.category, bg: _kBlueBg, fg: const Color(0xFF0C447C)),
            if (hasDiscount)
              _Pill('-${p.discount}%', bg: _kRedBg, fg: _kRedText),
          ]),
          const SizedBox(height: 10),

          // ── Title + Favorite ──────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  p.title,
                  style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w700,
                    color: _kTextDark, height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => _favorited = !_favorited),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
                  child: Icon(
                    _favorited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    key: ValueKey(_favorited),
                    color: _favorited ? Colors.redAccent : _kBorder,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Stars ─────────────────────────────────────────────────────
          _StarRow(rating: p.rating, reviews: p.reviews),
          const SizedBox(height: 14),

          // ── Price ─────────────────────────────────────────────────────
          Row(crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
            Text('\$${p.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: _kBlue)),
            if (p.originalPrice != null) ...[
              const SizedBox(width: 10),
              Text('\$${p.originalPrice!.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 14, color: _kTextMuted,
                      decoration: TextDecoration.lineThrough)),
              const SizedBox(width: 8),
              if (hasDiscount)
                _Pill(
                  'Save \$${(p.originalPrice! - p.price).toStringAsFixed(0)}',
                  bg: _kRedBg, fg: _kRedText,
                ),
            ],
          ]),

          const _Div(),

          // ── Variants (Color) ──────────────────────────────────────────
          const _Label('Color'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: List.generate(_variants.length, (i) {
              final active = i == _variant;
              return GestureDetector(
                onTap: () => setState(() => _variant = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: active ? _kBlueBg : Colors.white,
                    border: Border.all(
                      color: active ? _kBlue : _kBorder, width: active ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    _variants[i],
                    style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500,
                      color: active ? _kBlue : _kTextDark,
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 14),

          // ── Description ───────────────────────────────────────────────
          const _Label('Description'),
          const SizedBox(height: 6),
          Text(
            p.description,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: _kTextMuted, height: 1.7),
          ),

          const _Div(),

          // ── Quantity + stock ──────────────────────────────────────────
          Row(children: [
            _QtyControl(
              value: _qty,
              onDec: () { if (_qty > 1) setState(() => _qty--); },
              onInc: () => setState(() => _qty++),
            ),
            const SizedBox(width: 14),
            _Pill('In stock', bg: _kGreenBg, fg: _kGreenText,
                icon: Icons.check_circle_outline_rounded),
          ]),
          const SizedBox(height: 16),

          // ── Action buttons ────────────────────────────────────────────
          Row(children: [
            Expanded(
              child: _ActionBtn(
                label: 'Buy now',
                primary: true,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ActionBtn(
                label: 'Add to cart',
                primary: false,
                onTap: () {},
              ),
            ),
          ]),

          const SizedBox(height: 16),

          // ── Delivery / return / security ──────────────────────────────
          _InfoStrip(),
        ],
      ),
    );
  }
}

// ─── SHARED HELPERS ──────────────────────────────────────────────────────────

class _CircleBtn extends StatelessWidget {
  const _CircleBtn({required this.child, this.onTap});
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: _kBorder),
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.label, {required this.bg, required this.fg, this.icon});
  final String label;
  final Color bg, fg;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: fg), const SizedBox(width: 4),
          ],
          Text(label,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
        ]),
      );
}

class _StarRow extends StatelessWidget {
  const _StarRow({required this.rating, required this.reviews, this.size = 14});
  final double rating;
  final int reviews;
  final double size;

  @override
  Widget build(BuildContext context) => Row(children: [
        ...List.generate(5, (i) {
          final full = i < rating.floor();
          final half = !full && i < rating;
          return Icon(
            half ? Icons.star_half_rounded
                : (full ? Icons.star_rounded : Icons.star_outline_rounded),
            color: _kAmber, size: size,
          );
        }),
        const SizedBox(width: 5),
        Text('${rating.toStringAsFixed(1)} · $reviews reviews',
            style: TextStyle(
                fontSize: size - 2, color: _kTextMuted)),
      ]);
}

class _QtyControl extends StatelessWidget {
  const _QtyControl(
      {required this.value, required this.onDec, required this.onInc});
  final int value;
  final VoidCallback onDec, onInc;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _kBorder),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          _QBtn(icon: Icons.remove_rounded, onTap: onDec),
          SizedBox(
            width: 36,
            child: Text(value.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600)),
          ),
          _QBtn(icon: Icons.add_rounded, onTap: onInc),
        ]),
      );
}

class _QBtn extends StatelessWidget {
  const _QBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: _kSurface,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 18),
        ),
      );
}

class _ActionBtn extends StatefulWidget {
  const _ActionBtn({
    required this.label,
    required this.primary,
    required this.onTap,
    this.fullWidth = false,
  });
  final String label;
  final bool primary, fullWidth;
  final VoidCallback onTap;

  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<_ActionBtn> {
  bool _p = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _p = true),
      onTapUp: (_) { setState(() => _p = false); widget.onTap(); },
      onTapCancel: () => setState(() => _p = false),
      child: AnimatedScale(
        scale: _p ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: SizedBox(
          width: widget.fullWidth ? double.infinity : null,
          height: 44,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: widget.primary ? _kBlue : Colors.transparent,
              border: widget.primary ? null : Border.all(color: _kBlue, width: 1.5),
            ),
            child: Center(
              child: Text(widget.label,
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600,
                      color: widget.primary ? Colors.white : _kBlue)),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoStrip extends StatelessWidget {
  const _InfoStrip({this.vertical = false});
  final bool vertical;

  static const _items = [
    (Icons.local_shipping_outlined, 'Free delivery'),
    (Icons.assignment_return_outlined, '30-day return'),
    (Icons.lock_outline_rounded, 'Secure payment'),
  ];

  @override
  Widget build(BuildContext context) {
    final children = _items.map((e) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(e.$1, size: 15, color: _kTextMuted),
            const SizedBox(width: 6),
            Text(e.$2,
                style: TextStyle(
                    fontSize: 12, color: _kTextMuted)),
          ],
        )).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kBorder),
        color: _kSurface,
      ),
      child: vertical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children
                  .map((c) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: c,
                      ))
                  .toList(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: children,
            ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w600,
            color: _kTextMuted, letterSpacing: 0.6),
      );
}

class _Div extends StatelessWidget {
  const _Div();

  @override
  Widget build(BuildContext context) => Container(
      height: 0.5,
      color: _kBorder,
      margin: const EdgeInsets.symmetric(vertical: 14));
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kSurface,
      child: const Center(child: Icon(Icons.image_outlined, size: 56, color: _kBorder)),
    );
  }
}