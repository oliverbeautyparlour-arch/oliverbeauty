import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webui/frontend/about_screen.dart';
import 'package:webui/frontend/api.dart';
import 'package:webui/frontend/bookings_screen.dart';
import 'package:webui/frontend/home_screen.dart';
import 'package:webui/frontend/offers_screen.dart';
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
  String? _lastLoadedUserId;

  bool _editing = false;

  Future<void> loadUserData() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userId = auth.userId;

    if (userId == null || userId.isEmpty) return;

    final result = await ApiService().getProfile(userId);

    if (result != null && result["success"] == true && mounted) {
      setState(() {
        _nameCtrl.text = result["data"]["name"];
        _emailCtrl.text = result["data"]["email"];
        _lastLoadedUserId = userId;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = Provider.of<AuthProvider>(context);

    if (auth.userId != null && auth.userId != _lastLoadedUserId) {
      loadUserData();
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
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
                                    color: Colors.white.withValues(alpha: 0.15),
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
                                color: Colors.white.withValues(alpha: 0.2),
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
                          _nameCtrl.text,
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
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),

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
                        onTap: () async {
                          if (_editing) {
                            final prefs = await SharedPreferences.getInstance();

                            final success = await ApiService().updateProfile(
                              userId: prefs.getString("userId")!,
                              name: _nameCtrl.text,
                              email: _emailCtrl.text,
                            );

                            if (success) {
                              await loadUserData();

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Profile Updated"),
                                ),
                              );
                            }
                          }

                          setState(() {
                            _editing = !_editing;
                          });
                        },
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

                          if (_editing) ...[const SizedBox(height: 14)],
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
                            root: BookingsScreen(),
                          ),
                          _MenuItem(
                            icon: Icons.star_rounded,
                            label: 'My Reviews',
                            color: AppTheme.accent,
                           externalUrl: 'https://g.page/r/CY7QhLU4WzTtEAE/review',
                          ),

                          _MenuItem(
                            icon: Icons.lock_outline_rounded,
                            label: 'Change Password',
                            color: AppTheme.textMid,
                            root: ResetPasswordScreen()
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
                            root: OffersScreen(),
                          ),
                          _MenuItem(
                            icon: Icons.help_outline_rounded,
                            label: 'Help & Support',
                            color: Colors.blue,
                            root: HelpSupportScreen(),
                          ),
                          _MenuItem(
                            icon: Icons.info_outline_rounded,
                            label: 'About Us',
                            color: AppTheme.textLight,
                            root: AboutUsScreen()
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
                      onTap: () async {
                          final auth = context.read<AuthProvider>();

  if (!auth.isLoggedIn) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("You haven't logged in yet.")),
    );
    return;
  }
      // Show confirmation dialog
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Logout"),
            ),
          ],
        ),
      );

      if (shouldLogout == true) {
       await context.read<AuthProvider>().logout();
     
 Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>  HomeScreen()
          ),
          (route) => false, 
        );
      }
    },
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.15),
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
                  ? AppTheme.primary.withValues(alpha: 0.3)
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
  final Widget? root;
   final String? externalUrl;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
     this.root,
    this.externalUrl,
  }): assert(
         root != null || externalUrl != null,
         'Provide either root or externalUrl',
       );
       Future<void> _handleTap(BuildContext context) async {
    if (externalUrl != null) {
      final uri = Uri.parse(externalUrl!);
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn't open the link.")),
        );
      }
    } else if (root != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => root!),
      );
    }
  }
  @override
  Widget build(BuildContext context) => PressableScale(
    onTap: ()   => _handleTap(context),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
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
