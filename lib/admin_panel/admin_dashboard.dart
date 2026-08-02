import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webui/frontend/api.dart';
import 'package:webui/frontend/app_theme.dart';
import 'package:webui/frontend/models.dart';

class AdminDashboard extends StatefulWidget {
    final ServiceModel? service; 

   const AdminDashboard({super.key,
   
    this.service,
   });
   

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();

}

class _AdminDashboardState extends State<AdminDashboard> {
late TextEditingController serviceController;
late TextEditingController durationController;
late TextEditingController priceController;
late TextEditingController categoryController;
late TextEditingController descriptionController;
  bool _isSaving = false;

  @override
void initState() {
  super.initState();

  serviceController =
      TextEditingController(text: widget.service?.serviceName ?? "");

  durationController =
      TextEditingController(text: widget.service?.durationMins.toString() ?? "");

  priceController =
      TextEditingController(text: widget.service?.price.toString()?? "");

  categoryController =
      TextEditingController(text: widget.service?.category ?? "");

  descriptionController =
      TextEditingController(text: widget.service?.description ?? "");
}
@override
  void dispose() {
    serviceController.dispose();
    durationController.dispose();
    priceController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
  Future<void> _saveChanges() async {
    final duration = int.tryParse(durationController.text.trim());
    final price = double.tryParse(priceController.text.trim());

    if (serviceController.text.trim().isEmpty ||
        categoryController.text.trim().isEmpty ||
        duration == null ||
        price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields with valid values")),
      );
      return;
    }

    setState(() => _isSaving = true);

    final success = await ApiService().updateService(
      serviceId: widget.service!.serviceId,
      serviceName: serviceController.text.trim(),
      category: categoryController.text.trim(),
      durationMins: duration,
      price: price,
      description: descriptionController.text.trim(),
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
      categoryController.text.trim().isEmpty ||
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
    category: categoryController.text.trim(),
    durationMins: duration,
    price: price,
    description: descriptionController.text.trim(),
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
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: AppTheme.bg,

      appBar: AppBar(
        backgroundColor: AppTheme.primaryLight,
        title: Text(
        
  widget.service == null
      ? "Add Service"
      : "Edit Service",

          style: TextStyle(
            color: AppTheme.textDark,
            fontSize: 21,
           
            fontWeight: FontWeight.bold,
          ),
        ),
      ),


      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height/1.2 ,
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
                        SizedBox(height: 10),
                        Text(
                          "Service Name",
                          style: TextStyle(color: AppTheme.bg, fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryDark.withValues(alpha: 0.2),
                                offset: Offset(2, 2),
                                blurRadius: 6,
                              ),
                              BoxShadow(
                                color: Colors.white.withValues(alpha:0.2),
                                offset: Offset(-2, -2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: serviceController,
                            cursorColor: AppTheme.bg,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: AppTheme.primaryLight,
                              ),
                                    
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Duration",
                          style: TextStyle(color: AppTheme.bg, fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryDark.withValues(alpha:0.2),
                                offset: Offset(2, 2),
                                blurRadius: 6,
                              ),
                              BoxShadow(
                                color: Colors.white.withValues(alpha:0.2),
                                offset: Offset(-2, -2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: durationController,
                            cursorColor: AppTheme.bg,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.timelapse,
                                color: AppTheme.primaryLight,
                              ),
                                    
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Price ",
                          style: TextStyle(color: AppTheme.bg, fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryDark.withValues(alpha: 0.2),
                                offset: Offset(2, 2),
                                blurRadius: 6,
                              ),
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.2),
                                offset: Offset(-2, -2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: priceController,
                            cursorColor: AppTheme.bg,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.price_change_outlined,
                                color: AppTheme.primaryLight,
                              ),
                                    
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Category",
                          style: TextStyle(color: AppTheme.bg, fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryDark.withValues(alpha:0.2),
                                offset: Offset(2, 2),
                                blurRadius: 6,
                              ),
                              BoxShadow(
                                color: Colors.white.withValues(alpha:0.2),
                                offset: Offset(-2, -2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: categoryController,
                            cursorColor: AppTheme.bg,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.category,
                                color: AppTheme.primaryLight,
                              ),
                                    
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Description",
                          style: TextStyle(color: AppTheme.bg, fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Container(
                        
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryDark.withValues(alpha:0.2),
                                offset: Offset(2, 2),
                                blurRadius: 6,
                              ),
                              BoxShadow(
                                color: Colors.white.withValues(alpha:0.2),
                                offset: Offset(-2, -2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: TextField(
                           minLines: 3,
                                      maxLines: 5,
                            controller: descriptionController,
                            cursorColor: AppTheme.bg,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                            
                              prefixIcon: Icon(
                                Icons.description,
                                color: AppTheme.primaryLight,
                              ),
                                    
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                                    
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
  const BottomNav({super.key,required this.currentIndex, required this.onTap});

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
