import 'package:flutter/material.dart';
import 'package:webui/admin_panel/admin_dashboard.dart';

import 'package:webui/frontend/app_theme.dart';
import 'package:webui/frontend/booking_screen.dart';
import 'package:webui/frontend/services_screen.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  // @override
  // Widget ContainerBox({required child}) {
  //   return Container(
  //     width: 53,
  //     height: 53,
  //     decoration: BoxDecoration(
  //       color: AppTheme.primaryLight,
  //       borderRadius: BorderRadius.circular(14),
  //       boxShadow: [
  //         BoxShadow(
  //           color: AppTheme.primaryDark,

  //           blurRadius: 8,
  //           offset: const Offset(2, 4),
  //         ),
  //       ],
  //     ),
  //     child: Center(child: child),
  //   );
  // }

  List<Widget> circleside() {
    List<Widget> circles = [];
    double width = MediaQuery.of(context).size.width;

    if (width > 900) {
      for (var i = 0; i < 5; i++) {
        double top;

        if (i == 0) {
          top = -10;
        } else {
          top = i * 100;
        }

        circles.add(
          Positioned(
            top: top,
            right: 480,
            child: _decorCircle(120, AppTheme.primaryDark),
          ),
        );
        // fire design
        // circles.add(
        //   Positioned(
        //     top: top,
        //     right: 480,
        //     child: _decorCircle(60, AppTheme.bg),
        //   ),
        // );

        circles.add(
          Positioned(
            top: top,
            left: 480,
            child: _decorCircle(120, AppTheme.primary),
          ),
        );
      }
    }

    return circles;
  }

  bool showtext = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 50),
              Text(
                "Admin Panel",
                style: TextStyle(
                  color: AppTheme.primaryDark,
                  fontSize: 21,
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Stack(
                children: [
                  ...circleside(),

                  Center(
                    child: Container(
                      width: 400,
                      height: MediaQuery.of(context).size.height / 1.4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                          colors: [AppTheme.primary, AppTheme.primaryDark],
                        ),

                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20),
                                Center(
                                  child: Text(
                                    "Log in",
                                    style: TextStyle(
                                      color: AppTheme.textDark,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Username",
                                  style: TextStyle(
                                    color: AppTheme.primaryLight,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 10),

                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primaryDark.withOpacity(
                                          0.2,
                                        ),
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
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                                Text(
                                  "Password",
                                  style: TextStyle(
                                    color: AppTheme.primaryLight,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 10),

                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primaryDark.withOpacity(
                                          0.2,
                                        ),
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
                                    cursorColor: AppTheme.bg,
                                    obscureText: showtext,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.password,
                                        color: AppTheme.primaryLight,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            showtext = !showtext;
                                          });
                                        },
                                        icon: Icon(
                                          showtext
                                              ? Icons.visibility_off_outlined
                                              : Icons.remove_red_eye_outlined,
                                        ),
                                        color: AppTheme.primaryLight,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40),
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.bgCard,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        _slideRoute(ServicesScreen(isadmin: true,)),
                                      );
                                    },
                                    child: Text(
                                      "Log In",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.primary,
                                        // backgroundColor: AppTheme.bgCard,
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

Widget _decorCircle(double size, Color color) => Container(
  width: size,
  height: size,
  decoration: BoxDecoration(shape: BoxShape.circle, color: color),
);
