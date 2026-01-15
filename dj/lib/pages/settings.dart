import 'package:flutter/material.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color backgroundGrey = Color(0xFFF5F6FA);

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // ===== NOTIFICATIONS =====
  bool notificationsActives = true;
  bool notificationsEmail = true;
  bool notificationsPush = true;

  // ===== APPARENCE & LOCALISATION =====
  bool modeSombre = false;
  String langue = 'Français';
  String devise = 'DJF';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Paramètres',
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: primaryBlue),
      ),
      body: ListView(
        children: [
          /// ===== NOTIFICATIONS =====
          _sectionTitle('Notifications'),
          _switchTile(
            title: 'Activer les notifications',
            subtitle: 'Recevoir les alertes de l’application',
            value: notificationsActives,
            onChanged: (v) => setState(() => notificationsActives = v),
          ),
          if (notificationsActives) ...[
            _switchTile(
              title: 'Notifications par email',
              subtitle: 'Recevoir les mises à jour par email',
              value: notificationsEmail,
              onChanged: (v) => setState(() => notificationsEmail = v),
              isSub: true,
            ),
            _switchTile(
              title: 'Notifications push',
              subtitle: 'Recevoir des alertes instantanées',
              value: notificationsPush,
              onChanged: (v) => setState(() => notificationsPush = v),
              isSub: true,
            ),
          ],

          _divider(),

          /// ===== APPARENCE =====
          _sectionTitle('Affichage'),
          _switchTile(
            title: 'Mode sombre',
            subtitle: 'Activer le thème sombre',
            value: modeSombre,
            onChanged: (v) => setState(() => modeSombre = v),
          ),
          _dropdownTile(
            title: 'Langue',
            value: langue,
            items: const ['Français', 'English', 'العربية'],
            onChanged: (v) => setState(() => langue = v!),
          ),
          _dropdownTile(
            title: 'Devise',
            value: devise,
            items: const ['DJF', 'USD', 'EUR', 'XOF'],
            onChanged: (v) => setState(() => devise = v!),
          ),

          _divider(),

          /// ===== COMPTE =====
          _sectionTitle('Compte'),
          _menuTile(
            title: 'Changer le mot de passe',
            icon: Icons.lock_outline,
            onTap: () => _showChangePasswordDialog(),
          ),
          _menuTile(
            title: 'Moyens de paiement',
            icon: Icons.payment,
            onTap: () => _comingSoon('Moyens de paiement'),
          ),
          _menuTile(
            title: 'Adresses de livraison',
            icon: Icons.location_on_outlined,
            onTap: () => _comingSoon('Adresses'),
          ),

          _divider(),

          /// ===== AIDE & LÉGAL =====
          _sectionTitle('Aide & informations'),
          _menuTile(
            title: 'Centre d’aide',
            icon: Icons.help_outline,
            onTap: () => _comingSoon('Centre d’aide'),
          ),
          _menuTile(
            title: 'Politique de confidentialité',
            icon: Icons.privacy_tip_outlined,
            onTap: () {},
          ),
          _menuTile(
            title: 'Conditions d’utilisation',
            icon: Icons.description_outlined,
            onTap: () {},
          ),
          _menuTile(
            title: 'À propos de DJIBSOUQ',
            icon: Icons.info_outline,
            onTap: _showAboutDialog,
          ),

          const SizedBox(height: 24),

          /// ===== VERSION =====
          Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ================= UI COMPONENTS =================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: primaryBlue,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _switchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isSub = false,
  }) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: isSub ? 24 : 0),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: primaryBlue,
        ),
      ),
    );
  }

  Widget _dropdownTile({
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(title),
        trailing: DropdownButton<String>(
          value: value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          underline: const SizedBox(),
          style: const TextStyle(color: primaryBlue),
        ),
      ),
    );
  }

  Widget _menuTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: primaryBlue),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _divider() {
    return const Divider(height: 32, thickness: 1);
  }

  // ================= ACTIONS =================

  void _comingSoon(String feature) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$feature – bientôt disponible')));
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Changer le mot de passe'),
        content: const Text('Fonctionnalité à connecter à l’API'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'DJIBSOUQ',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2024 DJIBSOUQ',
      children: const [
        SizedBox(height: 8),
        Text('Marketplace digitale moderne et fiable.'),
      ],
    );
  }
}
