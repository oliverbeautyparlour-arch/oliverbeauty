import 'dart:ui';

import 'package:flutter/material.dart';
import 'theme.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            //SizedBox(height: 100), //image
            // AssetImage("assets/beautytools.png"),
            //  Image.asset("assets/beautytools2.png"),
            // Text(
            //   "Welcome to Ispy",
            //   style: TextStyle(
            //     color: AppColors.textDark,
            //     fontWeight: FontWeight.bold,
            //     fontSize: 21,
            //   ),
            // ),
            Container(
              height: 160,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                //  image:Image.asset("assets/beautytools2.png"),
                image: DecorationImage(
                  image: AssetImage("assets/beautytools2.png"),
                ),
              ),
              child: Row(
                //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //logo
                  Container(
                    height: 120,
                    width: 150,
                    padding: EdgeInsets.all(10),

                    color: Colors.transparent,

                    child: FittedBox(
                      fit: BoxFit.scaleDown,

                      child: Text(
                        "LOGO",
                        style: TextStyle(fontSize: 30, color: Colors.black),
                      ),
                    ),
                  ),

                  Container(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Color.from(
                          alpha: 40,
                          red: 255,
                          green: 255,
                          blue: 255,
                        ),
                        child: Text("hey"),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Login",

                      style: TextStyle(
                        color: AppColors.button,
                        // backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Sign up",

                      style: TextStyle(
                        color: AppColors.button,
                        // backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
