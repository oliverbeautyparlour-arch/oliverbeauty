import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webui/frontend/api.dart';
import 'package:webui/frontend/app_theme.dart';
import 'package:webui/frontend/models.dart';
import 'package:webui/frontend/smart_image.dart'; // adjust path to wherever you saved SmartImage

class AdminDashboard extends StatefulWidget {
  final ServiceModel? service;

  const AdminDashboard({super.key, this.service});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late TextEditingController serviceController;
  late TextEditingController durationController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController imageController;

  bool _isSaving = false;

  static const List<String> _categories = [
    'Hair',
    'Skin',
    'Makeup',
    'Bridal',
    'Treatments',
  ];

  String? _selectedCategory;

  @override
  void initState() {
    super.initState();

    serviceController =
        TextEditingController(text: widget.service?.serviceName ?? "");

    durationController = TextEditingController(
        text: widget.service?.durationMins.toString() ?? "");

    priceController =
        TextEditingController(text: widget.service?.price.toString() ?? "");

    descriptionController =
        TextEditingController(text: widget.service?.description ?? "");

    imageController =
        TextEditingController(text: widget.service?.image ?? "");

    // Match existing category if editing, else leave unselected
    final existingCategory = widget.service?.category;
    _selectedCategory = _categories.contains(existingCategory)
        ? existingCategory
        : null;

    // Rebuild preview as the user types an image path/URL
    imageController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    serviceController.dispose();
    durationController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    imageController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final duration = int.tryParse(durationController.text.trim());
    final price = double.tryParse(priceController.text.trim());

    if (serviceController.text.trim().isEmpty ||
        _selectedCategory == null ||
        duration == null ||
        price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please fill all fields with valid values")),
      );
      return;
    }

    setState(() => _isSaving = true);

    final success = await ApiService().updateService(
      serviceId: widget.service!.serviceId,
      serviceName: serviceController.text.trim(),
      category: _selectedCategory!,
      durationMins: duration,
      price: price,
      description: descriptionController.text.trim(),
      image: imageController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      await context.read<ServiceProvider>().fetchServices();
      if (!mounted) return;
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update service. Try again.")),
      );
    }
  }

  Future<void> _addService() async {
    final duration = int.tryParse(durationController.text.trim());
    final price = double.tryParse(priceController.text.trim());

    if (serviceController.text.trim().isEmpty ||
        _selectedCategory == null ||
        descriptionController.text.trim().isEmpty ||
        duration == null ||
        price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields with valid values"),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final success = await ApiService().addService(
      serviceName: serviceController.text.trim(),
      category: _selectedCategory!,
      durationMins: duration,
      price: price,
      description: descriptionController.text.trim(),
      image: imageController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      await context.read<ServiceProvider>().fetchServices();
      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Service added successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to add service. Try again.")),
      );
    }
  }

  BoxDecoration _fieldBoxDecoration() => BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryDark.withValues(alpha: 0.2),
            offset: const Offset(2, 2),
            blurRadius: 6,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.2),
            offset: const Offset(-2, -2),
            blurRadius: 6,
          ),
        ],
      );

  Widget _fieldLabel(String text) => Text(
        text,
        style: TextStyle(color: AppTheme.bg, fontSize: 14),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryLight,
        title: Text(
          widget.service == null ? "Add Service" : "Edit Service",
          style: TextStyle(
            color: AppTheme.textDark,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height / 1.2,
                width: MediaQuery.of(context).size.width / 1.1,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        // ── Image preview ──────────────────────────────
                        _fieldLabel("Service Image"),
                        const SizedBox(height: 10),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: SmartImage(
                              imagePath: imageController.text.trim(),
                              width: 160,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // ── Image path / URL field ─────────────────────
                        Container(
                          width: double.infinity,
                          decoration: _fieldBoxDecoration(),
                          child: TextField(
                            controller: imageController,
                            cursorColor: AppTheme.bg,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "e.g. facial.webp or https://...",
                              hintStyle: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                              prefixIcon: Icon(
                                Icons.image_outlined,
                                color: AppTheme.primaryLight,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Enter an asset filename (must already be bundled in the app) or a full image URL.",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 11,
                          ),
                        ),

                        const SizedBox(height: 15),
                        _fieldLabel("Service Name"),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: _fieldBoxDecoration(),
                          child: TextField(
                            controller: serviceController,
                            cursorColor: AppTheme.bg,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: AppTheme.primaryLight,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),
                        _fieldLabel("Duration (mins)"),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: _fieldBoxDecoration(),
                          child: TextField(
                            controller: durationController,
                            keyboardType: TextInputType.number,
                            cursorColor: AppTheme.bg,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.timelapse,
                                color: AppTheme.primaryLight,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),
                        _fieldLabel("Price"),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: _fieldBoxDecoration(),
                          child: TextField(
                            controller: priceController,
                            keyboardType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                            cursorColor: AppTheme.bg,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.price_change_outlined,
                                color: AppTheme.primaryLight,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),
                        _fieldLabel("Category"),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: _fieldBoxDecoration(),
                          child: DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            dropdownColor: AppTheme.primaryDark,
                            style: const TextStyle(color: Colors.white),
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppTheme.primaryLight,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.category,
                                color: AppTheme.primaryLight,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                            hint: Text(
                              "Select category",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                            items: _categories
                                .map(
                                  (cat) => DropdownMenuItem(
                                    value: cat,
                                    child: Text(cat),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() => _selectedCategory = value);
                            },
                          ),
                        ),

                        const SizedBox(height: 15),
                        _fieldLabel("Description"),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: _fieldBoxDecoration(),
                          child: TextField(
                            minLines: 3,
                            maxLines: 5,
                            controller: descriptionController,
                            cursorColor: AppTheme.bg,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.description,
                                color: AppTheme.primaryLight,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.bgCard,
                            ),
                            onPressed: _isSaving
                                ? null
                                : () {
                                    if (widget.service == null) {
                                      _addService();
                                    } else {
                                      _saveChanges();
                                    }
                                  },
                            child: _isSaving
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppTheme.primary,
                                    ),
                                  )
                                : Text(
                                    "Save",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const BottomNav(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.spa_rounded, 'label': 'Services'},
      {'icon': Icons.gamepad_outlined, 'label': 'Gallery'},
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