import 'package:flutter/material.dart';
import 'package:webui/frontend/app_theme.dart';
import 'package:webui/frontend/gallery_screen.dart';
import 'package:webui/frontend/profile_screen.dart';
import 'package:webui/frontend/services_screen.dart';
import 'package:webui/frontend/api.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> with TickerProviderStateMixin {
  int _navIndex = 0;
  late AnimationController _heroCtrl;
  late Animation<double> _heroFade;
  late Animation<Offset> _heroSlide;

  @override
  void initState() {
    super.initState();
    _heroCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _heroFade = CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut);
    _heroSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOutCubic));
    _heroCtrl.forward();
    Future.microtask(() {
      context.read<ServiceProvider>().fetchServices();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TopServiceProvider>(
        context,
        listen: false,
      ).fetchTopServices();
    });
  }

  @override
  void dispose() {
    _heroCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final services = context.watch<ServiceProvider>().services;
    final pages = [
      _Home(

      ),
      const ServicesScreen(isadmin: true),
      const GalleryScreen(),
  
      const ProfileScreen(),
    ];
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: IndexedStack(index: _navIndex, children: pages),
      bottomNavigationBar: _BottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() {
          _navIndex = i;
        }),
      ),
    );
  }
}
class _Home extends StatelessWidget {
  const _Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

            Text(
              "Welcome Admin 👋",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryDark,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Here's today's business summary",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.4,
              children: [

                dashboardCard(
                  Icons.calendar_today,
                  "248",
                  "Bookings",
                  Colors.blue,
                ),

                dashboardCard(
                  Icons.currency_rupee,
                  "₹1,24,500",
                  "Revenue",
                  Colors.green,
                ),

                dashboardCard(
                  Icons.people,
                  "156",
                  "Customers",
                  Colors.orange,
                ),

                dashboardCard(
                  Icons.spa,
                  "12",
                  "Services",
                  Colors.purple,
                ),
              ],
            ),

            const SizedBox(height: 30),

            Text(
              "Bookings by Service",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryDark,
              ),
            ),

            const SizedBox(height: 15),

            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Center(
                child: Text(
                  "Bar Chart Here",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "Today Schedules",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryDark,
              ),
            ),

            const SizedBox(height: 15),

            bookingTile(
              "Sindhu",
              "Hair Spa",
              "₹800",
            ),

            bookingTile(
              "Priya",
              "Facial",
              "₹600",
            ),

            bookingTile(
              "Anitha",
              "Bridal Makeup",
              "₹4500",
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardCard(
      IconData icon,
      String value,
      String title,
      Color color,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.15),
            blurRadius: 10,
          )
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          CircleAvatar(
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, color: color),
          ),

          const SizedBox(height: 12),

          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget bookingTile(
      String customer,
      String service,
      String price,
      ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(customer),
        subtitle: Text(service),
        trailing: Text(
          price,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
       {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.spa_rounded, 'label': 'Services'},
      {'icon': Icons.gamepad_outlined, 'label': 'Gallery'},
      // {'icon': Icons.calendar_month_rounded, 'label': 'Book'},
      // {'icon': Icons.receipt_long_rounded, 'label': 'Bookings'},
      {'icon': Icons.person_rounded, 'label': 'Profile'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final selected = i == currentIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutBack,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? AppTheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        items[i]['icon'] as IconData,
                        color: selected ? Colors.white : AppTheme.textLight,
                        size: 22,
                      ),
                      if (selected) ...[
                        const SizedBox(width: 6),
                        Text(
                          items[i]['label'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
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
