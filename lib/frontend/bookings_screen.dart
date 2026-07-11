import 'package:flutter/material.dart';
import 'api.dart';
import 'app_theme.dart';
import 'models.dart';
import 'common_widgets.dart';
import 'package:provider/provider.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});
  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<BookingProvider>(
      context,
      listen: false,
    ).fetchBookings();
  });
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────────
          Container(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Row(
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'My Bookings',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textDark,
                                fontFamily: 'Georgia',
                              ),
                            ),
                            Text(
                              'Home / My Bookings',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppTheme.textLight,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.filter_list_rounded,
                            color: AppTheme.textDark,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TabBar(
                    controller: _tab,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    labelColor: AppTheme.primary,
                    unselectedLabelColor: AppTheme.textLight,
                    indicatorColor: AppTheme.primary,
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: const [
                      Tab(text: 'Upcoming'),
                      Tab(text: 'Past'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────────────────────
          Expanded(
  child: Consumer<BookingProvider>(
    builder: (context, provider, child) {
      final upcoming = provider.bookings
          .where((b) => b.bookingDateTime.isAfter(DateTime.now()))
          .toList();

      final past = provider.bookings
          .where((b) => b.bookingDateTime.isBefore(DateTime.now()))
          .toList();

      return TabBarView(
        controller: _tab,
        children: [
          _BookingsList(
            bookings: upcoming,
            upcoming: true,
          ),
          _BookingsList(
            bookings: past,
            upcoming: false,
          ),
        ],
      );
    },
  ),
)
        ],
      ),
    );
  }
}

class _BookingsList extends StatelessWidget {
  final List<BookingModel> bookings;
  final bool upcoming;
  const _BookingsList({required this.bookings, required this.upcoming});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text('📅', style: TextStyle(fontSize: 36)),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No bookings yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your past appointments\nwill appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textLight,
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: bookings.length,
      itemBuilder: (ctx, i) => FadeSlideIn(
        delay: Duration(milliseconds: 80 * i),
        child: _BookingCard(booking: bookings[i], upcoming: upcoming),
      ),
    );
  }
}

class _BookingCard extends StatefulWidget {
  final BookingModel booking;
  final bool upcoming;
  const _BookingCard({required this.booking, required this.upcoming});

  @override
  State<_BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<_BookingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _expandCtrl;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _expandCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _expandCtrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _expandCtrl.forward() : _expandCtrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.booking;
    // final emoji = allServices
    //     .firstWhere(
    //       (s) => s.name == b.serviceName,
    //       orElse: () => allServices.first,
    //     )
    //     .emoji;

    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _expanded
                ? AppTheme.primary.withOpacity(0.3)
                : AppTheme.divider,
          ),
          boxShadow: [
            BoxShadow(
              color: _expanded
                  ? AppTheme.primary.withOpacity(0.08)
                  : const Color(0x06000000),
              blurRadius: _expanded ? 20 : 8,
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Main row ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Service image placeholder
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryLight.withOpacity(0.5),
                          AppTheme.accentLight,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text("hi", style: const TextStyle(fontSize: 26)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b.serviceName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'with StaffName',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textLight,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _MetaChip(
                              icon: Icons.calendar_today_rounded,
                              label:
                                  '${b.bookingDateTime.day} ${_month(b.bookingDateTime.month)}',
                            ),
                            const SizedBox(width: 8),
                            _MetaChip(
                              icon: Icons.access_time_rounded,
                              label:
                                  '${b.bookingDateTime.hour}:${b.bookingDateTime.minute.toString().padLeft(2, '0')} ${b.bookingDateTime.hour < 12 ? 'AM' : 'PM'}',
                            ),
                            const SizedBox(width: 8),
                            _MetaChip(
                              icon: Icons.timer_outlined,
                              label: '${b.bookedDuration} mins',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${b.bookedPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _StatusBadge(status: b.status),
                      const SizedBox(height: 4),
                      RotationTransition(
                        turns: Tween(begin: 0.0, end: 0.5).animate(_expandCtrl),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppTheme.textLight,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Expanded actions ──────────────────────────────────────────
            SizeTransition(
              sizeFactor: CurvedAnimation(
                parent: _expandCtrl,
                curve: Curves.easeOutCubic,
              ),
              child: FadeTransition(
                opacity: _expandCtrl,
                child: Column(
                  children: [
                    const Divider(height: 1, color: AppTheme.divider),
                    if (widget.upcoming)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: PressableScale(
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppTheme.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppTheme.divider),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Reschedule',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.textDark,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: PressableScale(
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.red.withOpacity(0.2),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _month(int m) => [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][m - 1];
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 10, color: AppTheme.textLight),
      const SizedBox(width: 3),
      Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          color: AppTheme.textLight,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});
  @override
  Widget build(BuildContext context) {
    final isConfirmed = status == 'Confirmed';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isConfirmed
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: isConfirmed ? Colors.green.shade700 : Colors.orange.shade700,
        ),
      ),
    );
  }
}
