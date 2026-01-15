import 'package:flutter/material.dart';
import 'categories.dart';
import 'homepage.dart';
import 'cart.dart';
import 'my_orders.dart';
import 'favorites.dart';
import 'services.dart';
import 'promotions.dart';
import 'vedette.dart';
import 'notifications.dart';
import 'customer_service.dart';
import 'settings.dart';
import 'profile.dart';

const Color primaryBlue = Color(0xFF1E3A8A);

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _drawerHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(
                  Icons.home,
                  "Accueil",
                  context,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                ),
                _drawerItem(
                  Icons.grid_view,
                  "Categories",
                  context,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategoriesPage(),
                      ),
                    );
                  },
                ),
                _drawerItem(
                  Icons.shopping_cart,
                  "Panier",
                  context,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartPage()),
                    );
                  },
                ),
                _drawerItem(
                  Icons.receipt_long,
                  "Mes Commandes",
                  context,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyOrdersPage(),
                      ),
                    );
                  },
                ),
                _drawerItem(
                  Icons.favorite,
                  "Favories",
                  context,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavoritesPage(),
                      ),
                    );
                  },
                ),
                Divider(),
                _drawerItem(
                  Icons.support_agent,
                  "Services",
                  context,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ServicesPage(),
                      ),
                    );
                  },
                ),
                _drawerItem(
                  Icons.local_offer,
                  "Promotions",
                  context,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PromotionsPage(),
                      ),
                    );
                  },
                ),
                _drawerItem(
                  Icons.star,
                  "Vedette de la semaine",
                  context,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VedettePage(),
                      ),
                    );
                  },
                ),
                _drawerItem(
                  Icons.notifications,
                  "Notifications",
                  context,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsPage(),
                      ),
                    );
                  },
                ),
                _drawerItem(
                  Icons.headset_mic,
                  "Service Client",
                  context,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomerServicePage(),
                      ),
                    );
                  },
                ),
                Divider(),
                _drawerItem(
                  Icons.settings,
                  "Paramètres",
                  context,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
                _drawerItem(
                  Icons.logout,
                  "Déconnexion",
                  context,
                  isLogout: true,
                  onPressed: () {
                    // Logique de déconnexion
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _drawerHeader(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
      decoration: const BoxDecoration(color: primaryBlue),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: primaryBlue, size: 32),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nom d'Utilisateur",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "monmail@gmail.com",
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _drawerItem(
  IconData icon,
  String title,
  BuildContext context, {
  VoidCallback? onPressed,
  bool isLogout = false,
}) {
  return ListTile(
    leading: Icon(icon, color: isLogout ? Colors.red : primaryBlue),
    title: Text(
      title,
      style: TextStyle(
        color: isLogout ? Colors.red : Colors.black87,
        fontWeight: isLogout ? FontWeight.w600 : FontWeight.normal,
      ),
    ),
    onTap:
        onPressed ??
        () {
          Navigator.pop(context);
        },
  );
}
