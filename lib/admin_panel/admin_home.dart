import 'package:flutter/material.dart';
import 'package:webui/admin_panel/admin_dashboard.dart';
import 'package:webui/frontend/api.dart';
import 'package:webui/frontend/app_theme.dart';
import 'package:webui/frontend/gallery_screen.dart';
import 'package:webui/frontend/profile_screen.dart';
import 'package:webui/frontend/services_screen.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> with TickerProviderStateMixin {
  int _navIndex = 0;
  late AnimationController _heroCtrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchDashboard();
    });
    _heroCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
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
    final pages = [
      const _Home(),
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
  const _Home();

  String _formatCurrency(double amount) {
    final isNegative = amount < 0;
    final value = amount.abs().toStringAsFixed(0);
    String result = '';
    int count = 0;

    for (int i = value.length - 1; i >= 0; i--) {
      result = value[i] + result;
      count++;
      final remaining = i;
      if (remaining > 0) {
        if (count == 3) {
          result = ',$result';
        } else if (count > 3 && (count - 3) % 2 == 0) {
          result = ',$result';
        }
      }
    }
    return "${isNegative ? '-' : ''}₹$result";
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = context.watch<DashboardProvider>();
    final topServiceProvider = context.watch<TopServiceProvider>();
    final dashboard = dashboardProvider.dashboard;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: RefreshIndicator(
        color: AppTheme.primary,
        onRefresh: () async {
          await context.read<DashboardProvider>().fetchDashboard();
          await context.read<TopServiceProvider>().fetchTopServices();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                
                children: [
                  Text(
                    "Welcome Admin 👋",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                  ElevatedButton.icon(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminDashboard()
                    ));
                  },icon: Icon(Icons.add, size: 22,), 
                  label:Text("Add Service", style: TextStyle(
                    
             // backgroundColor:AppTheme.primaryDark ,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.bgCard,
                    ),))
                ],
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

              if (dashboardProvider.isLoading && dashboard == null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: CircularProgressIndicator(color: AppTheme.primary),
                  ),
                )
              else if (dashboard == null)
                _errorBox("Couldn't load dashboard data", () {
                  context.read<DashboardProvider>().fetchDashboard();
                })
              else
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
                      "${dashboard.bookings}",
                      "Bookings",
                      Colors.blue,
                    ),
                    dashboardCard(
                      Icons.currency_rupee,
                      _formatCurrency(dashboard.revenue),
                      "Revenue",
                      Colors.green,
                    ),
                    dashboardCard(
                      Icons.people,
                      "${dashboard.customers}",
                      "Customers",
                      Colors.orange,
                    ),
                    dashboardCard(
                      Icons.spa,
                      "${dashboard.services}",
                      "Services",
                      Colors.purple,
                    ),
                  ],
                ),

              const SizedBox(height: 30),

              Text(
                "Top Booked Services",
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
                padding: const EdgeInsets.fromLTRB(12, 20, 20, 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: .15),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: topServiceProvider.isLoading && topServiceProvider.topServices.isEmpty
                    ? Center(child: CircularProgressIndicator(color: AppTheme.primary))
                    : topServiceProvider.topServices.isEmpty
                        ? Center(
                            child: Text(
                              "No bookings yet",
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          )
                        : BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: (topServiceProvider.topServices
                                          .map((s) => s.totalBookings)
                                          .reduce((a, b) => a > b ? a : b) +
                                      2)
                                  .toDouble(),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: 1,
                                getDrawingHorizontalLine: (value) => FlLine(
                                  color: Colors.grey.withValues(alpha: .15),
                                  strokeWidth: 1,
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              titlesData: FlTitlesData(
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 28,
                                    interval: 1,
                                    getTitlesWidget: (value, meta) {
                                      if (value != value.roundToDouble()) {
                                        return const SizedBox.shrink();
                                      }
                                      return Text(
                                        value.toInt().toString(),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade500,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 36,
                                    getTitlesWidget: (value, meta) {
                                      final i = value.toInt();
                                      if (i < 0 || i >= topServiceProvider.topServices.length) {
                                        return const SizedBox.shrink();
                                      }
                                      final name = topServiceProvider.topServices[i].serviceName;
                                      final shortName = name.length > 8
                                          ? '${name.substring(0, 8)}…'
                                          : name;
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          shortName,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: AppTheme.primaryDark,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipColor: (_) => AppTheme.primaryDark,
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    final service = topServiceProvider.topServices[group.x.toInt()];
                                    return BarTooltipItem(
                                      "${service.serviceName}\n${rod.toY.toInt()} bookings",
                                      const TextStyle(color: Colors.white, fontSize: 12),
                                    );
                                  },
                                ),
                              ),
                              barGroups: List.generate(
                                topServiceProvider.topServices.length,
                                (i) {
                                  final service = topServiceProvider.topServices[i];
                                  return BarChartGroupData(
                                    x: i,
                                    barRods: [
                                      BarChartRodData(
                                        toY: service.totalBookings.toDouble(),
                                        width: 22,
                                        borderRadius: BorderRadius.circular(6),
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            AppTheme.primary,
                                            AppTheme.primaryLight,
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorBox(String message, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: Colors.grey.shade400, size: 32),
            const SizedBox(height: 8),
            Text(message, style: TextStyle(color: Colors.grey.shade500)),
            const SizedBox(height: 8),
            TextButton(onPressed: onRetry, child: const Text("Retry")),
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
            color: Colors.grey.withValues(alpha: .15),
            blurRadius: 10,
          )
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: .15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
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
      //{'icon': Icons.receipt_long_rounded, 'label': 'Bookings'},
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
    curve: Curves.easeOut,
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          items[i]['icon'] as IconData,
          color: selected ? AppTheme.primary : Colors.grey,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          items[i]['label'] as String,
          style: TextStyle(
            fontSize: 11,
            fontWeight: selected
                ? FontWeight.w600
                : FontWeight.w500,
            color: selected
                ? AppTheme.primary
                : Colors.grey,
          ),
        ),
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

// PageRouteBuilder _slideRoute(Widget page) => PageRouteBuilder(
//   pageBuilder: (_, a, __) => page,
//   transitionsBuilder: (_, a, __, child) => SlideTransition(
//     position: Tween(
//       begin: const Offset(1, 0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
//     child: child,
//   ),
//   transitionDuration: const Duration(milliseconds: 350),
// );