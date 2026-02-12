import 'package:flutter/material.dart';
import 'favorites.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Mon Profil',
          style: TextStyle(
            color: primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// ===== HEADER PROFIL =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              color: Colors.white,
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFFE8ECF8),
                    child: Icon(Icons.person, size: 60, color: primaryBlue),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Marwan User',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'mymail@gmail.com',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ===== E-COMMERCE =====
            _sectionTitle('Mon Compte'),
            _menuTile(
              Icons.shopping_bag,
              'Mes commandes',
              'Suivi & historique',
            ),
            _menuTile(Icons.location_on, 'Mes adresses', 'Livraison'),
            _menuTile(Icons.payment, 'Paiement', 'Cartes & mobile money'),
            _menuTile(
              Icons.favorite,
              'Favoris',
              'Produits aimés',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesPage(),
                  ),
                );
              },
            ),
            _menuTile(Icons.autorenew, 'Abonnements', 'Actifs & historique'),

            const SizedBox(height: 24),

            /// ===== PARAMÈTRES =====
            _sectionTitle('Paramètres'),
            _menuTile(Icons.lock, 'Mot de passe', 'Changer le mot de passe'),
            _menuTile(
              Icons.notifications,
              'Notifications',
              'Gérer les alertes',
            ),
            _menuTile(Icons.language, 'Langue', 'Français'),

            const SizedBox(height: 24),

            /// ===== SUPPORT & LEGAL =====
            _sectionTitle('Support & Légal'),
            _menuTile(Icons.help_outline, 'Centre d’aide', 'Besoin d’aide ?'),
            _menuTile(Icons.assignment_return, 'Politique de retour', ''),
            _menuTile(Icons.privacy_tip, 'Confidentialité', ''),
            _menuTile(Icons.description, 'Conditions d’utilisation', ''),

            const SizedBox(height: 32),

            /// ===== ACTIONS =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Modifier le profil',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Déconnexion',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// ===== UI HELPERS =====
  static Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryBlue,
          ),
        ),
      ),
    );
  }

  static Widget _menuTile(
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        child: ListTile(
          leading: Icon(icon, color: primaryBlue),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
      ),
    );
  }
}
