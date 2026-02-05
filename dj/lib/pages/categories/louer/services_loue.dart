import 'package:flutter/material.dart';
import '../../detail_product.dart';
import '../../products.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFE5E7EB);

class ServicesLouePage extends StatelessWidget {
  const ServicesLouePage({super.key});

  static const List<Map<String, dynamic>> services = [
    {
      'name': 'Canva Pro',
      'price': '4.99 \$',
      'duration': '1 mois',
      'icon': Icons.design_services,
      'features': [
        'Accès premium',
        'Sans watermark',
        'Templates Pro',
        'Support inclus',
      ],
    },
    {
      'name': 'Adobe Photoshop',
      'price': '9.99 \$',
      'duration': '1 mois',
      'icon': Icons.brush,
      'features': [
        'Photoshop complet',
        'Outils pro',
        'Cloud inclus',
        'Support inclus',
      ],
    },
    {
      'name': 'Netflix Premium',
      'price': '6.99 \$',
      'duration': '1 mois',
      'icon': Icons.movie,
      'features': [
        'Ultra HD',
        'Multi-écrans',
        'Sans publicité',
        'Support inclus',
      ],
    },
    {
      'name': 'Spotify Premium',
      'price': '7.99 \$',
      'duration': '3 mois',
      'icon': Icons.music_note,
      'features': [
        'Sans publicité',
        'Téléchargement',
        'Qualité audio max',
        'Support inclus',
      ],
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
          'Services loués',
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTrustHeader(),
          const SizedBox(height: 16),
          ...services.map((service) => _buildServiceCard(context, service)),
          const SizedBox(height: 24),
          _buildHowItWorks(),
        ],
      ),
    );
  }

  // 🔐 Bandeau confiance
  Widget _buildTrustHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Accès Premium Garanti',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '⚡ Activation rapide (5–30 min)',
            style: TextStyle(color: Colors.white),
          ),
          Text('🔒 Compte sécurisé', style: TextStyle(color: Colors.white)),
          Text(
            '📞 Support client inclus',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  // 🧱 Carte service
  Widget _buildServiceCard(BuildContext context, Map<String, dynamic> service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(service['icon'], size: 40, color: primaryBlue),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  service['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
              ),
              Text(
                service['price'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Durée : ${service['duration']}'),
          const SizedBox(height: 8),
          Column(
            children: service['features']
                .map<Widget>(
                  (f) => Row(
                    children: [
                      const Icon(Icons.check, size: 16, color: Colors.green),
                      const SizedBox(width: 6),
                      Text(f),
                    ],
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final price = double.parse(
                  service['price'].replaceAll(RegExp(r'[^\d.]'), ''),
                );
                final detailProduct = Product(
                  id: service['name'],
                  name: service['name'],
                  category: 'Services Location',
                  price: price,
                  rating: 4.5,
                  image: '🔑',
                  reviews: 100,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailProductPage(product: detailProduct),
                  ),
                );
              },
              child: const Text('LOUER MAINTENANT'),
            ),
          ),
        ],
      ),
    );
  }

  //  Comment ça marche
  Widget _buildHowItWorks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Comment ça marche ?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryBlue,
          ),
        ),
        SizedBox(height: 8),
        Text('1️⃣ Choisissez votre service'),
        Text('2️⃣ Effectuez le paiement'),
        Text('3️⃣ Recevez vos accès rapidement'),
        Text('4️⃣ Support disponible 24/7'),
      ],
    );
  }
}
