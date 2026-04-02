import 'dart:math';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  CONSTANTS (same as home_web.dart)
// ─────────────────────────────────────────────
const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color textDark = Color(0xFF111827);

// ─────────────────────────────────────────────
//  AUTH WRAPPER  (Sign In / Sign Up toggling)
// ─────────────────────────────────────────────
class AuthPage extends StatefulWidget {
  final bool startOnSignUp;
  const AuthPage({super.key, this.startOnSignUp = false});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  late bool _showSignUp;

  late AnimationController _panelCtrl;
  late Animation<double> _panelFade;
  late Animation<Offset> _panelSlide;

  late AnimationController _bgCtrl;   // stars rotation
  final Random _rng = Random();

  late List<Offset> _stars;
  late List<double> _starSizes;
  late List<double> _starOpacities;
  static const int _starCount = 160;

  @override
  void initState() {
    super.initState();
    _showSignUp = widget.startOnSignUp;

    // panel anim
    _panelCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _panelFade =
        CurvedAnimation(parent: _panelCtrl, curve: Curves.easeOut);
    _panelSlide =
        Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
            .animate(CurvedAnimation(
                parent: _panelCtrl, curve: Curves.easeOutCubic));

    // background stars
    _bgCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 12))
      ..repeat();

    _stars = List.generate(
        _starCount, (_) => Offset(_rng.nextDouble(), _rng.nextDouble()));
    _starSizes =
        List.generate(_starCount, (_) => _rng.nextDouble() * 1.6 + 0.2);
    _starOpacities = List.generate(
        _starCount, (_) => 0.2 + _rng.nextDouble() * 0.7);

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _panelCtrl.forward());
  }

  @override
  void dispose() {
    _panelCtrl.dispose();
    _bgCtrl.dispose();
    super.dispose();
  }

  void _switchMode() {
    _panelCtrl.reverse().then((_) {
      setState(() => _showSignUp = !_showSignUp);
      _panelCtrl.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080F1E),
      body: Stack(
        children: [
          // ── Animated star background ──────────────────
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF080F1E),
                    Color(0xFF0F172A),
                    Color(0xFF1E293B),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgCtrl,
              builder: (_, __) => CustomPaint(
                painter: _StarsPainter(
                  progress: _bgCtrl.value,
                  stars: _stars,
                  sizes: _starSizes,
                  opacities: _starOpacities,
                ),
              ),
            ),
          ),

          // ── Glow blobs ────────────────────────────────
          Positioned(
            left: -120, top: -120,
            child: _GlowBlob(color: primaryBlue.withOpacity(0.35), size: 500),
          ),
          Positioned(
            right: -80, bottom: -80,
            child: _GlowBlob(
                color: Colors.cyanAccent.withOpacity(0.12), size: 400),
          ),

          // ── Responsive layout ─────────────────────────
          LayoutBuilder(builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 700;
            return isMobile
                ? _mobilelayout(constraints)
                : _desktopLayout(constraints);
          }),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  DESKTOP  (split screen)
  // ─────────────────────────────────────────────
  Widget _desktopLayout(BoxConstraints c) {
    return Row(
      children: [
        // Left brand panel
        Expanded(
          flex: 5,
          child: _BrandPanel(onSwitchTap: _switchMode, isSignUp: _showSignUp),
        ),

        // Right form panel
        Expanded(
          flex: 4,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: FadeTransition(
                opacity: _panelFade,
                child: SlideTransition(
                  position: _panelSlide,
                  child: _showSignUp
                      ? _SignUpForm(onSwitch: _switchMode)
                      : _SignInForm(onSwitch: _switchMode),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  MOBILE  (stacked)
  // ─────────────────────────────────────────────
  Widget _mobilelayout(BoxConstraints c) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // mini brand header
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo row
                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.shopping_bag,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'DJIBSOUQ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      letterSpacing: 2,
                    ),
                  ),
                ]),
                const SizedBox(height: 16),
                Text(
                  _showSignUp ? 'Créer un compte' : 'Bon retour 👋',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Form card
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF0F172A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: FadeTransition(
              opacity: _panelFade,
              child: SlideTransition(
                position: _panelSlide,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 32),
                  child: _showSignUp
                      ? _SignUpForm(onSwitch: _switchMode)
                      : _SignInForm(onSwitch: _switchMode),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  BRAND PANEL  (desktop left side)
// ─────────────────────────────────────────────
class _BrandPanel extends StatelessWidget {
  final VoidCallback onSwitchTap;
  final bool isSignUp;
  const _BrandPanel({required this.onSwitchTap, required this.isSignUp});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0F172A),
            primaryBlue.withOpacity(0.85),
          ],
        ),
        border: Border(
          right: BorderSide(color: Colors.white.withOpacity(0.06), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Logo ──────────────────────────────
          Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Colors.white.withOpacity(0.15), width: 1),
              ),
              child: const Icon(Icons.shopping_bag,
                  color: Colors.white, size: 26),
            ),
            const SizedBox(width: 14),
            const Text(
              'DJIBSOUQ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 26,
                letterSpacing: 2.5,
              ),
            ),
          ]),

          const Spacer(),

          // ── Main headline ─────────────────────
          Text(
            isSignUp
                ? 'Rejoignez\nla communauté.'
                : 'Bon retour\nparmi nous.',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 46,
              fontWeight: FontWeight.w800,
              height: 1.15,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            isSignUp
                ? 'Découvrez des milliers de produits,\ndes offres exclusives et bien plus.'
                : 'Connectez-vous pour retrouver vos\ncommandes, favoris et promotions.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.55),
              fontSize: 16,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 40),

          // ── Feature pills ─────────────────────
          ...[
            ('🚀', 'Livraison rapide à Djibouti'),
            ('🔒', 'Paiement sécurisé'),
            ('🎁', 'Offres exclusives membres'),
          ].map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(children: [
                  Text(e.$1, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 12),
                  Text(e.$2,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 15)),
                ]),
              )),

          const Spacer(),

          // ── Switch mode CTA ───────────────────
          Row(children: [
            Text(
              isSignUp
                  ? 'Déjà un compte ? '
                  : 'Pas encore inscrit ? ',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.45), fontSize: 14),
            ),
            GestureDetector(
              onTap: onSwitchTap,
              child: Text(
                isSignUp ? 'Se connecter' : 'Créer un compte',
                style: TextStyle(
                  color: Colors.cyanAccent.shade200,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.cyanAccent.shade200,
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SIGN IN FORM
// ─────────────────────────────────────────────
class _SignInForm extends StatefulWidget {
  final VoidCallback onSwitch;
  const _SignInForm({required this.onSwitch});

  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return _FormCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FormTitle('Se connecter'),
          const SizedBox(height: 6),
          _FormSubtitle('Accédez à votre espace personnel'),
          const SizedBox(height: 32),

          // ── Social buttons ────────────────────
          _SocialButtons(),
          const SizedBox(height: 28),
          _Divider(),
          const SizedBox(height: 28),

          // ── Email ─────────────────────────────
          _Label('Email'),
          const SizedBox(height: 8),
          _AuthField(
            hint: 'votre@email.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),

          // ── Password ──────────────────────────
          _Label('Mot de passe'),
          const SizedBox(height: 8),
          _AuthField(
            hint: '••••••••',
            icon: Icons.lock_outline,
            obscureText: _obscure,
            suffixIcon: IconButton(
              icon: Icon(
                _obscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.white38,
                size: 18,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          const SizedBox(height: 12),

          // ── Remember + Forgot ─────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CheckboxRow(label: 'Se souvenir de moi'),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Mot de passe oublié ?',
                  style: TextStyle(
                      color: Colors.cyanAccent.shade200, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // ── Submit ────────────────────────────
          _PrimaryButton(label: 'Se connecter', onTap: () {}),
          const SizedBox(height: 24),

          // ── Switch ────────────────────────────
          Center(
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text('Pas de compte ? ',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.4), fontSize: 14)),
              GestureDetector(
                onTap: widget.onSwitch,
                child: Text(
                  "S'inscrire",
                  style: TextStyle(
                    color: Colors.cyanAccent.shade200,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SIGN UP FORM
// ─────────────────────────────────────────────
class _SignUpForm extends StatefulWidget {
  final VoidCallback onSwitch;
  const _SignUpForm({required this.onSwitch});

  @override
  State<_SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  bool _obscure = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return _FormCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FormTitle('Créer un compte'),
          const SizedBox(height: 6),
          _FormSubtitle('Rejoignez DJIBSOUQ gratuitement'),
          const SizedBox(height: 32),

          // ── Social buttons ────────────────────
          _SocialButtons(),
          const SizedBox(height: 28),
          _Divider(),
          const SizedBox(height: 28),

          // ── Name row ──────────────────────────
          Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Label('Prénom'),
                  const SizedBox(height: 8),
                  _AuthField(hint: 'Ahmed', icon: Icons.person_outline),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Label('Nom'),
                  const SizedBox(height: 8),
                  _AuthField(hint: 'Omar', icon: Icons.person_outline),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 20),

          // ── Email ─────────────────────────────
          _Label('Email'),
          const SizedBox(height: 8),
          _AuthField(
            hint: 'votre@email.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),

          // ── Phone ─────────────────────────────
          _Label('Téléphone (optionnel)'),
          const SizedBox(height: 8),
          _AuthField(
            hint: '+253 77 00 00 00',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),

          // ── Password ──────────────────────────
          _Label('Mot de passe'),
          const SizedBox(height: 8),
          _AuthField(
            hint: '8 caractères minimum',
            icon: Icons.lock_outline,
            obscureText: _obscure,
            suffixIcon: IconButton(
              icon: Icon(
                _obscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.white38,
                size: 18,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          const SizedBox(height: 20),

          // ── Confirm password ──────────────────
          _Label('Confirmer le mot de passe'),
          const SizedBox(height: 8),
          _AuthField(
            hint: '••••••••',
            icon: Icons.lock_outline,
            obscureText: _obscureConfirm,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                color: Colors.white38,
                size: 18,
              ),
              onPressed: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
          const SizedBox(height: 16),

          // ── Terms ─────────────────────────────
          _CheckboxRow(
              label: "J'accepte les conditions d'utilisation"),
          const SizedBox(height: 32),

          // ── Submit ────────────────────────────
          _PrimaryButton(label: "Créer mon compte", onTap: () {}),
          const SizedBox(height: 24),

          // ── Switch ────────────────────────────
          Center(
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text('Déjà un compte ? ',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.4), fontSize: 14)),
              GestureDetector(
                onTap: widget.onSwitch,
                child: Text(
                  "Se connecter",
                  style: TextStyle(
                    color: Colors.cyanAccent.shade200,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SOCIAL BUTTONS
// ─────────────────────────────────────────────
class _SocialButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final narrow = constraints.maxWidth < 380;
      if (narrow) {
        return Column(
          children: [
            _SocialBtn(
                label: 'Google',
                icon: Icons.g_mobiledata,
                color: const Color(0xFFEA4335)),
            const SizedBox(height: 10),
            _SocialBtn(
                label: 'Facebook',
                icon: Icons.facebook,
                color: const Color(0xFF1877F2)),
            const SizedBox(height: 10),
            _SocialBtn(
                label: 'Apple',
                icon: Icons.apple,
                color: Colors.white),
            const SizedBox(height: 10),
            _SocialBtn(
                label: 'WhatsApp',
                icon: Icons.chat,
                color: const Color(0xFF25D366)),
          ],
        );
      }
      return Column(children: [
        Row(children: [
          Expanded(
            child: _SocialBtn(
                label: 'Google',
                icon: Icons.g_mobiledata,
                color: const Color(0xFFEA4335)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SocialBtn(
                label: 'Facebook',
                icon: Icons.facebook,
                color: const Color(0xFF1877F2)),
          ),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(
            child: _SocialBtn(
                label: 'Apple',
                icon: Icons.apple,
                color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SocialBtn(
                label: 'WhatsApp',
                icon: Icons.chat,
                color: const Color(0xFF25D366)),
          ),
        ]),
      ]);
    });
  }
}

class _SocialBtn extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _SocialBtn(
      {required this.label, required this.icon, required this.color});

  @override
  State<_SocialBtn> createState() => _SocialBtnState();
}

class _SocialBtnState extends State<_SocialBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.color.withOpacity(0.15)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered
                  ? widget.color.withOpacity(0.6)
                  : Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: widget.color, size: 20),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SHARED SMALL WIDGETS
// ─────────────────────────────────────────────

class _FormCard extends StatelessWidget {
  final Widget child;
  const _FormCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 460,
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1526).withOpacity(0.9),
        borderRadius: BorderRadius.circular(28),
        border:
            Border.all(color: Colors.white.withOpacity(0.08), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 60,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FormTitle extends StatelessWidget {
  final String text;
  const _FormTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      );
}

class _FormSubtitle extends StatelessWidget {
  final String text;
  const _FormSubtitle(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
            color: Colors.white.withOpacity(0.4), fontSize: 14),
      );
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.65),
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      );
}

class _AuthField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  const _AuthField({
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  State<_AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<_AuthField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (f) => setState(() => _focused = f),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _focused
                ? Colors.cyanAccent.shade200.withOpacity(0.7)
                : Colors.white.withOpacity(0.1),
            width: _focused ? 1.5 : 1,
          ),
          color: Colors.white.withOpacity(_focused ? 0.07 : 0.04),
        ),
        child: TextField(
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.25), fontSize: 14),
            prefixIcon:
                Icon(widget.icon, color: Colors.white38, size: 18),
            suffixIcon: widget.suffixIcon,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
                vertical: 16, horizontal: 16),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _hovered
                  ? [
                      const Color(0xFF2563EB),
                      const Color(0xFF1E3A8A),
                    ]
                  : [
                      primaryBlue,
                      const Color(0xFF1E40AF),
                    ],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withOpacity(_hovered ? 0.55 : 0.3),
                blurRadius: _hovered ? 24 : 14,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Center(
            child: Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckboxRow extends StatefulWidget {
  final String label;
  const _CheckboxRow({required this.label});

  @override
  State<_CheckboxRow> createState() => _CheckboxRowState();
}

class _CheckboxRowState extends State<_CheckboxRow> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => setState(() => _checked = !_checked),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: _checked ? primaryBlue : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: _checked
                    ? primaryBlue
                    : Colors.white.withOpacity(0.25),
                width: 1.5,
              ),
            ),
            child: _checked
                ? const Icon(Icons.check, color: Colors.white, size: 12)
                : null,
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            widget.label,
            style: TextStyle(
                color: Colors.white.withOpacity(0.5), fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Divider(
              color: Colors.white.withOpacity(0.1), thickness: 1)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Text(
          'ou continuer avec',
          style: TextStyle(
              color: Colors.white.withOpacity(0.3), fontSize: 12),
        ),
      ),
      Expanded(
          child: Divider(
              color: Colors.white.withOpacity(0.1), thickness: 1)),
    ]);
  }
}

// ─────────────────────────────────────────────
//  GLOW BLOB
// ─────────────────────────────────────────────
class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  STARS PAINTER
// ─────────────────────────────────────────────
class _StarsPainter extends CustomPainter {
  final double progress;
  final List<Offset> stars;
  final List<double> sizes;
  final List<double> opacities;

  const _StarsPainter({
    required this.progress,
    required this.stars,
    required this.sizes,
    required this.opacities,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (int i = 0; i < stars.length; i++) {
      final x = stars[i].dx * size.width;
      final y = (stars[i].dy * size.height + progress * 100) % size.height;
      paint.color = Colors.white.withOpacity(opacities[i]);
      canvas.drawCircle(Offset(x, y), sizes[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarsPainter old) =>
      old.progress != progress;
}