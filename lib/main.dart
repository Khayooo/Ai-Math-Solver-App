import 'package:ai_math_solver/result%20screen/result_screen.dart';
import 'package:ai_math_solver/scan%20screen/scan_screen.dart';
import 'package:ai_math_solver/splash/splash_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';



Future<void> main () async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
      home:  SplashScreen(),
      //   home:  ResultScreen(),
      // home: ScanScreen(),


    );
  }
}
