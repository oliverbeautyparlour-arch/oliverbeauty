import 'package:flutter/material.dart';
import 'package:webui/frontend/app_theme.dart';
import 'package:webui/frontend/models.dart';

class AdminDashboard extends StatefulWidget {
    final ServiceModel service; 

   AdminDashboard({super.key,
   
   required this.service,
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

  @override
void initState() {
  super.initState();

  serviceController =
      TextEditingController(text: widget.service.serviceName);

  durationController =
      TextEditingController(text: widget.service.durationMins.toString());

  priceController =
      TextEditingController(text: widget.service.price.toString());

  categoryController =
      TextEditingController(text: widget.service.category);

  descriptionController =
      TextEditingController(text: widget.service.description);
}
  @override
  Widget build(BuildContext context) {
    int _navIndex = 0;
    return Scaffold(
      backgroundColor: AppTheme.bg,

      appBar: AppBar(
        backgroundColor: AppTheme.primaryLight,
        title: Text(
          widget.service.serviceName,
          style: TextStyle(
            color: AppTheme.textDark,
            fontSize: 21,
           
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // body:
      // bottomNavigationBar: BottomNav(
      //         currentIndex: _navIndex,
      //         onTap: (i) => setState(() => _navIndex = i),
      //       ),,
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
                                color: AppTheme.primaryDark.withOpacity(0.2),
                                offset: Offset(2, 2),
                                blurRadius: 6,
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.2),
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
                                color: AppTheme.primaryDark.withOpacity(0.2),
                                offset: Offset(2, 2),
                                blurRadius: 6,
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.2),
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
                                color: AppTheme.primaryDark.withOpacity(0.2),
                                offset: Offset(2, 2),
                                blurRadius: 6,
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.2),
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
                                color: AppTheme.primaryDark.withOpacity(0.2),
                                offset: Offset(2, 2),
                                blurRadius: 6,
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.2),
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
                                color: AppTheme.primaryDark.withOpacity(0.2),
                                offset: Offset(2, 2),
                                blurRadius: 6,
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.2),
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
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 18,
                                color: AppTheme.primary,
                                // backgroundColor: AppTheme.bgCard,
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

            // SizedBox(height: 15),
            // Text(
            //   "Service Name",
            //   style: TextStyle(
            //     color: AppTheme.primaryLight,
            //     fontSize: 14,
            //   ),
            // ),
            // SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const BottomNav({required this.currentIndex, required this.onTap});

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
