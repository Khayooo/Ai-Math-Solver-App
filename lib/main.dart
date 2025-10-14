import 'package:ai_math_solver/splash/splash_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'history/history_screen.dart';



Future<void> main () async {
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
      // home: HistoryScreen(),
      //   home:  ResultScreen(),
      // home: ScanScreen(),


    );
  }
}
