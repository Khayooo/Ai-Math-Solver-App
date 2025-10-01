import 'package:ai_math_solver/utils/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/asset_paths.dart';
import 'onboarding_screen_2.dart';
import 'onboarding_screen_3.dart';

class OnboardingScreen1 extends StatefulWidget {
  const OnboardingScreen1({super.key});

  @override
  State<OnboardingScreen1> createState() => _OnboardingScreen1State();
}

class _OnboardingScreen1State extends State<OnboardingScreen1> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<Widget> pages =  [
    OnboardingScreen1(),
    OnboardingScreen2(),
    OnboardingScreen3(),
  ];


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
                  AssetPaths().onboarding_top,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
