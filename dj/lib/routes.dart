import 'package:dj/layouts/web/pages_web/products_web.dart' show ProductsWeb;
import 'package:flutter/material.dart';
import 'package:dj/layouts/web/home_web.dart';
import 'package:dj/layouts/web/pages_web/categories_web.dart';
import 'package:dj/layouts/web/pages_web/cart_web.dart';
import 'package:dj/layouts/web/pages_web/favorites_web.dart';
import 'package:dj/layouts/web/pages_web/profile_web.dart';
import 'package:dj/layouts/web/pages_web/promo_web.dart';
import 'package:dj/auth_page.dart';

// ─────────────────────────────────────────────
//  TRANSITION : Fade + Slide Gauche → Droite
// ─────────────────────────────────────────────
class FadeSlideRoute extends PageRouteBuilder {
  FadeSlideRoute({required Widget page, RouteSettings? settings})
      : super(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) {
            final slide = Tween<Offset>(
              begin: const Offset(-0.06, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

            final fade = CurvedAnimation(parent: animation, curve: Curves.easeIn);

            return FadeTransition(
              opacity: fade,
              child: SlideTransition(position: slide, child: child),
            );
          },
        );
}

// ─────────────────────────────────────────────
//  APP ROUTES
// ─────────────────────────────────────────────
class AppRoutes {
  static const String home       = '/';
  static const String categories = '/categories';
  static const String products   = '/products';
  static const String cart       = '/cart';
  static const String favorites  = '/favorites';
  static const String profile    = '/profile';
  static const String promo      = '/promo';
  static const String auth       = '/auth';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return FadeSlideRoute(
          settings: settings,
          page: const HomepageWeb(),
        );

      case categories:
        return FadeSlideRoute(
          settings: settings,
          page: const CategoriesWeb(),
        );

      case products:
        final args = settings.arguments as String?;
        return FadeSlideRoute(
          settings: settings,
          page: ProductsWeb(initialCategory: args),
        );

      case promo:
        final args = settings.arguments as String?;
        return FadeSlideRoute(
          settings: settings,
          page: PromoWeb(initialCategory: args),
        );

      case cart:
        return FadeSlideRoute(
          settings: settings,
          page: const CartWeb(),
        );

      case favorites:
        return FadeSlideRoute(
          settings: settings,
          page: const FavoritesWeb(),
        );

      case profile:
        return FadeSlideRoute(
          settings: settings,
          page: const ProfileWeb(),
        );

      case auth:
        return FadeSlideRoute(
          settings: settings,
          page: const AuthPage(),
        );

      default:
        return FadeSlideRoute(
          settings: settings,
          page: Scaffold(
            body: Center(
              child: Text("Page non trouvée : '${settings.name}'"),
            ),
          ),
        );
    }
  }
}