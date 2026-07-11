import 'package:flutter/material.dart';
import 'package:webui/frontend/booking_screen.dart';
import 'package:webui/frontend/gallery_screen.dart';
import 'package:carousel_slider/carousel_slider.dart  ';
import 'profile_screen.dart';
import 'bookings_screen.dart';
import 'app_theme.dart';
import 'models.dart';
import 'common_widgets.dart';
import 'services_screen.dart';
import 'api.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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
      _HomeContent(
        heroFade: _heroFade,
        heroSlide: _heroSlide,
        services: services,
      ),
      const ServicesScreen(isadmin: false,),
      const GalleryScreen(),
      const BookingScreen(islogin: false),
      const BookingsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: IndexedStack(index: _navIndex, children: pages),
      bottomNavigationBar: _BottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final Animation<double> heroFade;
  final Animation<Offset> heroSlide;
  final List<ServiceModel> services;
  const _HomeContent({
    required this.heroFade,
    required this.heroSlide,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ── Top bar ──────────────────────────────────────────────────────────
        SliverAppBar(
          pinned: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              Container(
                width: 54,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: ClipOval(
                  child: Image.asset('assets/Logoround.jpg', fit: BoxFit.cover),
                ),
              ),

              const SizedBox(width: 20),
              const Text(
                'Oliver',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.green,
                  letterSpacing: 2.7,
                  fontFamily: 'serif',
                ),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              // ── Hero ──────────────────────────────────────────────────────
              _HeroSection(fade: heroFade, slide: heroSlide),
              const SizedBox(height: 32),

              // ── Categories ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FadeSlideIn(
                  delay: const Duration(milliseconds: 200),
                  child: const SectionTitle(title: 'Our Services'),
                ),
              ),
              const SizedBox(height: 16),
              _CategoriesRow(),
              const SizedBox(height: 32),

              // ── Popular Services ────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FadeSlideIn(
                  delay: const Duration(milliseconds: 300),
                  child: SectionTitle(
                    title: 'Popular Services',
                    action: 'View All',
                    onAction: () {},
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Consumer<TopServiceProvider>(
  builder: (context, provider, child) {
    return _PopularServicesRow(
      services: provider.topServices,
    );
  },
),
              const SizedBox(height: 32),

              // ── Promo banner ────────────────────────────────────────────
              FadeSlideIn(
                delay: const Duration(milliseconds: 400),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _PromoBanner(),
                ),
              ),
              const SizedBox(height: 32),

              // ── Why Choose Us ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FadeSlideIn(
                  delay: const Duration(milliseconds: 500),
                  child: const SectionTitle(title: 'Why Choose Us'),
                ),
              ),
              const SizedBox(height: 16),
              _WhyChooseUs(),
              const SizedBox(height: 32),

              // ── Testimonials ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FadeSlideIn(
                  delay: const Duration(milliseconds: 600),
                  child: const SectionTitle(title: 'What Our Clients Say'),
                ),
              ),
              const SizedBox(height: 16),
              _TestimonialsRow(),
              const SizedBox(height: 32),
              // ── Footer ──────────────────────────────────────────────────
              _Footer(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Hero Section ─────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  final Animation<double> fade;
  final Animation<Offset> slide;
  _HeroSection({required this.fade, required this.slide});

  final images = [
    //Image.asset("assets/nails2.avif"),
    Image.asset("assets/bride5.jpg"),
    //Image.asset("assets/bride4.jpg"),Image.asset("assets/facial2.webp"),
    Image.asset("assets/hair.jpg"),
    Image.asset("assets/nails.jpg"),

    Image.asset("assets/bride2.jpeg"),
    Image.asset("assets/facial.webp"),
  ];
  int currentindex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFF8B4A43), Color(0xFFB5736A), Color(0xFFD4AF7A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.35),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),

          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              autoPlayCurve: Curves.easeInOut,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              aspectRatio: 3,
              // onPageChanged: (index, reason){

              // },
            ),
            items: images,
          ),
        ),
        Positioned(
          top: -30,
          right: -20,
          child: _decorCircle(120, Colors.white.withOpacity(0.07)),
        ),
        Positioned(
          bottom: -40,
          right: 40,
          child: _decorCircle(160, Colors.white.withOpacity(0.05)),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: _decorCircle(60, Colors.white.withOpacity(0.1)),
        ),

        Positioned(
          bottom: -40,
          left: 190,
          child: _decorCircle(160, Colors.white.withOpacity(0.1)),
        ),
        Positioned(
          top: -20,
          left: -20,
          child: _decorCircle(160, Colors.white.withOpacity(0.1)),
        ),
        Padding(
          padding: const EdgeInsets.all(28),
          child: FadeTransition(
            opacity: fade,
            child: SlideTransition(
              position: slide,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Enhance Your Beauty',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Georgia',
                      height: 1.2,
                    ),
                  ),
                  const Text(
                    'Enhance Your Confidence',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Georgia',
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Experience premium beauty services\nfrom our professional experts.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      PressableScale(
                        onTap: () {
                          Navigator.push(
                            context,
                            _slideRoute(BookingScreen(islogin: false)),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Text(
                            'Book Appointment',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      PressableScale(
                        onTap: () {
                          Navigator.push(
                            context,
                            _slideRoute(ServicesScreen(isadmin:  false,)),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Text(
                            'Explore Services',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _decorCircle(double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}

// ─── Categories Row ───────────────────────────────────────────────────────────
class _CategoriesRow extends StatelessWidget {
  final categories = const [
    {'icon': '✂️', 'label': 'Hair', 'count': '12'},
    {'icon': '✨', 'label': 'Skin', 'count': '10'},
    {'icon': '💄', 'label': 'Makeup', 'count': '8'},
    {'icon': '💅', 'label': 'Nails', 'count': '6'},
    {'icon': '👰', 'label': 'Bridal', 'count': '5'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        separatorBuilder: (_, __) => const SizedBox(width: 40),
        itemCount: categories.length,
        itemBuilder: (ctx, i) {
          return FadeSlideIn(
            delay: Duration(milliseconds: 100 * i),
            child: PressableScale(
              onTap: () {
                Navigator.push(
                  context,
                  _slideRoute(
                    ServicesScreen(selectedCategory: categories[i]['label']!, isadmin: false,),
                  ),
                );
              },
              child: Container(
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.divider),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x08000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      categories[i]['icon']!,
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      categories[i]['label']!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    Text(
                      '${categories[i]['count']} Services',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppTheme.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Popular Services ─────────────────────────────────────────────────────────
class _PopularServicesRow extends StatelessWidget {
  final List<ServiceModel> services;
  const _PopularServicesRow({super.key, required this.services});
  @override
  Widget build(BuildContext context) {
 final popular = services;

    if (services.isEmpty) {
  return const SizedBox(
    height: 230,
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}
   
    return SizedBox(
      height: 230,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        separatorBuilder: (_, __) => const SizedBox(width: 40),
        itemCount: popular.length,
        itemBuilder: (ctx, i) => FadeSlideIn(
          delay: Duration(milliseconds: 100 * i),
          child: SizedBox(
            width: 165,
            child: ServiceCard(
              name: popular[i].serviceName,
              duration: '${popular[i].durationMins} mins',
              price: '₹${popular[i].price.toInt()}',
              emoji: popular[i].emoji,
              ishomescreen: true,
              isadmin: false,
              size: MediaQuery.of(context).size.width,
              onBook: () => Navigator.push(
                context,
                _slideRoute(BookingScreen(islogin: false)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Promo Banner ─────────────────────────────────────────────────────────────
class _PromoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF8F0), Color(0xFFF9E8D4)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accent.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text('💍', style: TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Special Offer',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.accent,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const Text(
                  '30% OFF on\nBridal Packages',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark,
                    fontFamily: 'Georgia',
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                PressableScale(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.accent, Color(0xFFBF8A40)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'View Offers',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Why Choose Us ────────────────────────────────────────────────────────────
class _WhyChooseUs extends StatelessWidget {
  final items = const [
    {
      'icon': '👩‍🔬',
      'title': 'Professional Staff',
      'sub': 'Trained & certified beauty experts',
    },
    {
      'icon': '🧴',
      'title': 'Hygienic Tools',
      'sub': 'High standards of cleanliness',
    },
    {
      'icon': '🌿',
      'title': 'Quality Products',
      'sub': 'We use premium quality products',
    },
    {
      'icon': '💰',
      'title': 'Affordable Pricing',
      'sub': 'Best services at reasonable prices',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.8,
        ),
        itemCount: items.length,
        itemBuilder: (ctx, i) => FadeSlideIn(
          delay: Duration(milliseconds: 100 * i),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.divider),
            ),
            child: Row(
              children: [
                Text(items[i]['icon']!, style: TextStyle(fontSize: 26)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        items[i]['title']!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        items[i]['sub']!,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.textLight,
                          height: 1.3,
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
    );
  }
}

// ─── Testimonials ─────────────────────────────────────────────────────────────
class _TestimonialsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemCount: testimonials.length,
        itemBuilder: (ctx, i) => FadeSlideIn(
          delay: Duration(milliseconds: 100 * i),
          child: Container(
            width: 240,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.divider),
              boxShadow: const [
                BoxShadow(color: Color(0x08000000), blurRadius: 12),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppTheme.primaryLight,
                      child: Text(
                        testimonials[i]['name']![0],
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      testimonials[i]['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const Spacer(),
                    ...List.generate(
                      5,
                      (_) => const Text('⭐', style: TextStyle(fontSize: 10)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const GoldDivider(),
                const SizedBox(height: 10),
                Text(
                  testimonials[i]['text']!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMid,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
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

// ─── Footer ──────────────────────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2C1810), Color(0xFF4A2820)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About Us',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Georgia',
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We provide the best beauty services to make you look beautiful and feel confident.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '123 Beauty Street,\nCoimbatore, Tamil Nadu',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+91 98765 43210',
                      style: TextStyle(
                        color: AppTheme.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const GoldDivider(),
          const SizedBox(height: 12),
          Text(
            '© 2024 Beauty Parlour. All Rights Reserved.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom Navigation ────────────────────────────────────────────────────────
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
      {'icon': Icons.calendar_month_rounded, 'label': 'Book'},
      {'icon': Icons.receipt_long_rounded, 'label': 'Bookings'},
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

// Route helper
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
