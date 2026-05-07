import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  COMMON CONSTANTS
// ─────────────────────────────────────────────
const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color textDark = Color(0xFF111827);

// ─────────────────────────────────────────────
//  SECTION LABEL
// ─────────────────────────────────────────────
class SectionLabel extends StatelessWidget {
  final String label;
  final bool center;
  const SectionLabel({super.key, required this.label, this.center = false});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        textAlign: center ? TextAlign.center : TextAlign.start,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textDark));
  }
}

// ─────────────────────────────────────────────
//  SEE MORE BUTTON
// ─────────────────────────────────────────────
class SeeMoreButton extends StatefulWidget {
  final VoidCallback onTap;
  const SeeMoreButton({super.key, required this.onTap});

  @override
  State<SeeMoreButton> createState() => _SeeMoreButtonState();
}

class _SeeMoreButtonState extends State<SeeMoreButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered ? primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: primaryBlue),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                    color: _hovered ? Colors.white : primaryBlue),
                child: const Text('Voir tout'),
              ),
              const SizedBox(width: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.translationValues(_hovered ? 3 : 0, 0, 0),
                child: Icon(Icons.arrow_forward, size: 14, color: _hovered ? Colors.white : primaryBlue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  EMPTY CATEGORY
// ─────────────────────────────────────────────
class EmptyCategory extends StatelessWidget {
  final String category;
  const EmptyCategory({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text('Aucun produit dans "$category"',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade400)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  WHY ITEM
// ─────────────────────────────────────────────
class WhyItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const WhyItem({super.key, required this.icon, required this.title, required this.subtitle});

  @override
  State<WhyItem> createState() => _WhyItemState();
}

class _WhyItemState extends State<WhyItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: _hovered ? primaryBlue.withOpacity(0.04) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _hovered ? primaryBlue.withOpacity(0.15) : primaryBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(widget.icon, color: primaryBlue, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,
                          color: _hovered ? primaryBlue : textDark)),
                  const SizedBox(height: 4),
                  Text(widget.subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SOCIAL CHIP
// ─────────────────────────────────────────────
class SocialChip extends StatefulWidget {
  final IconData icon;
  final Color color;
  const SocialChip({super.key, required this.icon, required this.color});

  @override
  State<SocialChip> createState() => _SocialChipState();
}

class _SocialChipState extends State<SocialChip> {
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
          padding: EdgeInsets.all(_hovered ? 16 : 14),
          decoration: BoxDecoration(
            color: widget.color.withOpacity(_hovered ? 1.0 : 0.85),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(_hovered ? 0.7 : 0.4),
                blurRadius: _hovered ? 18 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(widget.icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}