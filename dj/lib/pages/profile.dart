import 'package:flutter/material.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFE5E7EB);

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
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              color: Colors.white,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: primaryBlue.withOpacity(0.1),
                    child: const Icon(
                      Icons.person,
                      color: primaryBlue,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Marwan User',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'mymail@gmail.com',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Personal Info Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informations Personnelles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _profileInfoCard('Nom', 'Marwan'),
                  _profileInfoCard('Prénom', 'User'),
                  _profileInfoCard('Email', 'mymail@gmail.com'),
                  _profileInfoCard('Téléphone', '+212 6 XX XX XX XX'),
                  _profileInfoCard('Adresse', 'Djibouti'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Account Settings Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Paramètres du Compte',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _settingsTile(
                    Icons.lock,
                    'Changer le mot de passe',
                    'Modifier votre mot de passe',
                    () {},
                  ),
                  _settingsTile(
                    Icons.notifications,
                    'Notifications',
                    'Gérer vos notifications',
                    () {},
                  ),
                  _settingsTile(
                    Icons.privacy_tip,
                    'Confidentialité',
                    'Gérer vos données personnelles',
                    () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profil modifié avec succès'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Modifier le Profil',
                        style: TextStyle(
                          fontSize: 16,
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
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Déconnexion'),
                              content: const Text(
                                'Êtes-vous sûr de vouloir vous déconnecter?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.popUntil(
                                      context,
                                      (route) => false,
                                    );
                                  },
                                  child: const Text(
                                    'Déconnexion',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Déconnexion',
                        style: TextStyle(
                          fontSize: 16,
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

  static Widget _profileInfoCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _settingsTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: primaryBlue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
