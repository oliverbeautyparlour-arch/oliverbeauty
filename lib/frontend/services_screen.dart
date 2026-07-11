import 'package:flutter/material.dart';
import 'package:webui/admin_panel/admin_dashboard.dart';
import 'app_theme.dart';
import 'models.dart';
import 'common_widgets.dart';
import 'booking_screen.dart';
import 'api.dart';
import 'package:provider/provider.dart';

class ServicesScreen extends StatefulWidget {
  final String selectedCategory;
  final bool isadmin;

  const ServicesScreen({
    super.key,
    this.selectedCategory = 'All Services',
    required this.isadmin,
  });
  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen>
    with SingleTickerProviderStateMixin {
  late String _selectedCategory = 'All Services';
  late AnimationController _ctrl;

  final categories = [
    'All Services',
    'Hair',
    'Skin',
    'Makeup',
    'Nails',
    'Bridal',
  ];

  List<ServiceModel> get filtered {
    final services = context.watch<ServiceProvider>().services;

    return _selectedCategory == 'All Services'
        ? services
        : services.where((s) => s.category == _selectedCategory).toList();
  }

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _ctrl.forward();
    Future.microtask(() {
      context.read<ServiceProvider>().fetchServices();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _selectCategory(String cat) {
    setState(() => _selectedCategory = cat);
    _ctrl.reset();
    _ctrl.forward();
  }

  double size() {
    double width = MediaQuery.of(context).size.width;
    if (width > 1000) {
      return getScale(width);
    }
    return 0.90;
  }

  double getScale(double width) {
    double value = (width / 1000) * 0.90;
    return value.clamp(0.85, 1.1);
  }

  int media() {
    final double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    if (width > 1200) {
      return 4;
    } else if (width > 900) {
      return 3;
    }

    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final services = context.watch<ServiceProvider>().services;
    if (services.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                const Text(
                  'Our Services',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark,
                    fontFamily: 'Georgia',
                  ),
                ),
                Text(
                  'Home / Services',
                  style: TextStyle(fontSize: 11, color: AppTheme.textLight),
                ),
              ],
            ),
          ),

          // Category tabs
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemCount: categories.length,
                      itemBuilder: (ctx, i) {
                        final selected = categories[i] == _selectedCategory;
                        return GestureDetector(
                          onTap: () => _selectCategory(categories[i]),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              gradient: selected
                                  ? const LinearGradient(
                                      colors: [
                                        AppTheme.primary,
                                        AppTheme.primaryDark,
                                      ],
                                    )
                                  : null,
                              color: selected ? null : AppTheme.surface,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: selected
                                    ? AppTheme.primary
                                    : AppTheme.divider,
                              ),
                            ),
                            child: Text(
                              categories[i],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: selected
                                    ? Colors.white
                                    : AppTheme.textMid,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Grid
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((ctx, i) {
                final s = filtered[i];
                return FadeSlideIn(
                  delay: Duration(milliseconds: 60 * i),
                  child: ServiceCard(
                    name: s.serviceName,
                    duration: '${s.durationMins} mins',
                    price: '₹${s.price.toInt()}',
                    emoji: s.emoji,
                    ishomescreen: false,
                    isadmin: false,
                    size: MediaQuery.of(context).size.width,
                    onBook: () {
                      if (widget.isadmin) {
                        Navigator.push(context, _slideRoute(AdminDashboard(service: s,)));
                      } else {
                        Navigator.push(
                          context,

                          _slideRoute(BookingScreen(islogin: false)),
                        );
                      }
                    },
                  ),
                );
              }, childCount: filtered.length),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: media(),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: size(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

PageRouteBuilder _slideRoute(Widget page) => PageRouteBuilder(
  pageBuilder: (_, a, __) => page,
  transitionsBuilder: (_, a, __, child) => SlideTransition(
    position: Tween(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
    child: child,
  ),
  transitionDuration: const Duration(milliseconds: 350),
);
