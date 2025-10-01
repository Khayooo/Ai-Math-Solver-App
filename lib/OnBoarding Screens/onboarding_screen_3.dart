import 'package:flutter/material.dart';

import '../utils/app_strings.dart';
import '../utils/asset_paths.dart';

class OnboardingScreen3 extends StatefulWidget {
  const OnboardingScreen3({super.key});

  @override
  State<OnboardingScreen3> createState() => _OnboardingScreen3State();
}

class _OnboardingScreen3State extends State<OnboardingScreen3> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: size.height * 0.58,
              width: size.width,
              child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Image.asset(
                  AssetPaths().on_boarding_3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
