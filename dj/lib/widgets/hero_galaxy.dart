import 'dart:math';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  HERO GALAXY — responsive
// ─────────────────────────────────────────────
class HeroGalaxy extends StatefulWidget {
  final VoidCallback onDownloadTap;
  const HeroGalaxy({super.key, required this.onDownloadTap});

  @override
  State<HeroGalaxy> createState() => _HeroGalaxyState();
}

class _HeroGalaxyState extends State<HeroGalaxy> with TickerProviderStateMixin {
  late final AnimationController _starsController;
  late final AnimationController _textController;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  final Random _random = Random();
  late final List<Offset> _stars;
  late final List<double> _starSizes;
  late final List<double> _starOpacities;
  static const int _starCount = 180;
  static const double _movementRange = 120.0;

  @override
  void initState() {
    super.initState();
    _starsController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    _textController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _textFade = CurvedAnimation(parent: _textController, curve: Curves.easeOut);
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic));

    _stars = List.generate(_starCount, (_) => Offset(_random.nextDouble(), _random.nextDouble()));
    _starSizes = List.generate(_starCount, (_) => _random.nextDouble() * 1.5);
    _starOpacities = List.generate(_starCount, (_) => 0.25 + _random.nextDouble() * 0.75);

    WidgetsBinding.instance.addPostFrameCallback((_) => _textController.forward());
  }

  @override
  void dispose() {
    _starsController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 600;
      final isTablet = constraints.maxWidth < 900;
      final heroHeight = isMobile ? 480.0 : (isTablet ? 400.0 : 350.0);

      return SizedBox(
        height: heroHeight,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF0F172A).withOpacity(0.95),
                      const Color(0xFF1E293B).withOpacity(0.95),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _starsController,
                builder: (_, __) => CustomPaint(
                  painter: GalaxyPainter(
                    progress: _starsController.value,
                    stars: _stars,
                    sizes: _starSizes,
                    opacities: _starOpacities,
                    movementRange: _movementRange,
                  ),
                ),
              ),
            ),
            // Mobile : layout vertical centré
            if (isMobile)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: FadeTransition(
                  opacity: _textFade,
                  child: SlideTransition(
                    position: _textSlide,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Your Online Command Hub\nin Djibouti',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold,
                                color: Colors.white, height: 1.3)),
                        const SizedBox(height: 14),
                        const Text('Latest Electronics, Exclusive Deals',
                            style: TextStyle(fontSize: 15, color: Colors.white70)),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade400,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {},
                              child: const Text('Start Shopping'),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.greenAccent.withOpacity(0.8),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: widget.onDownloadTap,
                              icon: const Icon(Icons.download, color: Colors.black, size: 16),
                              label: const Text("App", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              // Tablet / Desktop : layout horizontal
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32 : 60,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: FadeTransition(
                        opacity: _textFade,
                        child: SlideTransition(
                          position: _textSlide,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Your Online Command Hub\nin Djibouti',
                                  style: TextStyle(
                                      fontSize: isTablet ? 30 : 42,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 1.3)),
                              const SizedBox(height: 20),
                              const Text('Latest Electronics, Exclusive Deals',
                                  style: TextStyle(fontSize: 18, color: Colors.white70)),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade400,
                                  padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 18),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () {},
                                child: const Text('Start Shopping'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Tablette : image réduite visible — Desktop : taille normale
                    ...[
                      const SizedBox(width: 50),
                      SizedBox(
                        height: isTablet ? 300 : 420,
                        width: isTablet
                            ? constraints.maxWidth * 0.38
                            : min(650, constraints.maxWidth * 0.55),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              right: 0, top: 0, bottom: 0,
                              child: Align(
                                alignment: Alignment.bottomLeft,
                              child: deviceImage(
                                  image: 'assets/images/group.png',
                                  height: isTablet ? 260 : 400,
                                  isPrimary: true,
                                ),
                              ),
                            ),
                            Positioned(
                              right: isTablet ? 60 : 150,
                              bottom: 6,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.greenAccent.withOpacity(0.8),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 14 : 28,
                                    vertical: isTablet ? 12 : 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                ),
                                onPressed: widget.onDownloadTap,
                                icon: const Icon(Icons.download, color: Colors.black),
                                label: Text(
                                  isTablet ? "Télécharger" : "Télécharger l'app",
                                  style: const TextStyle(
                                      color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────
//  GALAXY PAINTER (inchangé)
// ─────────────────────────────────────────────
class GalaxyPainter extends CustomPainter {
  final double progress;
  final List<Offset> stars;
  final List<double> sizes;
  final List<double> opacities;
  final double movementRange;

  const GalaxyPainter({
    required this.progress,
    required this.stars,
    required this.sizes,
    required this.opacities,
    this.movementRange = 120.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (int i = 0; i < stars.length; i++) {
      final x = stars[i].dx * size.width;
      final y = (stars[i].dy * size.height + progress * movementRange) % size.height;
      paint.color = Colors.white.withOpacity(opacities[i]);
      canvas.drawCircle(Offset(x, y), sizes[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant GalaxyPainter old) => old.progress != progress;
}

// ─────────────────────────────────────────────
//  DEVICE IMAGE — optimized for performance
// ─────────────────────────────────────────────
Widget deviceImage({
  required String image,
  required double height,
  double scale = 1.0,
  double opacity = 1.0,
  bool isPrimary = false,
}) {
  return Opacity(
    opacity: opacity,
    child: Transform.scale(
      scale: scale,
      child: Image.asset(image, height: height, fit: BoxFit.contain),
    ),
  );
}