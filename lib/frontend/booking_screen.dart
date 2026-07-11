import 'package:flutter/material.dart';
import 'package:webui/frontend/login_screen.dart';
import 'app_theme.dart';
import 'models.dart';
import 'common_widgets.dart';
import 'checkout_screen.dart';
import 'api.dart';
import 'package:provider/provider.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key, required bool islogin});
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with TickerProviderStateMixin {
  int _step = 0;
  ServiceModel? _selectedService;
  String _selectedStaff = "nameofsis";
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  late AnimationController _stepCtrl;
  late Animation<double> _stepFade;
  late Animation<Offset> _stepSlide;

  @override
  void initState() {
    super.initState();
    _stepCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _stepFade = CurvedAnimation(parent: _stepCtrl, curve: Curves.easeOut);
    _stepSlide = Tween<Offset>(
      begin: const Offset(0.08, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _stepCtrl, curve: Curves.easeOutCubic));
    _stepCtrl.forward();
  }

  @override
  void dispose() {
    _stepCtrl.dispose();
    super.dispose();
  }

  void _animateToStep(int step) {
    _stepCtrl.reverse().then((_) {
      setState(() => _step = step);
      _stepCtrl.forward();
    });
  }

  void _next() {
    if (_step < 3) _animateToStep(_step + 1);
  }

  void _back() {
    if (_step > 0) _animateToStep(_step - 1);
  }

 // bool animate = false;

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Column(
        children: [
          // ── App bar ──────────────────────────────────────────────────────────
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
                        if (_step > 0)
                          GestureDetector(
                            onTap: _back,
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
                        if (_step > 0) const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Book Appointment',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textDark,
                                  fontFamily: 'Georgia',
                                ),
                              ),
                              Text(
                                'Home / Booking',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.textLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_step == 0)
                          Row(
                            children: [
                              Text(
                                "Wanna Book? Login first",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textLight,
                                ),
                              ),
                              SizedBox(width: 10),
                              PressableScale(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    _slideRoute(LoginScreen(islogin: true,)),
                                  );

                                  // Navigator.push(
                                  //   context,
                                  //   _diagonalRoute(LoginMark()),
                                  // );
                                },
                                child: Container(
                                  height: 30,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppTheme.primary,
                                        AppTheme.primaryDark,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primary.withOpacity(
                                          0.4,
                                        ),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Log in",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _StepIndicator(current: _step),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ── Step content ─────────────────────────────────────────────────────
          Expanded(
            child: FadeTransition(
              opacity: _stepFade,
              child: SlideTransition(position: _stepSlide, child: _buildStep()),
            ),
          ),

          // ── Continue button ──────────────────────────────────────────────────
          _BottomBar(
            step: _step,
            onContinue: () {
              // if (_step == 0) {
              //   setState(() {
              //     animate = true;
              //   });
              // }

              if (_step == 2) {
                if (_selectedService != null) {
                  Navigator.push(
                    context,
                    _slideRoute(
                      CheckoutScreen(
                        service: _selectedService!,
                        staff: _selectedStaff,
                        date:
                            _selectedDate ??
                            DateTime.now().add(const Duration(days: 1)),
                        time:
                            _selectedTime ??
                            const TimeOfDay(hour: 11, minute: 0),
                      ),
                    ),
                  );
                }
              } else {
                _next();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _SelectServiceStep(
          selected: _selectedService,
          onSelect: (s) => setState(() => _selectedService = s),
        );

      case 1:
        return _SelectDateTimeStep(
          selectedDate: _selectedDate,
          selectedTime: _selectedTime,
          onDate: (d) => setState(() => _selectedDate = d),
          onTime: (t) => setState(() => _selectedTime = t),
        );
      case 2:
        return _CheckoutPreviewStep(
          service: _selectedService,
          staff: _selectedStaff,
          date: _selectedDate,
          time: _selectedTime,
        );
      default:
        return const SizedBox();
    }
  }
}

// PageRouteBuilder _diagonalRoute(Widget page) => PageRouteBuilder(
//   pageBuilder: (_, a, __) => page,
//   transitionsBuilder: (_, a, __, child) {
//     final animation = Tween<Offset>(
//       begin: const Offset(-1, 1), // bottom-left
//       end: Offset.zero, // center
//     ).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic));

//     return SlideTransition(position: animation, child: child);
//   },
//   transitionDuration: const Duration(milliseconds: 800),
// );

// //-login mark--
// class LoginMark extends StatefulWidget {
//   const LoginMark({super.key});

//   @override
//   State<LoginMark> createState() => _LoginMarkState();
// }

// class _LoginMarkState extends State<LoginMark> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.bg,
//       body: Stack(
//         children: [
//           Positioned(
//             top: 20,
//             right: 20,
//             left: 410,

//             child: PressableScale(
//               onTap: () {
//                 Navigator.push(context, _slideRoute(LoginScreen()));
//               },
//               child: Container(
//                 height: 30,
//                 width: 40,
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [AppTheme.primary, AppTheme.primaryDark],
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppTheme.primary.withOpacity(0.4),
//                       blurRadius: 16,
//                       offset: const Offset(0, 6),
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Text(
//                     "Log in",
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w800,
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ─── Step Indicator ───────────────────────────────────────────────────────────
class _StepIndicator extends StatelessWidget {
  final int current;
  const _StepIndicator({required this.current});

  static const steps = [
    'Select\nService',
    // 'Select\nStaff',
    'Date &\nTime',
    'Checkout',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            // connector
            final passed = i ~/ 2 < current;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                height: 2,
                decoration: BoxDecoration(
                  gradient: passed
                      ? const LinearGradient(
                          colors: [AppTheme.primary, AppTheme.accent],
                        )
                      : null,
                  color: passed ? null : AppTheme.divider,
                ),
              ),
            );
          }
          final idx = i ~/ 2;
          final done = idx < current;
          final active = idx == current;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
                width: active ? 34 : 28,
                height: active ? 34 : 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: (done || active)
                      ? const LinearGradient(
                          colors: [AppTheme.primary, AppTheme.primaryDark],
                        )
                      : null,
                  color: (done || active) ? null : AppTheme.surface,
                  border: Border.all(
                    color: active ? AppTheme.primary : AppTheme.divider,
                    width: active ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: active
                          ? AppTheme.primary.withOpacity(0.35)
                          : Colors.transparent,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: done
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 14,
                        )
                      : Text(
                          '${idx + 1}',
                          style: TextStyle(
                            color: active ? Colors.white : AppTheme.textLight,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                steps[idx],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: active ? AppTheme.primary : AppTheme.textLight,
                  height: 1.2,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ─── Step 1: Select Service ───────────────────────────────────────────────────
class _SelectServiceStep extends StatelessWidget {
  final ServiceModel? selected;
  final ValueChanged<ServiceModel> onSelect;
  const _SelectServiceStep({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final services = Provider.of<ServiceProvider>(context).services;
    return Row(
      children: [
        // List
        Expanded(
          flex: 3,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: services.length,
            itemBuilder: (ctx, i) {
              final s = services[i];
              final isSelected = selected?.serviceId == s.serviceId;
              return FadeSlideIn(
                delay: Duration(milliseconds: 40 * i),
                child: GestureDetector(
                  onTap: () => onSelect(s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primary.withOpacity(0.06)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppTheme.primary : AppTheme.divider,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? AppTheme.primary
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primary
                                  : AppTheme.textLight,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 12,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.serviceName,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? AppTheme.primary
                                      : AppTheme.textDark,
                                ),
                              ),
                              Text(
                                '${s.durationMins} mins | ₹${s.price.toInt()}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.textLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Detail panel
        if (selected != null)
          Expanded(
            flex: 2,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0.1, 0),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: _ServiceDetail(
                key: ValueKey(selected!.serviceId),
                service: selected!,
              ),
            ),
          ),
      ],
    );
  }
}

class _ServiceDetail extends StatelessWidget {
  final ServiceModel service;
  const _ServiceDetail({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.divider),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 16)],
      ),
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryLight.withOpacity(0.5),
                  AppTheme.accentLight,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(service.emoji, style: const TextStyle(fontSize: 48)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.serviceName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  service.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMid,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: AppTheme.textLight,
                    ),
                    // const SizedBox(width: 2),
                    Text(
                      '${service.durationMins} mins',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textLight,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          // const Icon(
                          //   Icons .star_rounded,
                          //   size: 12,
                          //   color: AppTheme.primary,
                          // ),
                          // const SizedBox(width: 2),
                          Text(
                            '₹${service.price.toInt()}',
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Step 2: Select Staff ─────────────────────────────────────────────────────
// class _SelectStaffStep extends StatelessWidget {
//   final StaffModel? selected;
//   final ValueChanged<StaffModel> onSelect;
//   const _SelectStaffStep({required this.selected, required this.onSelect});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(20),
//       itemCount: allStaff.length,
//       itemBuilder: (ctx, i) {
//         final s = allStaff[i];
//         final isSelected = selected?.id == s.id;
//         return FadeSlideIn(
//           delay: Duration(milliseconds: 80 * i),
//           child: GestureDetector(
//             onTap: () => onSelect(s),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 250),
//               margin: const EdgeInsets.only(bottom: 14),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: isSelected
//                     ? AppTheme.primary.withOpacity(0.04)
//                     : Colors.white,
//                 borderRadius: BorderRadius.circular(18),
//                 border: Border.all(
//                   color: isSelected ? AppTheme.primary : AppTheme.divider,
//                   width: isSelected ? 2 : 1,
//                 ),
//                 boxShadow: isSelected
//                     ? [
//                         BoxShadow(
//                           color: AppTheme.primary.withOpacity(0.15),
//                           blurRadius: 16,
//                           offset: const Offset(0, 4),
//                         ),
//                       ]
//                     : [
//                         const BoxShadow(
//                           color: Color(0x06000000),
//                           blurRadius: 8,
//                         ),
//                       ],
//               ),
//               child: Row(
//                 children: [
//                   // Avatar
//                   AnimatedContainer(
//                     duration: const Duration(milliseconds: 250),
//                     width: 58,
//                     height: 58,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: isSelected
//                           ? const LinearGradient(
//                               colors: [
//                                 AppTheme.primaryLight,
//                                 AppTheme.accentLight,
//                               ],
//                             )
//                           : null,
//                       color: isSelected ? null : AppTheme.surface,
//                       border: Border.all(
//                         color: isSelected ? AppTheme.primary : AppTheme.divider,
//                         width: isSelected ? 2 : 1,
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         s.emoji,
//                         style: const TextStyle(fontSize: 28),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 14),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           s.name,
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w800,
//                             color: isSelected
//                                 ? AppTheme.primary
//                                 : AppTheme.textDark,
//                           ),
//                         ),
//                         const SizedBox(height: 3),
//                         Text(
//                           s.role,
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: AppTheme.textLight,
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         Row(
//                           children: [
//                             ...List.generate(
//                               5,
//                               (j) => Icon(
//                                 j < s.rating.round()
//                                     ? Icons.star_rounded
//                                     : Icons.star_outline_rounded,
//                                 size: 14,
//                                 color: AppTheme.accent,
//                               ),
//                             ),
//                             const SizedBox(width: 6),
//                             Text(
//                               '${s.rating} (${s.reviews} reviews)',
//                               style: const TextStyle(
//                                 fontSize: 11,
//                                 color: AppTheme.textLight,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   AnimatedContainer(
//                     duration: const Duration(milliseconds: 250),
//                     width: 24,
//                     height: 24,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: isSelected ? AppTheme.primary : Colors.transparent,
//                       border: Border.all(
//                         color: isSelected ? AppTheme.primary : AppTheme.divider,
//                         width: 2,
//                       ),
//                     ),
//                     child: isSelected
//                         ? const Icon(Icons.check, color: Colors.white, size: 13)
//                         : null,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// ─── Step 3: Date & Time ──────────────────────────────────────────────────────

class _SelectDateTimeStep extends StatefulWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final ValueChanged<DateTime> onDate;
  final ValueChanged<TimeOfDay> onTime;
  const _SelectDateTimeStep({
    required this.selectedDate,
    required this.selectedTime,
    required this.onDate,
    required this.onTime,
  });

  @override
  State<_SelectDateTimeStep> createState() => _SelectDateTimeStepState();
}

class _SelectDateTimeStepState extends State<_SelectDateTimeStep> {
  final List<TimeOfDay> _slots = [
    const TimeOfDay(hour: 9, minute: 0),
    const TimeOfDay(hour: 10, minute: 0),
    const TimeOfDay(hour: 11, minute: 0),
    const TimeOfDay(hour: 12, minute: 0),
    const TimeOfDay(hour: 14, minute: 0),
    const TimeOfDay(hour: 15, minute: 0),
    const TimeOfDay(hour: 16, minute: 0),
    const TimeOfDay(hour: 17, minute: 0),
  ];

  List<bool> _unavailable = [];

  List<BookingModel> bookings = [];

  final List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];
  int i = DateTime.now().month - 1;

  DateTime get _baseDate => DateTime.now().add(const Duration(days: 1));
  final ScrollController _scrollController = ScrollController();

  int _getMonthStartIndex(int month) {
    for (int i = 0; i < 300; i++) {
      final date = _baseDate.add(Duration(days: i));

      if (date.day == 1 && date.month == month) {
        return i;
      }
    }
    return 0;
  }

  void _scrollToIndex(int index) {
    final itemExtent = 66.0;

    _scrollController.animateTo(
      index * itemExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void updateUnavailableSlots(DateTime selectedDate) {
    _unavailable = List.filled(_slots.length, false);

    for (var booking in bookings) {
      final bookingDate = booking.bookingDateTime;

      bool sameDay =
          bookingDate.year == selectedDate.year &&
          bookingDate.month == selectedDate.month &&
          bookingDate.day == selectedDate.day;

      if (sameDay) {
        for (int i = 0; i < _slots.length; i++) {
          if (_slots[i].hour == bookingDate.hour &&
              _slots[i].minute == bookingDate.minute) {
            _unavailable[i] = true;
          }
        }
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {
  
    setState(() {});
  }



DateTime selectedDate = DateTime.now();
 
  void _showMonthYearPicker() {
  int tempMonth = selectedDate.month;
  int tempYear = selectedDate.year;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return SingleChildScrollView(

        child: StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
        
               
                  const Text(
                    "Select Month & Year",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
        
                  const SizedBox(height: 20),
        
                  /// Year Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
        
                      IconButton(
                        onPressed: () {
                          setModalState(() {
                            tempYear--;
                          });
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
        
                      Text(
                        "$tempYear",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
        
                      IconButton(
                        onPressed: () {
                          setModalState(() {
                            tempYear++;
                          });
                        },
                        icon: const Icon(Icons.arrow_forward_ios),
                      ),
        
                    ],
                  ),
        
                  const SizedBox(height: 20),
        
                  /// Month Grid
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: months.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
        
                      bool selected = tempMonth == index + 1;
        
                      return InkWell(
                        onTap: () {
                          setModalState(() {
                            tempMonth = index + 1;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selected
                                ? AppTheme.primaryDark
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.primaryDark,
                            ),
                          ),
                          child: Text(
                            months[index],
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : AppTheme.primaryDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
        
                  const SizedBox(height: 25),
        
                  ElevatedButton(
                    onPressed: () {
        
                      setState(() {
        
                        selectedDate = DateTime(
                          tempYear,
                          tempMonth,
                          1,
                        );
        
                        i = tempMonth - 1;
        
                      });
        
                      int index = _getMonthStartIndex(tempMonth);
        
                      _scrollToIndex(index);
        
                      Navigator.pop(context);
                    },
                    child: const Text("Done"),
                  ),
        
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Pick a Month & Date',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark,
                    fontFamily: 'Georgia',
                  ),
                ),
              ),

              Spacer(),
              SizedBox(
                width: 200,
                height: 30,
                // color: Colors.black,
                child: Row(
                  children: [
                            IconButton(
                      onPressed: () {
                         setState(() {

    selectedDate = DateTime(
      selectedDate.year,
      selectedDate.month - 1,
      1,
    );

    i = selectedDate.month + 1;

  });

  _scrollToIndex(_getMonthStartIndex(selectedDate.month));

                      },
                      icon: Icon(Icons.arrow_back_ios, size: 20),
                      color: AppTheme.primaryDark,
                    ),
                    GestureDetector(
  onTap: () {
    _showMonthYearPicker();
  },
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        "${months[selectedDate.month - 1]} ${selectedDate.year}",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(width: 5),
      const Icon(Icons.keyboard_arrow_down),
    ],
  ),
),
            
                 
                    IconButton(
                      onPressed: () {
                     
                      

  setState(() {

    selectedDate = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      1,
    );

    i = selectedDate.month - 1;

  });

  _scrollToIndex(_getMonthStartIndex(selectedDate.month));

                      },
                      icon: Icon(Icons.arrow_forward_ios, size: 20),
                      color: AppTheme.primaryDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          //SizedBox(height: 40, child: Container(color: Colors.black)),
          // Horizontal date selector
          SizedBox(
            height: 80,
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemCount: 365,
              itemBuilder: (ctx, i) {
                final date = _baseDate.add(Duration(days: i));
                final isSelected =
                    widget.selectedDate != null &&
                    widget.selectedDate!.day == date.day &&
                    widget.selectedDate!.month == date.month;
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                return GestureDetector(
                  onTap: () {
                    widget.onDate(date);
                    updateUnavailableSlots(date);
                    // Future.delayed(const Duration(milliseconds: 50), () {
                    //   _scrollToIndex(i);
                    // });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 56,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [AppTheme.primary, AppTheme.primaryDark],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )
                          : null,
                      color: isSelected ? null : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppTheme.primary : AppTheme.divider,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppTheme.primary.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          days[date.weekday - 1],
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected
                                ? Colors.white.withOpacity(0.8)
                                : AppTheme.textLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: isSelected
                                ? Colors.white
                                : AppTheme.textDark,
                          ),
                        ),
                        Text(
                          _monthName(date.month),
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected
                                ? Colors.white.withOpacity(0.7)
                                : AppTheme.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 28),
          const Text(
            'Pick a Time',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 14),
          if (widget.selectedDate == null)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  'Please select a date',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          else
            // Time slots grid
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount;
                if (constraints.maxWidth < 400) {
                  crossAxisCount = 2;
                } else if (constraints.maxWidth < 700) {
                  crossAxisCount = 3;
                } else {
                  crossAxisCount = 4;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2.2,
                  ),
                  itemCount: _slots.length,
                  itemBuilder: (ctx, i) {
                    final slot = _slots[i];
                    final isSelected =
                        widget.selectedTime?.hour == slot.hour &&
                        widget.selectedTime?.minute == slot.minute;
                    final unavail = _unavailable[i];
                    return GestureDetector(
                      onTap: unavail ? null : () => widget.onTime(slot),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? const LinearGradient(
                                  colors: [
                                    AppTheme.primary,
                                    AppTheme.primaryDark,
                                  ],
                                )
                              : null,
                          color: unavail
                              ? AppTheme.surface
                              : (isSelected ? null : Colors.white),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primary
                                : AppTheme.divider,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            slot.format(context),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: unavail
                                  ? AppTheme.textLight.withOpacity(0.4)
                                  : (isSelected
                                        ? Colors.white
                                        : AppTheme.textDark),
                              decoration: unavail
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              _LegendDot(color: AppTheme.primary, label: 'Available'),
              const SizedBox(width: 16),
              _LegendDot(color: AppTheme.divider, label: 'Unavailable'),
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.schedule),
            label: const Text('Choose Custom Time'),
            onPressed: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: widget.selectedTime ?? TimeOfDay.now(),
              );

              if (picked != null) {
                if (picked.hour < 9 || picked.hour > 17) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please select a time between 9 AM and 5 PM.',
                      ),
                    ),
                  );
                  return;
                } else {
                  widget.onTime(picked);
                }
              }
            },
          ),
          if (widget.selectedTime != null)
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primary),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: AppTheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Selected Time: ${widget.selectedTime!.format(context)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _monthName(int m) => [
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

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Text(
        label,
        style: const TextStyle(fontSize: 11, color: AppTheme.textLight),
      ),
    ],
  );
}

// ─── Step 4: Checkout Preview ─────────────────────────────────────────────────
class _CheckoutPreviewStep extends StatelessWidget {
  final ServiceModel? service;
  final String staff;
  final DateTime? date;
  final TimeOfDay? time;
  const _CheckoutPreviewStep({
    this.service,
    required this.staff,
    this.date,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    if (service == null) {
      return const Center(
        child: Text(
          'Please complete all steps.',
          style: TextStyle(color: AppTheme.textLight),
        ),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Summary card
          FadeSlideIn(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.divider),
                boxShadow: const [
                  BoxShadow(color: Color(0x08000000), blurRadius: 16),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            service!.emoji,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service!.serviceName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textDark,
                                fontFamily: 'Georgia',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${service!.durationMins} mins',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '₹${service!.price.toInt()}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const GoldDivider(),
                  const SizedBox(height: 16),
                  _SummaryRow(
                    icon: Icons.person_rounded,
                    label: 'Staff',
                    value: staff,
                  ),
                  const SizedBox(height: 10),
                  _SummaryRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Date',
                    value: date != null
                        ? '${date!.day} ${_month(date!.month)} ${date!.year}'
                        : '—',
                  ),
                  const SizedBox(height: 10),
                  _SummaryRow(
                    icon: Icons.access_time_rounded,
                    label: 'Time',
                    value: time?.format(context) ?? '—',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Price breakdown
          FadeSlideIn(
            delay: const Duration(milliseconds: 100),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF8F5), Color(0xFFFDF0EB)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Column(
                children: [
                  _PriceRow('Service Amount', '₹${service!.price.toInt()}'),
                  const SizedBox(height: 8),
                  _PriceRow('Discount', '- ₹50', color: Colors.green),
                  const SizedBox(height: 8),
                  _PriceRow(
                    'Tax (5%)',
                    '₹${(service!.price * 0.05).toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 12),
                  const GoldDivider(),
                  const SizedBox(height: 12),
                  _PriceRow(
                    'Total Amount',
                    '₹${(service!.price - 50 + service!.price * 0.05).toStringAsFixed(2)}',
                    bold: true,
                  ),
                ],
              ),
            ),
          ),
        ],
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

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 16, color: AppTheme.primary),
      const SizedBox(width: 10),
      Text(
        '$label:',
        style: const TextStyle(fontSize: 13, color: AppTheme.textLight),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
          textAlign: TextAlign.end,
        ),
      ),
    ],
  );
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool bold;
  const _PriceRow(this.label, this.value, {this.color, this.bold = false});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: bold ? 15 : 13,
          fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
          color: bold ? AppTheme.textDark : AppTheme.textMid,
          fontFamily: bold ? 'Georgia' : null,
        ),
      ),
      const Spacer(),
      Text(
        value,
        style: TextStyle(
          fontSize: bold ? 16 : 13,
          fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
          color: color ?? (bold ? AppTheme.primary : AppTheme.textDark),
        ),
      ),
    ],
  );
}

// ─── Bottom bar ───────────────────────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  final int step;
  final VoidCallback onContinue;
  const _BottomBar({required this.step, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        onTap: onContinue,
        
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primary, AppTheme.primaryDark],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                step == 3 ? 'Confirm Booking' : 'Continue',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 18,
              ),
            ],
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
