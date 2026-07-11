import 'package:flutter/material.dart';
import 'package:webui/frontend/home_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'common_widgets.dart';
import 'models.dart';
import 'app_theme.dart';

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
  int _payMethod = 0;
  bool _confirming = false;
  bool _confirmed = false;

  late AnimationController _summaryCtrl;
  late AnimationController _payCtrl;
  late AnimationController _successCtrl;
  late Animation<double> _successScale;
  late Animation<double> _successFade;

  final _payMethods = [
    {'icon': '📱', 'label': 'UPI', 'sub': 'Pay using any UPI app'},
    {
      'icon': '💳',
      'label': 'Credit / Debit Card',
      'sub': 'Visa, MasterCard, Rupay',
    },
    {'icon': '🏦', 'label': 'Net Banking', 'sub': 'All major banks'},
    {'icon': '💵', 'label': 'Pay at Salon', 'sub': 'Pay in cash at the salon'},
  ];

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

  bool success = await saveBooking();

  setState(() {
    _confirming = false;
  });

  if(success){

    setState(() {
      _confirmed = true;
    });

    _successCtrl.forward();

  }

  else{

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(

        content: Text("Booking Failed"),

      ),

    );

  }

}
Future<bool> saveBooking() async {

  final bookingDateTime = DateTime(
    widget.date.year,
    widget.date.month,
    widget.date.day,
    widget.time.hour,
    widget.time.minute,
  );

  final paymentMethod = _payMethods[_payMethod]["label"];

  final body = {

    "userId": "USER001",   // Replace later after login

    "serviceId": widget.service.serviceId,

    "serviceName": widget.service.serviceName,

    "bookedPrice": widget.service.price,

    "bookedDuration": widget.service.durationMins,

    "bookingDateTime": bookingDateTime.toIso8601String(),

    "paymentType": paymentMethod,

    "status": "Confirmed"

  };

  try {

    final response = await http.post(

      Uri.parse("http://localhost:3000/addBookings"),

      headers: {
        "Content-Type":"application/json"
      },

      body: jsonEncode(body),

    );
     print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");
   // print("Request: ${jsonEncode(booking.toJson())}");

    if(response.statusCode == 201){

      return true;

    }

    return false;

  }

  catch(e){

    print(e);

    return false;

  }

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
    final total = widget.service.price - 50 + widget.service.price * 0.05;

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
                            '- ₹50',
                            color: Colors.green.shade600,
                          ),
                          const SizedBox(height: 6),
                          _PriceRow(
                            'Tax (5%)',
                            '₹${(widget.service.price * 0.05).toStringAsFixed(2)}',
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

                // ── Payment method ────────────────────────────────────────────
                SlideTransition(
                  position:
                      Tween<Offset>(
                        begin: const Offset(0.15, 0),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _payCtrl,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                  child: FadeTransition(
                    opacity: _payCtrl,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.divider),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Payment Method',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textDark,
                              fontFamily: 'Georgia',
                            ),
                          ),
                          const SizedBox(height: 14),
                          ...List.generate(_payMethods.length, (i) {
                            final selected = _payMethod == i;
                            return GestureDetector(
                              onTap: () => setState(() => _payMethod = i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? AppTheme.primary.withOpacity(0.05)
                                      : AppTheme.surface,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: selected
                                        ? AppTheme.primary
                                        : AppTheme.divider,
                                    width: selected ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      _payMethods[i]['icon']!,
                                      style: const TextStyle(fontSize: 22),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _payMethods[i]['label']!,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: selected
                                                  ? AppTheme.primary
                                                  : AppTheme.textDark,
                                            ),
                                          ),
                                          Text(
                                            _payMethods[i]['sub']!,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: AppTheme.textLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: selected
                                            ? AppTheme.primary
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: selected
                                              ? AppTheme.primary
                                              : AppTheme.divider,
                                          width: 2,
                                        ),
                                      ),
                                      child: selected
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 11,
                                            )
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'By proceeding, you agree to our Terms & Conditions',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textLight,
                  ),
                  textAlign: TextAlign.center,
                ),
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
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            '$label',
            style: const TextStyle(fontSize: 12, color: AppTheme.textLight),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
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
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
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
