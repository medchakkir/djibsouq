import 'package:dj/models/promotion_models.dart';
import 'package:flutter/material.dart';

// 2
class PromotionSection extends StatelessWidget {
  const PromotionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section promotion à gauche
              SizedBox(
                width: constraints.maxWidth * 0.6,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, right: 20),
                  child: PromotionSlider(),
                ),
              ),
              // Bloc assurance à droite
              SizedBox(
                width: constraints.maxWidth * 0.4,
                child: Column(
                  children: [
                    // Bloc assurance
                    Container(
                      margin: const EdgeInsets.only(right: 40, bottom: 24),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.verified_user, color: Colors.greenAccent, size: 28),
                            SizedBox(height: 8),
                            Text(
                              "Votre sécurité, notre priorité",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Achetez en toute confiance sur Djibsouq : paiement sécurisé, retours faciles, assistance 24/7 et produits garantis.",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ],
                      ),
                    ),
                    // Bloc pourquoi meilleur
                    Container(
                      margin: const EdgeInsets.only(right: 40, bottom: 24),
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: const Color(0xFF232946),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Icon(Icons.star, color: Colors.amber, size: 34),
                          SizedBox(height: 16),
                          Text(
                            "Pourquoi choisir Djibsouq ?",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Des prix imbattables, une livraison rapide partout à Djibouti, un large choix de produits high-tech et un service client à l'écoute. Essayez l'expérience Djibsouq !",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Bloc prix
                    Container(
                      margin: const EdgeInsets.only(right: 40),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A2233),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Icon(Icons.attach_money, color: Colors.lightGreenAccent, size: 32),
                          SizedBox(height: 14),
                          Text(
                            "Des prix pour tous",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Profitez d'offres exclusives et de tarifs compétitifs toute l'année. Chez Djibsouq, la technologie est accessible à tous les budgets !",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 3
class PromotionSlider extends StatefulWidget {
  const PromotionSlider({super.key});

  @override
  State<PromotionSlider> createState() => _PromotionSliderState();
}

class _PromotionSliderState extends State<PromotionSlider> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<PromotionModel> promotions = [
    PromotionModel(
      title: "Samsung Galaxy A54",
      price: "\$299",
      oldPrice: "\$399",
      discount: "-25%",
      image: "assets/images/a54.png",
    ),
    PromotionModel(
      title: "iPhone 14 Pro",
      price: "\$899",
      oldPrice: "\$999",
      discount: "-10%",
      image: "assets/images/iphone.png",
    ),
    PromotionModel(
      title: "Google Pixel 8",
      price: "\$599",
      oldPrice: "\$699",
      discount: "-15%",
      image: "assets/images/pixel.png",
    ),
  ];

  void nextPage() {
    if (currentIndex < promotions.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentIndex > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: promotions.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return PromotionCard(promotion: promotions[index]);
            },
          ),

          /// LEFT ARROW
          Positioned(
            left: 0,
            child: ArrowButton(
              icon: Icons.arrow_back_ios,
              onTap: previousPage,
            ),
          ),

          /// RIGHT ARROW
          Positioned(
            right: 0,
            child: ArrowButton(
              icon: Icons.arrow_forward_ios,
              onTap: nextPage,
            ),
          ),

          /// DOTS
          Positioned(
            bottom: 10,
            child: Row(
              children: List.generate(
                promotions.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentIndex == index ? 14 : 8,
                  height: currentIndex == index ? 14 : 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentIndex == index
                        ? const Color(0xFF4A90E2)
                        : Colors.grey.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// 4
class PromotionCard extends StatelessWidget {
  final PromotionModel promotion;

  const PromotionCard({super.key, required this.promotion});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF0FA), Color(0xFFDCE4F6)],
        ),
      ),
      child: Row(
        children: [
          /// LEFT CONTENT
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5B8DEF), Color(0xFF7F53FF)],
                    ),
                  ),
                  child: const Text(
                    "🔥 Promotion of the Week",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  promotion.title,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3A59),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      promotion.price,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        promotion.discount,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  promotion.oldPrice,
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: const Color(0xFF4A90E2),
                  ),
                  child: const Text(
                    "Buy Now",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),

          /// RIGHT IMAGE
          Expanded(
            flex: 5,
            child: Image.asset(
              promotion.image,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

// 5  
class ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const ArrowButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            )
          ],
        ),
        child: Icon(icon),
      ),
    );
  }
}
