import 'package:flutter/material.dart';
import 'package:webui/admin_panel/admin_dashboard.dart';

import 'package:webui/frontend/app_theme.dart';
import 'package:webui/frontend/booking_screen.dart';
import 'package:webui/frontend/models.dart';

class LoginScreen extends StatefulWidget {
  bool islogin;
   LoginScreen({super.key,
  required this.islogin,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final TextEditingController emailcontroller =  TextEditingController();
final TextEditingController usernameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  Widget containerbox({required Text child}) {
    return Container(
      width: 53,
      height: 53,
      decoration: BoxDecoration(
        color: AppTheme.primaryLight,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryDark,

            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Center(child: child),
    );
  }

  
  List<Widget> circleside() {
    List<Widget> circles = [];
    double width = MediaQuery.of(context).size.width;

    if (width > 900) {
      for (var i = 0; i < 6; i++) {
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
        //fire design
        // circles.add(
        //   Positioned(
        //     top: top,
        //     right: 480,
        //     child: _decorCircle(60, AppTheme.bg),
        //   ),
        // );
        //   circles.add(
        //   Positioned(
        //     top: top -50,
        //                 left: 480,
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

  @override
  Widget build(BuildContext context) {
    // bool login = false;
    return Scaffold(
      backgroundColor: AppTheme.bg,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                widget.islogin?"Login in to Oliver":"Create Account",
               // "Sign-in To Oliver",
                style: TextStyle(
                  color: AppTheme.primaryDark,
                  fontSize: 21,
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Stack(
                children: [
                  ...circleside(),

                  Center(
                    child: Container(
                      width: 400,
                      height: MediaQuery.of(context).size.height / 1.2,
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 25,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 20),
                                      Text(
                                        "Sign in with",
                                        style: TextStyle(
                                          color: AppTheme.textDark,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "Or",
                                        style: TextStyle(
                                          color: AppTheme.primaryLight,
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          containerbox(
                                            child: Text(
                                              'G',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.primaryDark,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 13),
                                          containerbox(
                                            child: Text(
                                              'f',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.primaryDark,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 13),
                                          containerbox(
                                            child: Text(
                                              'X',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.primaryDark,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                    ],
                                  ),
                                ),

                                Text(
                                  "Username",

                                  style: TextStyle(
                                    color: AppTheme.primaryLight,
                                    fontSize: 14,
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
                                    controller: usernameController,

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
                                SizedBox(height: 15),
                                if(!widget.islogin)...[
Text(
                                  "Email Id",
                                  style: TextStyle(
                                    color: AppTheme.primaryLight,
                                    fontSize: 14,
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
                                    controller: emailcontroller,
                                    cursorColor: AppTheme.bg,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.phone_android_outlined,
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

                                ],
                                

                                SizedBox(height: 15),
                                Text(
                                  "Password",
                                  style: TextStyle(
                                    color: AppTheme.primaryLight,
                                    fontSize: 14,
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
                                    controller: passwordController,
                                    cursorColor: AppTheme.bg,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.phone_android_outlined,
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
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      widget.islogin?"Don't have an account":
                                      "Already have an account?",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.bg,
                                        // backgroundColor: AppTheme.bgCard,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    ElevatedButton(
                                      onPressed: () {
                                          setState(() {
         widget.islogin = !widget.islogin;
        });
                                      },
                                      child: Text(
                                       widget.islogin? "Sign up": "Login",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.bg,
                                          // backgroundColor: AppTheme.bgCard,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 25),
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.bgCard,
                                    ),
                                    onPressed: () {
                                      if (widget.islogin) {

    // LOGIN

    if (usernameController.text == "admin" &&
        passwordController.text == "12345") {

      Navigator.push(
        context,
        _slideRoute( AdminDashboard(
               service: ServiceModel(
              serviceId: "223",
              serviceName: "created one",
              category: "Hair",
              durationMins: 56,
              price: 5453,
              description: "this is from login page",
              emoji: "5",
       ),)),
      );

    } else {

      Navigator.push(
        context,
        _slideRoute(
          BookingScreen(islogin: true),
        ),
      );

    }

  } else {

    // SIGN UP

    // Save user to database here

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Account Created Successfully"),
      ),
    );

    setState(() {
      widget.islogin = true;
    });

  }
                                    },
                                    child: Text(
                                     widget.islogin?"Login in" :" Create Account",
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
