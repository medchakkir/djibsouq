import 'package:flutter/material.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);

class CustomerServicePage extends StatelessWidget {
  const CustomerServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Service Client',
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===== CONTACT =====
            _contactCard(),

            const SizedBox(height: 28),

            /// ===== FAQ =====
            const Text(
              'Questions fréquentes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 12),

            FAQTile(
              question: 'Comment suivre ma commande ?',
              answer:
                  'Vous pouvez suivre votre commande directement depuis la section '
                  '"Mes commandes" dans votre profil. Le statut est mis à jour en temps réel.',
            ),
            FAQTile(
              question: 'Quels sont les délais de livraison ?',
              answer:
                  'Les délais de livraison varient entre 24h et 72h selon votre localisation '
                  'et le type de produit commandé.',
            ),
            FAQTile(
              question: 'Comment retourner un produit ?',
              answer:
                  'Rendez-vous dans "Mes commandes", sélectionnez la commande concernée puis '
                  'cliquez sur "Retourner le produit".',
            ),
            FAQTile(
              question: 'Quels moyens de paiement acceptez-vous ?',
              answer:
                  'Nous acceptons les cartes bancaires, le mobile money et le paiement à la livraison.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Nous sommes là pour vous aider',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
            SizedBox(height: 16),
            _ContactRow(
              label: 'Email',
              value: 'support@djibsouq.com',
              icon: Icons.email,
            ),
            SizedBox(height: 12),
            _ContactRow(
              label: 'Téléphone',
              value: '+212 6 XX XX XX XX',
              icon: Icons.phone,
            ),
            SizedBox(height: 12),
            _ContactRow(
              label: 'WhatsApp',
              value: '+212 6 XX XX XX XX',
              icon: Icons.chat,
            ),
          ],
        ),
      ),
    );
  }
}

/// =====================================================
/// =================== FAQ TILE =========================
/// =====================================================
class FAQTile extends StatelessWidget {
  final String question;
  final String answer;

  const FAQTile({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showFaqDialog(context),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: primaryBlue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFaqDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                answer,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Fermer',
                    style: TextStyle(color: primaryBlue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===== CONTACT ROW =====
class _ContactRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ContactRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: primaryBlue),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(value, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}
