import 'package:flutter/material.dart';
import 'app_theme.dart';

// ── Fade + slide in on build ──────────────────────────────────────────────────
class FadeSlideIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Offset beginOffset;
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.beginOffset = const Offset(0, 0.3),
  });

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: widget.beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _fade,
    child: SlideTransition(position: _slide, child: widget.child),
  );
}

// ── Pressable scale button ────────────────────────────────────────────────────
class PressableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const PressableScale({super.key, required this.child, this.onTap});

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.93,
      upperBound: 1.0,
      value: 1.0,
    );
    _scale = _ctrl;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: (_) => _ctrl.reverse(),
    onTapUp: (_) {
      _ctrl.forward();
      widget.onTap?.call();
    },
    onTapCancel: () => _ctrl.forward(),
    child: ScaleTransition(scale: _scale, child: widget.child),
  );
}

// ── Luxury nav bar ────────────────────────────────────────────────────────────
class LuxuryNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  const LuxuryNavBar({super.key, this.title = '', this.showBack = true});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              if (showBack)
                PressableScale(
                  onTap: () => Navigator.maybePop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: AppTheme.textDark,
                    ),
                  ),
                ),
              if (showBack) const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                    fontFamily: 'Georgia',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              // Cart / notifications icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  size: 20,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Service card ─────────────────────────────────────────────────────────────
class ServiceCard extends StatelessWidget {
  final String name;
  final String duration;
  final String price;
  final bool isadmin;
  final String image;
  final VoidCallback? onBook;
  final bool ishomescreen;
  //final double bottomSpacing;

  final double size;
  const ServiceCard({
    super.key,
    required this.name,
    required this.ishomescreen,
    required this.duration,
    required this.isadmin,
    required this.price,
    required this.image,
    required this.size,
    this.onBook,
    //required this.bottomSpacing,
  });

  String btn() {
    String word = "";
    if (!isadmin) {
      word = "Book Now";
    } else {
      word = "Edit";
    }
    return word;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient image placeholder
          Container(
            height: 110,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryLight.withOpacity(0.6),
                  AppTheme.accentLight,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),

child: ClipRRect(
  borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(18),
    topRight: Radius.circular(18),
  ),
  child: Image.asset(
    'assets/${image}',
    width: double.infinity,
    height: 170,
    fit: BoxFit.cover,
  ),
),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 12,
                        color: AppTheme.textLight,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        duration,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textLight,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: SizedBox()),

                  PressableScale(
                    onTap: onBook ,
                    child: Container(
                      width: double.infinity,
                      height: 34,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.primary, AppTheme.primaryDark],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:  Center(
                        child: Text(
                          btn()
                          ,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Gold divider ──────────────────────────────────────────────────────────────
class GoldDivider extends StatelessWidget {
  const GoldDivider({super.key});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Container(height: 1, color: AppTheme.divider)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: AppTheme.accent,
            shape: BoxShape.circle,
          ),
        ),
      ),
      Expanded(child: Container(height: 1, color: AppTheme.divider)),
    ],
  );
}

// ── Section title ─────────────────────────────────────────────────────────────
class SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionTitle({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppTheme.textDark,
          fontFamily: 'Georgia',
        ),
      ),
      if (action != null)
        GestureDetector(
          onTap: onAction,
          child: Text(
            action!,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
    ],
  );
}
