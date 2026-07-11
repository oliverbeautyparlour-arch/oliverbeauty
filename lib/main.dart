import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webui/admin_panel/admin.dart';
import 'package:webui/admin_panel/admin_home.dart';
import 'package:webui/frontend/home_screen.dart';
//import 'package:webui/frontend/home_screen.dart';
import 'frontend/app_theme.dart';
import 'package:provider/provider.dart';

import 'package:webui/frontend/api.dart';
//import 'frontend/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServiceProvider()),

        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => TopServiceProvider()),
      ],
      child: BeautyParlourApp(),
    ),
  );
}

class BeautyParlourApp extends StatelessWidget {
  const BeautyParlourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beauty Parlour',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: AdminHome(),
    );
  }
}
