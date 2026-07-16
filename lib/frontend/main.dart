import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './home_screen.dart';
import './app_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './api.dart';


Future<void> main()  async{
  WidgetsFlutterBinding.ensureInitialized();

   await dotenv.load(fileName: ".env");
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

  final apiUrl = dotenv.env['API_URL'];

final razorpayKey = dotenv.env['RAZORPAY_KEY'];
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
