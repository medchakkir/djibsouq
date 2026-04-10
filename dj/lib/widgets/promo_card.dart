import 'package:flutter/material.dart';
import 'package:dj/widgets/hover_scale_card.dart';
import 'package:dj/routes.dart';

// ─────────────────────────────────────────────
//  PROMO CARD
// ─────────────────────────────────────────────
class PromoCard extends StatelessWidget {
  final String title;
  final String description;
  final String emoji;
  final Color color;
  final String categoryName;

  const PromoCard({
    super.key,
    required this.title,
    required this.description,
    required this.emoji,
    required this.color,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return HoverScaleCard(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.promo,
        arguments: categoryName,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 6),
            )
          ],
        ),
        child: AspectRatio(
          aspectRatio: isMobile ? 1.1 : 1.2,
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 14 : 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ICON
                Container(
                  width: isMobile ? 50 : 60,
                  height: isMobile ? 50 : 60,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: TextStyle(
                        fontSize: isMobile ? 24 : 30,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // TITLE
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 6),

                // DESCRIPTION (flexible)
                Expanded(
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    maxLines: isMobile ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 13,
                      color: Colors.black54,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // CTA (optionnel stylé)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Voir",
                    style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}