import 'package:flutter/material.dart';
import 'package:webui/frontend/models.dart';
import 'app_theme.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'api.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with SingleTickerProviderStateMixin {
  String _selectedCategory = 'All Services';
  late AnimationController _ctrl;

  List img = [
    "assets/img1.jpeg",
    "assets/img2.jpeg",
    "assets/img3.jpeg",
    "assets/img4.jpeg",
    "assets/img5.jpeg",
    "assets/img6.jpeg",
    "assets/img7.jpeg",
    "assets/img8.jpeg",
    "assets/img9.jpeg",
    "assets/img10.jpeg",
    "assets/img11.jpeg",
    "assets/img12.jpeg",
  ];

  final categories = [
    'All Services',
    'Hair',
    'Skin',
    'Makeup',
    'Nails',
    'Bridal',
  ];
    List<ServiceModel> allServices = [];
  bool isLoading = true;

  List<ServiceModel> get filtered => _selectedCategory == 'All Services'
      ? allServices
      : allServices.where((s) => s.category == _selectedCategory).toList();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _ctrl.forward();
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

  int media() {
    double size = MediaQuery.of(context).size.width;
    if (size > 900) {
      return 3;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final services =
    context.read<ServiceProvider>().services;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
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
                  'Our Gallery',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark,
                    fontFamily: 'Georgia',
                  ),
                ),
                Text(
                  'Home / Gallery',
                  style: TextStyle(fontSize: 11, color: AppTheme.textLight),
                ),
              ],
            ),
          ),
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
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: media(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childCount: img.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),

                  child: Image.asset(img[index], fit: BoxFit.cover),
                  //),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
