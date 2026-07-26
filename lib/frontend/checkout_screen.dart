import 'package:flutter/material.dart';
import 'package:webui/frontend/home_screen.dart';
import 'package:provider/provider.dart';
import 'common_widgets.dart';
import 'models.dart';
import 'app_theme.dart';
import 'api.dart';

class CheckoutScreen extends StatefulWidget {
  final ServiceModel service;
  final String staff;
  final DateTime date;
  final TimeOfDay time;

  const CheckoutScreen({
    super.key,
    required this.service,
    required this.staff,
    required this.date,
    required this.time,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with TickerProviderStateMixin {
 

  bool _confirming = false;
  bool _confirmed = false;

  late AnimationController _summaryCtrl;
  late AnimationController _payCtrl;
  late AnimationController _successCtrl;
  late Animation<double> _successScale;
  late Animation<double> _successFade;

  BookingModel _createBooking() {
    final auth = context.read<AuthProvider>();
    return BookingModel(
      userId: auth.userId!,
      serviceId: widget.service.serviceId,
      serviceName: widget.service.serviceName,
      bookedPrice: widget.service.price,
      bookedDuration: widget.service.durationMins,
      bookingDateTime: DateTime(
        widget.date.year,
        widget.date.month,
        widget.date.day,
        widget.time.hour,
        widget.time.minute,
      ),
   
    );
  }


  @override
  void initState() {
    super.initState();

    _summaryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _payCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _successCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _successScale = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _successCtrl, curve: Curves.elasticOut));
    _successFade = CurvedAnimation(parent: _successCtrl, curve: Curves.easeOut);

    Future.delayed(
      const Duration(milliseconds: 100),
      () => _summaryCtrl.forward(),
    );
    Future.delayed(const Duration(milliseconds: 300), () => _payCtrl.forward());
  }

  @override
  void dispose() {
   
    _summaryCtrl.dispose();
    _payCtrl.dispose();
    _successCtrl.dispose();
    super.dispose();
  }



  void _confirmBooking() async {
  setState(() {
    _confirming = true;
  });

  bool success = await ApiService().addBooking(_createBooking());

  if (success) {
    setState(() {
      _confirmed = true;
    });

    _successCtrl.forward();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking Failed")),
    );
  }

  setState(() {
    _confirming = false;
  });
}

  int discount() {
    if (widget.service.price.toInt() > 1000) {
      return 100;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: _confirmed
          ? _SuccessView(scale: _successScale, fade: _successFade)
          : _checkoutBody(context),
    );
  }

  Widget _checkoutBody(BuildContext context) {
    final total = widget.service.price - discount();

    return Column(
      children: [
        // ── AppBar ────────────────────────────────────────────────────────────
        Container(
          color: Colors.white,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 15,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      Text(
                        'Home / Booking / Checkout',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.textLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // ── Booking summary ────────────────────────────────────────────
                SlideTransition(
                  position:
                      Tween<Offset>(
                        begin: const Offset(-0.15, 0),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _summaryCtrl,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                  child: FadeTransition(
                    opacity: _summaryCtrl,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.divider),
                        boxShadow: const [
                          BoxShadow(color: Color(0x0A000000), blurRadius: 16),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Booking Summary',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textDark,
                              fontFamily: 'Georgia',
                            ),
                          ),
                          const SizedBox(height: 14),
                          const GoldDivider(),
                          const SizedBox(height: 14),
                          _InfoRow('Service', widget.service.serviceName),
                          _InfoRow('Staff', widget.staff),
                          _InfoRow(
                            'Date',
                            '${widget.date.day} ${_month(widget.date.month)} ${widget.date.year}',
                          ),
                          _InfoRow('Time', widget.time.format(context)),
                          _InfoRow(
                            'Duration',
                            '${widget.service.durationMins} mins',
                          ),
                          const SizedBox(height: 14),
                          const GoldDivider(),
                          const SizedBox(height: 14),
                          const Text(
                            'Price Details',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _PriceRow(
                            'Service Amount',
                            '₹${widget.service.price.toInt()}',
                          ),
                          const SizedBox(height: 6),
                          _PriceRow(
                            'Discount',

                            '-${discount()}',
                            color: Colors.green.shade600,
                          ),

                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFF5F0), Color(0xFFFDE8E0)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'Total Amount',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textDark,
                                    fontFamily: 'Georgia',
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '₹${total.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

            
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // ── Confirm button ────────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 16,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: PressableScale(
            onTap: _confirming ? null : _confirmBooking,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _confirming
                      ? [AppTheme.primaryLight, AppTheme.primaryLight]
                      : [AppTheme.primary, AppTheme.primaryDark],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: _confirming
                    ? []
                    : [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
              ),
              child: Center(
                child: _confirming
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'Confirm Booking',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);
  @override
  Widget build(BuildContext context) =>
     
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: const TextStyle(color: AppTheme.textLight, fontSize: 13),
              ),
            ),

            Expanded(
              flex: 3,
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const _PriceRow(this.label, this.value, {this.color});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 13, color: AppTheme.textMid),
      ),
      const Spacer(),
      Text(
        value,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: color ?? AppTheme.textDark,
        ),
      ),
    ],
  );
}

// ─── Success Screen ───────────────────────────────────────────────────────────
class _SuccessView extends StatelessWidget {
  final Animation<double> scale;
  final Animation<double> fade;
  const _SuccessView({required this.scale, required this.fade});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFDF8F5), Color(0xFFF9F0EB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: fade,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: scale,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppTheme.primary, AppTheme.primaryDark],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 52,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Booking Confirmed!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textDark,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your appointment has been\nsuccessfully booked.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppTheme.textMid,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 32),
                // Confetti-like decorative row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('🌸', style: TextStyle(fontSize: 22)),
                    SizedBox(width: 8),
                    Text('✨', style: TextStyle(fontSize: 22)),
                    SizedBox(width: 8),
                    Text('💄', style: TextStyle(fontSize: 22)),
                    SizedBox(width: 8),
                    Text('✨', style: TextStyle(fontSize: 22)),
                    SizedBox(width: 8),
                    Text('🌸', style: TextStyle(fontSize: 22)),
                  ],
                ),
                const SizedBox(height: 40),
                PressableScale(
                  onTap: () => Navigator.of(context).pushAndRemoveUntil(
                    
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.primary, AppTheme.primaryDark],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
