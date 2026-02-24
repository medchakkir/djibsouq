import 'package:dj/layouts/web/pages_web/products_web.dart' show ProductsWeb;
import 'package:flutter/material.dart';
import 'package:dj/layouts/web/home_web.dart';
import 'package:dj/layouts/web/pages_web/categories_web.dart';
import 'package:dj/layouts/web/pages_web/cart_web.dart';
import 'package:dj/layouts/web/pages_web/favorites_web.dart';
import 'package:dj/layouts/web/pages_web/profile_web.dart';
import 'package:dj/layouts/web/pages_web/promo_web.dart';

class AppRoutes {
  static const String home = '/';
  static const String categories = '/categories';
  static const String products = '/products';
  static const String cart = '/cart';
  static const String favorites = '/favorites';
  static const String profile = '/profile';
  static const String promo = '/promo';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomepageWeb());
      case categories:
        return MaterialPageRoute(builder: (_) => const CategoriesWeb());
      case products:
        final args = settings.arguments as String?;
        return MaterialPageRoute(builder: (_) => ProductsWeb(initialCategory: args));
      case promo:
        return MaterialPageRoute(builder: (_) => const PromoWeb());
      case cart:
        return MaterialPageRoute(builder: (_) => const CartWeb());
      case favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesWeb());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileWeb());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Page non trouvée : \'${settings.name}\''),
            ),
          ),
        );
    }
  }
}
