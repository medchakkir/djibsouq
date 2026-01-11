import 'package:flutter/material.dart';

const Color primaryBlue = Color(0xFF1E3A8A);

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  String _language = 'Français';
  String _currency = 'USD';
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // Notifications Section
          _buildSectionHeader('Notifications'),
          _buildSwitchTile(
            title: 'Enable Notifications',
            subtitle: 'Receive app notifications',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          if (_notificationsEnabled) ...[
            _buildSwitchTile(
              title: 'Email Notifications',
              subtitle: 'Receive updates via email',
              value: _emailNotifications,
              onChanged: (value) {
                setState(() {
                  _emailNotifications = value;
                });
              },
              isSubItem: true,
            ),
            _buildSwitchTile(
              title: 'Push Notifications',
              subtitle: 'Receive push alerts',
              value: _pushNotifications,
              onChanged: (value) {
                setState(() {
                  _pushNotifications = value;
                });
              },
              isSubItem: true,
            ),
          ],
          const Divider(height: 24),

          // Display Section
          _buildSectionHeader('Display'),
          _buildSwitchTile(
            title: 'Dark Mode',
            subtitle: 'Enable dark theme',
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
            },
          ),
          _buildDropdownTile(
            title: 'Language',
            value: _language,
            items: ['Français', 'English', 'العربية'],
            onChanged: (value) {
              setState(() {
                _language = value!;
              });
            },
          ),
          _buildDropdownTile(
            title: 'Currency',
            value: _currency,
            items: ['USD', 'EUR', 'DJF', 'XOF'],
            onChanged: (value) {
              setState(() {
                _currency = value!;
              });
            },
          ),
          const Divider(height: 24),

          // Account Section
          _buildSectionHeader('Account'),
          _buildMenuTile(
            title: 'Change Password',
            icon: Icons.lock,
            onTap: () {
              _showChangePasswordDialog(context);
            },
          ),
          _buildMenuTile(
            title: 'Payment Methods',
            icon: Icons.payment,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment methods page coming soon'),
                ),
              );
            },
          ),
          _buildMenuTile(
            title: 'Addresses',
            icon: Icons.location_on,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Addresses page coming soon')),
              );
            },
          ),
          const Divider(height: 24),

          // About Section
          _buildSectionHeader('About'),
          _buildMenuTile(
            title: 'Privacy Policy',
            icon: Icons.privacy_tip,
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Privacy Policy')));
            },
          ),
          _buildMenuTile(
            title: 'Terms & Conditions',
            icon: Icons.description,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Terms & Conditions')),
              );
            },
          ),
          _buildMenuTile(
            title: 'About DJIBSOUQ',
            icon: Icons.info,
            onTap: () {
              _showAboutDialog(context);
            },
          ),
          const Divider(height: 24),

          // Version Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Center(
              child: Text(
                'Version 1.0.0',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: primaryBlue,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isSubItem = false,
  }) {
    return Container(
      margin: isSubItem
          ? const EdgeInsets.symmetric(horizontal: 8, vertical: 0)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: isSubItem ? Colors.grey[50] : Colors.white,
        border: Border(
          left: isSubItem
              ? BorderSide(color: Colors.grey[300]!, width: 3)
              : BorderSide.none,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: isSubItem ? 24 : 16,
          vertical: 4,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Switch(
          value: value,
          activeColor: primaryBlue,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(title),
        trailing: DropdownButton<String>(
          value: value,
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
          underline: const SizedBox(),
          style: const TextStyle(color: primaryBlue),
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon, color: primaryBlue),
        title: Text(title),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Old Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newPasswordController.text ==
                  confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password changed successfully'),
                  ),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
            child: const Text('Change', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'DJIBSOUQ',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2024 DJIBSOUQ. All rights reserved.',
      children: [
        const SizedBox(height: 12),
        Text(
          'Your trusted online marketplace for quality products and services.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
