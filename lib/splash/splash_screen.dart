import 'package:ai_math_solver/utils/asset_paths.dart';
import 'package:flutter/material.dart';

import '../language screen/language_screen.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LanguageScreen()),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(AssetPaths().splash_logo),
              width: 300,
              height: 300,
            ),


            Text('AI Math Solver', style: TextStyle(fontWeight: FontWeight.bold),),

            Text('Conquer any math problem with the power of AI', style: TextStyle())
          ],

        ),
      ),

    );
  }
}



