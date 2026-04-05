import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dj/layouts/web/home_web.dart';

// ─── Palette (optimisée pour lisibilité) ─────────────────────────────────────
const _kNavy = Color(0xFF0A1128); // Fond sombre principal
const _kBlue = Color(0xFF1E40AF); // Bleu principal
const _kIndigo = Color(0xFF4F46E5); // Accent indigo
const _kCyan = Color(0xFF22D3EE); // Cyan vif
const _kGold = Color(0xFFF59E0B); // Or
const _kWhite = Colors.white;
const _kBg = Color(0xFFF8FAFC); // Fond clair
const _kText = Color(0xFF0F172A); // Texte principal
const _kMuted = Color(0xFF64748B); // Texte secondaire
const _kBorder = Color(0xFFCBD5E1); // Bordures

// ══════════════════════════════════════════════════════════════════════════════
//  AUTH PAGE
// ══════════════════════════════════════════════════════════════════════════════

class AuthPage extends StatefulWidget {
  final bool startOnSignUp;
  const AuthPage({super.key, this.startOnSignUp = false});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  late bool _isSignUp;

  late final AnimationController _morphCtrl;
  late final Animation<double> _morphAnim;
  late final AnimationController _particleCtrl;
  late final List<_Particle> _particles;
  late final AnimationController _enterCtrl;
  late final Animation<double> _enterAnim;

  @override
  void initState() {
    super.initState();
    _isSignUp = widget.startOnSignUp;

    _morphCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      value: _isSignUp ? 1.0 : 0.0,
    );
    _morphAnim = CurvedAnimation(
      parent: _morphCtrl,
      curve: Curves.easeInOutCubic,
    );

    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )..repeat();

    final rng = Random(42);
    _particles = List.generate(18, (_) => _Particle(rng));

    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );
    _enterAnim = CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutExpo);

    WidgetsBinding.instance.addPostFrameCallback((_) => _enterCtrl.forward());
  }

  @override
  void dispose() {
    _morphCtrl.dispose();
    _particleCtrl.dispose();
    _enterCtrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isSignUp = !_isSignUp);
    _isSignUp ? _morphCtrl.forward() : _morphCtrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(
        children: [
          // Fond animé
          Positioned.fill(child: _AnimatedBackground(anim: _morphAnim)),

          // Particules
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _particleCtrl,
              builder: (context, child) => CustomPaint(
                painter: _ParticlePainter(_particles, _particleCtrl.value),
              ),
            ),
          ),

          // Bouton Accueil
          SafeArea(
            child: Positioned(
              top: 200,
              left: 200,
              child: _HomeButton(
                onTap: () => Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    settings: const RouteSettings(name: '/'),
                    pageBuilder: (_, __, ___) => const HomepageWeb(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                ),
              ),
            ),
          ),

          // Contenu principal
          SafeArea(
            child: AnimatedBuilder(
              animation: _enterAnim,
              builder: (context, child) => Opacity(
                opacity: _enterAnim.value,
                child: Transform.translate(
                  offset: Offset(0, 40 * (1 - _enterAnim.value)),
                  child: child,
                ),
              ),
              child: isMobile
                  ? _MobileShell(isSignUp: _isSignUp, onToggle: _toggle)
                  : _DesktopShell(isSignUp: _isSignUp, onToggle: _toggle),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bouton Accueil ──────────────────────────────────────────────────────────
class _HomeButton extends StatelessWidget {
  final VoidCallback onTap;
  const _HomeButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () => onTap(),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(Icons.home_rounded, color: _kBlue, size: 30)],
          ),
        ),
      ),
    );
  }
}

// ── Fond Animé + Particules (inchangés mais conservés) ───────────────────────
class _AnimatedBackground extends StatelessWidget {
  final Animation<double> anim;
  const _AnimatedBackground({required this.anim});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: anim,
    builder: (context, child) => CustomPaint(painter: _BgPainter(anim.value)),
  );
}

class _BgPainter extends CustomPainter {
  final double t;
  _BgPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    // Wave + Orb (code inchangé)
    final path = Path();
    final waveY = size.height * 0.55 + sin(t * pi) * size.height * 0.06;
    path.moveTo(0, waveY);
    path.cubicTo(
      size.width * (0.25 + t * 0.2),
      waveY - size.height * 0.22,
      size.width * (0.7 - t * 0.1),
      waveY + size.height * 0.18,
      size.width,
      waveY - size.height * 0.05,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(_kNavy, const Color(0xFF1E2A6B), t)!,
            Color.lerp(_kBlue, _kIndigo, t)!,
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    final orbX = size.width * (0.82 - t * 0.45);
    canvas.drawCircle(
      Offset(orbX, size.height * 0.28),
      size.width * 0.42,
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                Color.lerp(_kCyan, _kGold, t)!.withOpacity(0.25),
                Colors.transparent,
              ],
            ).createShader(
              Rect.fromCircle(
                center: Offset(orbX, size.height * 0.28),
                radius: size.width * 0.42,
              ),
            ),
    );
  }

  @override
  bool shouldRepaint(covariant _BgPainter old) => old.t != t;
}

// ── Particules ───────────────────────────────────────────────────────────────

class _Particle {
  final double x, startY, size, speed, opacity;
  _Particle(Random rng)
    : x = rng.nextDouble(),
      startY = rng.nextDouble(),
      size = rng.nextDouble() * 3 + 1,
      speed = rng.nextDouble() * 0.4 + 0.15,
      opacity = rng.nextDouble() * 0.4 + 0.1;
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double t;
  _ParticlePainter(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final y = (p.startY - t * p.speed) % 1.0;
      canvas.drawCircle(
        Offset(p.x * size.width, y * size.height),
        p.size,
        Paint()
          ..color = _kCyan.withOpacity(
            p.opacity * (0.6 + 0.4 * sin(t * pi * 2 + p.x * 10)),
          ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => old.t != t;
}

// ══════════════════════════════════════════════════════════════════════════════
//  LAYOUTS
// ══════════════════════════════════════════════════════════════════════════════

class _DesktopShell extends StatelessWidget {
  final bool isSignUp;
  final VoidCallback onToggle;
  const _DesktopShell({required this.isSignUp, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Logo(),
                const Spacer(),
                _BrandHeadline(isSignUp: isSignUp),
                const SizedBox(height: 48),
                _FeatureList(),
                const Spacer(),
                _PanelToggleBtn(isSignUp: isSignUp, onTap: onToggle),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: _FormCard(isSignUp: isSignUp, onToggle: onToggle),
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileShell extends StatelessWidget {
  final bool isSignUp;
  final VoidCallback onToggle;
  const _MobileShell({required this.isSignUp, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Logo(),
                const SizedBox(height: 28),
                _BrandHeadline(isSignUp: isSignUp),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _FormCard(isSignUp: isSignUp, onToggle: onToggle),
          ),
          const SizedBox(height: 20),
          _PanelToggleBtn(isSignUp: isSignUp, onTap: onToggle),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  FORM CARD + CONTENTS
// ══════════════════════════════════════════════════════════════════════════════

class _FormCard extends StatelessWidget {
  final bool isSignUp;
  final VoidCallback onToggle;

  const _FormCard({required this.isSignUp, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kWhite.withOpacity(0.97),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: _kNavy.withOpacity(0.15),
            blurRadius: 70,
            offset: const Offset(0, 25),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            switchInCurve: Curves.easeOutBack,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(
                    child.key == const ValueKey('up') ? 0.6 : -0.6,
                    0,
                  ),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: isSignUp
                ? _SignUpContent(key: const ValueKey('up'), onToggle: onToggle)
                : _SignInContent(key: const ValueKey('in'), onToggle: onToggle),
          ),
        ),
      ),
    );
  }
}

// Sign In & Sign Up restent presque identiques (seulement petites corrections mineures)

class _SignInContent extends StatefulWidget {
  final VoidCallback onToggle;
  const _SignInContent({super.key, required this.onToggle});

  @override
  State<_SignInContent> createState() => _SignInContentState();
}

class _SignInContentState extends State<_SignInContent> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ModePill(label: 'Connexion', color: _kBlue),
          const SizedBox(height: 16),
          const Text(
            'Bon retour 👋',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: _kText,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Accédez à votre espace DJIBSOUQ',
            style: TextStyle(fontSize: 13.5, color: _kMuted),
          ),
          const SizedBox(height: 32),
          _SocialGrid(),
          const SizedBox(height: 28),
          const _OrLine(),
          const SizedBox(height: 28),
          _GlassField(hint: 'Email', icon: Icons.alternate_email_rounded),
          const SizedBox(height: 16),
          _GlassField(
            hint: 'Mot de passe',
            icon: Icons.shield_outlined,
            obscure: _obscure,
            trailing: _EyeToggle(
              obscure: _obscure,
              onTap: () => setState(() => _obscure = !_obscure),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MiniCheck(label: 'Se souvenir'),
              const Text(
                'Mot de passe oublié ?',
                style: TextStyle(
                  color: _kIndigo,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _GradientButton(
            label: 'Se connecter',
            icon: Icons.arrow_forward_rounded,
            colors: const [_kBlue, _kIndigo],
            onPressed: () {},
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  SIGN UP CONTENT
// ══════════════════════════════════════════════════════════════════════════════

class _SignUpContent extends StatefulWidget {
  final VoidCallback onToggle;
  const _SignUpContent({super.key, required this.onToggle});

  @override
  State<_SignUpContent> createState() => _SignUpContentState();
}

class _SignUpContentState extends State<_SignUpContent> {
  bool _obscure = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ModePill(label: 'Inscription', color: _kCyan),
          const SizedBox(height: 16),
          const Text(
            'Rejoignez DJIBSOUQ 🎉',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: _kText,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Créez votre compte pour commencer',
            style: TextStyle(fontSize: 13.5, color: _kMuted),
          ),
          const SizedBox(height: 32),
          _SocialGrid(),
          const SizedBox(height: 28),
          const _OrLine(),
          const SizedBox(height: 28),
          _GlassField(hint: 'Nom complet', icon: Icons.person_outline_rounded),
          const SizedBox(height: 16),
          _GlassField(hint: 'Email', icon: Icons.alternate_email_rounded),
          const SizedBox(height: 16),
          _GlassField(
            hint: 'Mot de passe',
            icon: Icons.shield_outlined,
            obscure: _obscure,
            trailing: _EyeToggle(
              obscure: _obscure,
              onTap: () => setState(() => _obscure = !_obscure),
            ),
          ),
          const SizedBox(height: 16),
          _GlassField(
            hint: 'Confirmer mot de passe',
            icon: Icons.shield_outlined,
            obscure: _obscureConfirm,
            trailing: _EyeToggle(
              obscure: _obscureConfirm,
              onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
            child: Row(
              children: [
                _AnimCheck(checked: _agreedToTerms),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'J\'accepte les conditions\nd\'utilisation et la politique\nde confidentialité',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: _kMuted,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _GradientButton(
            label: 'S\'inscrire',
            icon: Icons.arrow_forward_rounded,
            colors: const [_kCyan, _kBlue],
            onPressed: _agreedToTerms ? () {} : null,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  COMPOSANTS BRANDING
// ══════════════════════════════════════════════════════════════════════════════

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [_kBlue, _kCyan]),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: _kCyan.withOpacity(0.4),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(
            Icons.shopping_bag_rounded,
            color: _kWhite,
            size: 26,
          ),
        ),
        const SizedBox(width: 14),
        const Text(
          'DJIBSOUQ',
          style: TextStyle(
            color: _kNavy, // ← Changé pour un bleu très foncé bien visible
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.8,
          ),
        ),
      ],
    );
  }
}

class _BrandHeadline extends StatelessWidget {
  final bool isSignUp;
  const _BrandHeadline({required this.isSignUp});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Column(
        key: ValueKey(isSignUp),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isSignUp
                ? 'Rejoignez\nla communauté\nDjiboutienne.'
                : 'Content de\nvous revoir\nchez nous.',
            style: TextStyle(
              color: _kNavy, // ← Texte bien visible
              fontSize: 44,
              fontWeight: FontWeight.w800,
              height: 1.08,
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 4,
            width: 68,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [_kCyan, _kGold]),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const items = [
      ('🚀', 'Livraison rapide partout à Djibouti'),
      ('🔒', 'Paiement 100% sécurisé'),
      ('🎁', 'Offres exclusives membres'),
      ('⭐', '+10 000 produits disponibles'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Text(item.$1, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 12),
                  Text(
                    item.$2,
                    style: TextStyle(
                      color: _kWhite.withOpacity(0.72),
                      fontSize: 14.5,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _PanelToggleBtn extends StatelessWidget {
  final bool isSignUp;
  final VoidCallback onTap;
  const _PanelToggleBtn({required this.isSignUp, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: Container(
          key: ValueKey(isSignUp),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          decoration: BoxDecoration(
            color: _kWhite.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _kWhite.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSignUp ? Icons.login_rounded : Icons.person_add_alt_1_rounded,
                color: _kCyan,
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                isSignUp
                    ? 'Déjà un compte ? Se connecter'
                    : "Pas de compte ? S'inscrire",
                style: const TextStyle(
                  color: _kWhite,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, color: _kWhite, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  COMPOSANTS FORMULAIRE
// ══════════════════════════════════════════════════════════════════════════════

class _ModePill extends StatelessWidget {
  final String label;
  final Color color;
  const _ModePill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SocialGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SocialChip(
          label: 'Google',
          icon: Icons.g_mobiledata_outlined,
          color: const Color(0xFFEA4335),
        ),
        const SizedBox(width: 8),
        _SocialChip(
          label: 'Facebook',
          icon: Icons.facebook_rounded,
          color: const Color(0xFF1877F2),
        ),
        const SizedBox(width: 8),
        _SocialChip(label: 'Apple', icon: Icons.apple_rounded, color: _kText),
      ],
    );
  }
}

class _SocialChip extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _SocialChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  State<_SocialChip> createState() => _SocialChipState();
}

class _SocialChipState extends State<_SocialChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MouseRegion(
        onEnter: (_) => _ctrl.forward(),
        onExit: (_) => _ctrl.reverse(),
        child: GestureDetector(
          onTapDown: (_) => _ctrl.forward(),
          onTapUp: (_) => _ctrl.reverse(),
          onTapCancel: () => _ctrl.reverse(),
          onTap: () {},
          child: AnimatedBuilder(
            animation: _anim,
            builder: (context, child) => Transform.scale(
              scale: 1.0 + _anim.value * 0.03,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: Color.lerp(
                    _kBg,
                    widget.color.withOpacity(0.06),
                    _anim.value,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Color.lerp(
                      _kBorder,
                      widget.color.withOpacity(0.4),
                      _anim.value,
                    )!,
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.1 * _anim.value),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.icon, color: widget.color, size: 22),
                    const SizedBox(height: 3),
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color.lerp(_kMuted, _kText, _anim.value),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? trailing;

  const _GlassField({
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      style: const TextStyle(
        fontSize: 14,
        color: _kText,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _kMuted, fontSize: 13.5),
        prefixIcon: Icon(icon, size: 18, color: _kMuted),
        suffixIcon: trailing,
        filled: true,
        fillColor: _kBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kBorder, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kIndigo, width: 1.8),
        ),
      ),
    );
  }
}

// Bouton dégradé principal avec animation de pression
class _GradientButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback? onPressed;

  const _GradientButton({
    required this.label,
    required this.icon,
    required this.colors,
    this.onPressed,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    return GestureDetector(
      onTapDown: enabled ? (_) => _ctrl.reverse() : null,
      onTapUp: enabled ? (_) => _ctrl.forward() : null,
      onTapCancel: () => _ctrl.forward(),
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _ctrl,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 54,
          decoration: BoxDecoration(
            gradient: enabled
                ? LinearGradient(
                    colors: widget.colors,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            color: enabled ? null : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(16),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: widget.colors.first.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  color: enabled ? _kWhite : _kMuted,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 8),
              Icon(widget.icon, color: enabled ? _kWhite : _kMuted, size: 17),
            ],
          ),
        ),
      ),
    );
  }
}

// Bouton outline secondaire avec animation de pression
class _OutlineButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  const _OutlineButton({required this.label, required this.onPressed});

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) => _ctrl.forward(),
      onTapCancel: () => _ctrl.forward(),
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _ctrl,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: _kBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _kBorder, width: 1.5),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: const TextStyle(
                color: _kText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OrLine extends StatelessWidget {
  const _OrLine();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: _kBorder)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'ou',
            style: TextStyle(
              fontSize: 12,
              color: _kMuted.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: _kBorder)),
      ],
    );
  }
}

class _EyeToggle extends StatelessWidget {
  final bool obscure;
  final VoidCallback onTap;
  const _EyeToggle({required this.obscure, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          key: ValueKey(obscure),
          color: _kMuted,
          size: 18,
        ),
      ),
      onPressed: onTap,
    );
  }
}

class _MiniCheck extends StatefulWidget {
  final String label;
  const _MiniCheck({required this.label});

  @override
  State<_MiniCheck> createState() => _MiniCheckState();
}

class _MiniCheckState extends State<_MiniCheck> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _checked = !_checked),
      child: Row(
        children: [
          _AnimCheck(checked: _checked),
          const SizedBox(width: 8),
          Text(
            widget.label,
            style: const TextStyle(fontSize: 12.5, color: _kMuted),
          ),
        ],
      ),
    );
  }
}

class _AnimCheck extends StatelessWidget {
  final bool checked;
  const _AnimCheck({required this.checked});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        gradient: checked
            ? const LinearGradient(
                colors: [_kBlue, _kIndigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: checked ? null : _kWhite,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: checked ? Colors.transparent : _kBorder,
          width: 1.5,
        ),
        boxShadow: checked
            ? [
                BoxShadow(
                  color: _kIndigo.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: checked
          ? const Icon(Icons.check_rounded, size: 13, color: _kWhite)
          : null,
    );
  }
}
