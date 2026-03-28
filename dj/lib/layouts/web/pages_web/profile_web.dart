import 'package:flutter/material.dart';

import '../home_web.dart';
import 'products_web.dart';
import 'cart_web.dart';
import 'favorites_web.dart';
import 'categories_web.dart';
import 'package:dj/widgets/web_header.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFFFFFFF);
const Color textDark = Color(0xFF111827);

class ProfileWeb extends StatelessWidget {
  const ProfileWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(currentPage: "Profil",),
            _buildProfileContent(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }



  // ================= PROFILE CONTENT =================
  Widget _buildProfileContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 40),
          _buildProfileSections(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: cardGrey,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Color(0xFFE8ECF8),
            child: Icon(Icons.person, size: 80, color: primaryBlue),
          ),
          const SizedBox(width: 40),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Marwan User",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "mymail@gmail.com",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Éditer le profil",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSections() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Account Section
        Expanded(
          child: _buildSection(
            "Mon Compte",
            [
              _MenuItem(
                Icons.shopping_bag,
                "Mes commandes",
                "Suivi & historique",
              ),
              _MenuItem(
                Icons.location_on,
                "Mes adresses",
                "Livraison",
              ),
              _MenuItem(
                Icons.payment,
                "Paiement",
                "Cartes & mobile money",
              ),
              _MenuItem(
                Icons.favorite,
                "Favoris",
                "Produits aimés",
              ),
            ],
          ),
        ),
        const SizedBox(width: 40),
        // Settings Section
        Expanded(
          child: _buildSection(
            "Paramètres",
            [
              _MenuItem(
                Icons.notifications,
                "Notifications",
                "Alertes & mises à jour",
              ),
              _MenuItem(
                Icons.security,
                "Sécurité",
                "Mot de passe & authentification",
              ),
              _MenuItem(
                Icons.language,
                "Langue",
                "Français, English...",
              ),
              _MenuItem(
                Icons.help,
                "Aide",
                "Support & FAQ",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<_MenuItem> items) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardGrey,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 20),
          ...items
              .map((item) => Column(
                    children: [
                      _buildMenuTile(item.icon, item.title, item.subtitle),
                      const Divider(height: 1),
                    ],
                  ))
              ,
        ],
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Icon(icon, color: primaryBlue, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: textDark,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  // ================= FOOTER =================
  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.all(40),
      color: primaryBlue,
      child: const Center(
        child: Text(
          "© 2026 MIZUX. All rights reserved.",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

// NAV ITEM
class _NavItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _NavItem(this.title, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: textDark)),
      ),
    );
  }
}

// MENU ITEM
class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;

  _MenuItem(this.icon, this.title, this.subtitle);
}
