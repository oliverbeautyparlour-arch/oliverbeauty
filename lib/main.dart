import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webui/frontend/home_screen.dart';
import 'frontend/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:webui/frontend/api.dart';


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
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: BeautyParlourApp(),
    ),
  );
}

class BeautyParlourApp extends StatefulWidget {
  const BeautyParlourApp({super.key});

  @override
  State<BeautyParlourApp> createState() => _BeautyParlourAppState();
}

class _BeautyParlourAppState extends State<BeautyParlourApp> {
   @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<AuthProvider>().loadUser();
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beauty Parlour',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: HomeScreen(),
    );
  }
}
