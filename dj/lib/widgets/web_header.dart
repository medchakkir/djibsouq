import 'package:dj/layouts/web/pages_web/promo_web.dart';
import 'package:flutter/material.dart';
import 'package:dj/layouts/web/home_web.dart';
import 'package:dj/layouts/web/pages_web/cart_web.dart';
import 'package:dj/layouts/web/pages_web/categories_web.dart';
import 'package:dj/layouts/web/pages_web/favorites_web.dart';
import 'package:dj/layouts/web/pages_web/products_web.dart';
import 'package:dj/layouts/web/pages_web/profile_web.dart';
import 'package:dj/services/responsive_service.dart';
import 'package:dj/auth_page.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color textDark = Color(0xFF111827);

// ─────────────────────────────────────────────
//  TRANSITION PERSONNALISÉE : Fade + Slide G→D
// ─────────────────────────────────────────────
class FadeSlideRoute extends PageRouteBuilder {
  final Widget page;

  FadeSlideRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) {
            // Slide léger : vient de la gauche (-6% de la largeur)
            final slide = Tween<Offset>(
              begin: const Offset(-0.06, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

            // Fade : 0 → 1
            final fade = CurvedAnimation(parent: animation, curve: Curves.easeIn);

            return FadeTransition(
              opacity: fade,
              child: SlideTransition(position: slide, child: child),
            );
          },
        );
}

// ─────────────────────────────────────────────
//  HELPER : navigate avec FadeSlideRoute
// ─────────────────────────────────────────────
void navigateTo(BuildContext context, Widget page, {bool replace = false}) {
  if (replace) {
    Navigator.pushReplacement(context, FadeSlideRoute(page: page));
  } else {
    Navigator.push(context, FadeSlideRoute(page: page));
  }
}

// ─────────────────────────────────────────────
//  HEADER
// ─────────────────────────────────────────────
class buildHeader extends StatefulWidget {
  final String currentPage;

  const buildHeader({super.key, required this.currentPage});

  @override
  State<buildHeader> createState() => _buildHeaderState();
}

class _buildHeaderState extends State<buildHeader> {
  late String selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.currentPage;
  }

  void _navigate(String title) {
    setState(() => selectedItem = title);
    switch (title) {
      case 'Home':
        navigateTo(context, const HomepageWeb(), replace: true);
        break;
      case 'Categories':
        navigateTo(context, const CategoriesWeb());
        break;
      case 'Products':
        navigateTo(context, const ProductsWeb());
        break;
      case 'Promo':
        navigateTo(context, const PromoWeb());
        break;
    }
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Home', 'Categories', 'Products', 'Promo']
              .map((title) => ListTile(
                    title: Text(title),
                    onTap: () {
                      Navigator.pop(context);
                      _navigate(title);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final navItems = ['Home', 'Categories', 'Products', 'Promo'];
    final isMobile = ResponsiveService.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── LOGO ──
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => navigateTo(context, const HomepageWeb(), replace: true),
              child: Row(
                children: [
                  Image.asset('assets/images/logo.png', width: 40),
                  const SizedBox(width: 8),
                  const Text(
                    'DJIBSOUQ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryBlue),
                  ),
                ],
              ),
            ),
          ),

          if (!isMobile) ...[
            // ── NAV ──
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: navItems
                    .map((title) => NavItemWeb(
                          title: title,
                          isSelected: selectedItem == title,
                          onTap: () => _navigate(title),
                        ))
                    .toList(),
              ),
            ),

            const SizedBox(width: 30),
          ] else ...[
            // Mobile: Hamburger menu
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _showMobileMenu(context),
            ),
          ],

          // ── ICONS ──
          Row(
            children: [
              _HeaderIcon(
                icon: Icons.search,
                activeIcon: Icons.search,
                isActive: false,
                tooltip: 'Rechercher',
                onTap: () {},
              ),
              const SizedBox(width: 6),
              _HeaderIcon(
                icon: Icons.login,
                activeIcon: Icons.login,
                isActive: false,
                tooltip: 'Se connecter',
                onTap: () => navigateTo(context, const AuthPage()),
              ),
              const SizedBox(width: 6),
              _HeaderIcon(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                isActive: selectedItem == 'Profil',
                tooltip: 'Profil',
                onTap: () => navigateTo(context, const ProfileWeb()),
              ),
              const SizedBox(width: 6),
              _HeaderIcon(
                icon: Icons.favorite_border,
                activeIcon: Icons.favorite,
                isActive: selectedItem == 'Favoris',
                tooltip: 'Favoris',
                onTap: () => navigateTo(context, const FavoritesWeb()),
              ),
              const SizedBox(width: 6),
              _HeaderIcon(
                icon: Icons.shopping_cart_outlined,
                activeIcon: Icons.shopping_cart,
                isActive: selectedItem == 'Panier',
                tooltip: 'Panier',
                badge: 3,
                onTap: () => navigateTo(context, const CartWeb()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HEADER ICON
// ─────────────────────────────────────────────
class _HeaderIcon extends StatefulWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool isActive;
  final String tooltip;
  final VoidCallback onTap;
  final int? badge;

  const _HeaderIcon({
    required this.icon,
    required this.activeIcon,
    required this.isActive,
    required this.tooltip,
    required this.onTap,
    this.badge,
  });

  @override
  State<_HeaderIcon> createState() => _HeaderIconState();
}

class _HeaderIconState extends State<_HeaderIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _scale = Tween<double>(begin: 1.0, end: 1.25).animate(
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
    final bool showActive = widget.isActive || _hovered;

    return Tooltip(
      message: widget.tooltip,
      preferBelow: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() => _hovered = true);
          _controller.forward();
        },
        onExit: (_) {
          setState(() => _hovered = false);
          if (!widget.isActive) _controller.reverse();
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: ScaleTransition(
            scale: _scale,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: showActive ? primaryBlue.withOpacity(0.08) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      showActive ? widget.activeIcon : widget.icon,
                      key: ValueKey(showActive),
                      size: widget.isActive ? 26 : 22,
                      color: showActive ? primaryBlue : Colors.grey.shade600,
                    ),
                  ),
                ),
                if (widget.badge != null && widget.badge! > 0)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      width: 17,
                      height: 17,
                      decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          '${widget.badge}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
//  NAV ITEM
// ─────────────────────────────────────────────
class NavItemWeb extends StatefulWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const NavItemWeb({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<NavItemWeb> createState() => _NavItemWebState();
}

class _NavItemWebState extends State<NavItemWeb> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 15),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: widget.isSelected
                    ? primaryBlue
                    : _hovered
                        ? primaryBlue.withOpacity(0.6)
                        : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: TextStyle(
              fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w500,
              color: widget.isSelected
                  ? primaryBlue
                  : _hovered
                      ? primaryBlue.withOpacity(0.8)
                      : textDark,
              fontSize: 16,
            ),
            child: Text(widget.title),
          ),
        ),
      ),
    );
  }
}