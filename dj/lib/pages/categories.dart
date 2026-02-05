import 'package:flutter/material.dart';
import 'categories/electronique.dart';
import 'categories/vetements.dart';
import 'categories/maison.dart';
import 'categories/sports.dart';
import 'categories/livres.dart';
import 'categories/beaute.dart';
import 'categories/louer/services_loue.dart';
import 'categories/louer/services_maintenance.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFE5E7EB);

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  // Liste des catégories
  static const List<Map<String, dynamic>> categories = [
    {
      'name': 'Électronique',
      'icon': Icons.devices,
      'color': Color(0xFF3B82F6),
      'image':
          'https://via.placeholder.com/400x300/3B82F6/FFFFFF?text=Electronique',
    },
    {
      'name': 'Vêtements',
      'icon': Icons.shopping_bag,
      'color': Color(0xFFEC4899),
      'image':
          'https://via.placeholder.com/400x300/EC4899/FFFFFF?text=Vetements',
    },
    {
      'name': 'Maison',
      'icon': Icons.home,
      'color': Color(0xFF10B981),
      'image': 'https://via.placeholder.com/400x300/10B981/FFFFFF?text=Maison',
    },
    {
      'name': 'Sports',
      'icon': Icons.sports_soccer,
      'color': Color(0xFFF59E0B),
      'image': 'https://via.placeholder.com/400x300/F59E0B/FFFFFF?text=Sports',
    },
    {
      'name': 'Livres',
      'icon': Icons.library_books,
      'color': Color(0xFF8B5CF6),
      'image': 'https://via.placeholder.com/400x300/8B5CF6/FFFFFF?text=Livres',
    },
    {
      'name': 'Beauté',
      'icon': Icons.spa,
      'color': Color(0xFFF43F5E),
      'image': 'https://via.placeholder.com/400x300/F43F5E/FFFFFF?text=Beaute',
    },
    {
      'name': 'Services loué',
      'icon': Icons.key,
      'color': Color(0xFF06B6D4),
      'image':
          'https://via.placeholder.com/400x300/06B6D4/FFFFFF?text=Services+loue',
    },
    {
      'name': 'Services maintenance',
      'icon': Icons.build,
      'color': Color(0xFFEF4444),
      'image':
          'https://via.placeholder.com/400x300/EF4444/FFFFFF?text=Services+maintenance',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Catégories',
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryCard(
              name: category['name'],
              icon: category['icon'],
              color: category['color'],
              imageUrl: category['image'],
              onTap: () => _openCategory(context, category['name']),
            );
          },
        ),
      ),
    );
  }

  void _openCategory(BuildContext context, String name) {
    Widget page;
    switch (name) {
      case 'Électronique':
        page = ElectronicsPage(title: name);
        break;
      case 'Vêtements':
        page = VetementsPage(title: name);
        break;
      case 'Maison':
        page = MaisonPage(title: name);
        break;
      case 'Sports':
        page = SportsPage(title: name);
        break;
      case 'Livres':
        page = LivresPage(title: name);
        break;
      case 'Beauté':
        page = BeautePage(title: name);
        break;
      case 'Services loué':
        page = ServicesLouePage();
        break;
      case 'Services maintenance':
        page = ServicesMaintenancePage();
        break;
      default:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(name)));
        return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Widget _buildCategoryCard({
    required String name,
    required IconData icon,
    required Color color,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image en arrière-plan
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: color.withOpacity(0.1),
                child: Icon(icon, size: 48, color: color),
              ),
            ),
            // Overlay gradient
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                ),
              ),
            ),
            // Contenu
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
