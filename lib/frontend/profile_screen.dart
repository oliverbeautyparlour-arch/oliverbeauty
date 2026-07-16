import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import '../theme/app_theme.dart';
//import '../widgets/common_widgets.dart';
import 'common_widgets.dart';
import 'app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _headerCtrl;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;


  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _editing = false;

Future<void> loadUserData() async {
  final prefs = await SharedPreferences.getInstance();

  setState(() {
    _nameCtrl.text = prefs.getString("name") ?? "";
    _emailCtrl.text = prefs.getString("email") ?? "";
    _phoneCtrl.text = prefs.getString("phone") ?? "Add your Phone Number";
  });
}
  @override
  void initState() {
    super.initState();
    _headerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _headerFade = CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOutCubic));
    _headerCtrl.forward();
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: CustomScrollView(
        slivers: [
          // ── Header ───────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _headerFade,
              child: SlideTransition(
                position: _headerSlide,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF8B4A43),
                        Color(0xFFB5736A),
                        Color(0xFFD4AF7A),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                          child: Row(
                            children: [
                              const Text(
                                'Profile',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  fontFamily: 'Georgia',
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.settings_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Avatar
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '👩',
                                  style: TextStyle(fontSize: 48),
                                ),
                              ),
                            ),
                            PressableScale(
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.accent,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _nameCtrl.text  ,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontFamily: 'Georgia',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _emailCtrl.text,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        // const SizedBox(height: 20),
                        // // Stats row
                        // Container(
                        //   margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        //   padding: const EdgeInsets.symmetric(vertical: 14),
                        //   decoration: BoxDecoration(
                        //     color: Colors.white.withOpacity(0.15),
                        //     borderRadius: BorderRadius.circular(16),
                        //     border: Border.all(
                        //       color: Colors.white.withOpacity(0.2),
                        //     ),
                        //   ),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //     children: [
                        //       _StatItem(label: 'Bookings', value: '12'),
                        //       _VertDivider(),
                        //       _StatItem(label: 'Reviews', value: '5'),
                        //       _VertDivider(),
                        //       _StatItem(label: 'Points', value: '480'),
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile Info
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 200),
                    child: _SectionCard(
                      title: 'Profile Information',
                      trailing: GestureDetector(
                        onTap: () => setState(() => _editing = !_editing),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _editing
                                ? AppTheme.primary
                                : AppTheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _editing
                                  ? AppTheme.primary
                                  : AppTheme.divider,
                            ),
                          ),
                          child: Text(
                            _editing ? 'Done' : 'Edit',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _editing ? Colors.white : AppTheme.primary,
                            ),
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          _ProfileField(
                            label: 'Full Name',
                            controller: _nameCtrl,
                            enabled: _editing,
                          ),
                          _ProfileField(
                            label: 'Email',
                            controller: _emailCtrl,
                            enabled: _editing,
                          ),
                          _ProfileField(
                            label: 'Phone Number',
                            controller: _phoneCtrl,
                            enabled: _editing,
                          ),
                          if (_editing) ...[
                            const SizedBox(height: 14),
                            PressableScale(
                              child: Container(
                                width: double.infinity,
                                height: 46,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppTheme.primary,
                                      AppTheme.primaryDark,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primary.withOpacity(0.35),
                                      blurRadius: 14,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    'Update Profile',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Menu items
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 300),
                    child: _SectionCard(
                      title: 'Account',
                      child: Column(
                        children: [
                          _MenuItem(
                            icon: Icons.receipt_long_rounded,
                            label: 'My Bookings',
                            color: AppTheme.primary,
                          ),
                          _MenuItem(
                            icon: Icons.star_rounded,
                            label: 'My Reviews',
                            color: AppTheme.accent,
                          ),
                          _MenuItem(
                            icon: Icons.account_balance_wallet_rounded,
                            label: 'My Wallet',
                            color: Colors.green,
                          ),
                          _MenuItem(
                            icon: Icons.lock_outline_rounded,
                            label: 'Change Password',
                            color: AppTheme.textMid,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Offers / About
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 400),
                    child: _SectionCard(
                      title: 'More',
                      child: Column(
                        children: [
                          _MenuItem(
                            icon: Icons.local_offer_rounded,
                            label: 'Offers & Deals',
                            color: Colors.orange,
                          ),
                          _MenuItem(
                            icon: Icons.help_outline_rounded,
                            label: 'Help & Support',
                            color: Colors.blue,
                          ),
                          _MenuItem(
                            icon: Icons.info_outline_rounded,
                            label: 'About Us',
                            color: AppTheme.textLight,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Logout
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 500),
                    child: PressableScale(
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.15),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout_rounded,
                              color: Colors.redAccent,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          fontFamily: 'Georgia',
        ),
      ),
      Text(
        label,
        style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.7)),
      ),
    ],
  );
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 32, color: Colors.white.withOpacity(0.2));
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  const _SectionCard({required this.title, required this.child, this.trailing});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppTheme.divider),
      boxShadow: const [BoxShadow(color: Color(0x07000000), blurRadius: 12)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 16, 0),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                  fontFamily: 'Georgia',
                ),
              ),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, color: AppTheme.divider),
        const SizedBox(height: 4),
        child,
        const SizedBox(height: 4),
      ],
    ),
  );
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;
  const _ProfileField({
    required this.label,
    required this.controller,
    required this.enabled,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: enabled ? AppTheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: enabled
                  ? AppTheme.primary.withOpacity(0.3)
                  : Colors.transparent,
            ),
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: enabled ? 10 : 0,
                vertical: 8,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    ),
  );
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
  });
  @override
  Widget build(BuildContext context) => PressableScale(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppTheme.textLight,
            size: 18,
          ),
        ],
      ),
    ),
  );
}
