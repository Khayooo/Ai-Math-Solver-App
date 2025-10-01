
import 'package:ai_math_solver/OnBoarding%20Screens/onboarding_screen_1.dart';
import 'package:ai_math_solver/OnBoarding%20Screens/onboarding_screen_2.dart';
import 'package:ai_math_solver/OnBoarding%20Screens/onboarding_screen_3.dart';
import 'package:ai_math_solver/utils/app_strings.dart';
import 'package:ai_math_solver/utils/asset_paths.dart';
import 'package:ai_math_solver/utils/colors_paths.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;
  int counter = 0;

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
        child: Stack(
          children: [
            Positioned(
              top: 0.0,
              child: Container(
                height: size.height * 0.58,
                width: size.width,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length,
                  itemBuilder: (context, index) => pages[index],
                  onPageChanged: (value) {
                    setState(() {

                        currentPage = value;
                        counter++;



                    });
                  },
                ),
              ),
            ),

            Positioned(
              bottom: 0.0,
              child: Container(
                height: size.height * 0.4,
                width: size.width,
                child: Image.asset(
                  AssetPaths().onboarding_buttom,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
                bottom: 0.0,
                height: size.height * 0.35,
                width: size.width,
                child: Container(
                  child: Column(
                    children: [
                      if(currentPage == 0)
                      Text(AppStrings().power_tool, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),

                      if(currentPage == 1)
                        Text(AppStrings().scan_to_solve, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),

                      if(currentPage == 2)
                        Text(AppStrings().meet_your_math, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),

                      if (currentPage==0)
                        Text(AppStrings().quick_translation, style: TextStyle(fontSize: 14,)),
                      if (currentPage==1)
                        Text(AppStrings().take_a_photo, style: TextStyle(fontSize: 14,)),
                      if (currentPage==2)
                        Text(AppStrings().meet_your_math, style: TextStyle(fontSize: 14,)),

                    ],
                  ),

                )),



            Positioned(
                bottom: 0.0,
                height: size.height * 0.35,
                width: size.width,

                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      GestureDetector(onTap:(){
                        if (currentPage<pages.length){
                          _pageController.animateToPage(
                            currentPage - 1,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }else{
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => OnBoardingScreen()),
                          );
                        }
                      },
                      child:  Image.asset(height: 60,AssetPaths().back_button, )),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorsPaths().color_light_orange,
                        ),
                          child: Image.asset(height: 10,AssetPaths().middel_button)),


                      GestureDetector(onTap:(){
                        if (currentPage<pages.length){
                          _pageController.animateToPage(
                            currentPage + 1,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }else{
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => OnBoardingScreen()),
                          );
                        }
                      },
                          child: Image.asset(height: 60,AssetPaths().next_button))
                    ]
                )
            )
          ],
        ),
      ),
    );
  }
}
