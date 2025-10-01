import 'package:ai_math_solver/utils/colors_paths.dart';
import 'package:flutter/material.dart';

import '../utils/asset_paths.dart';

class CallingScreen extends StatefulWidget {
  const CallingScreen({super.key});

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(


      body: Stack(
        children: [
          Image.asset(AssetPaths().calline_img_background, height: size.height,width: size.width,fit: BoxFit.fill),
          Positioned(
            left: 0.0,
            right: 0.0,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 130,),
            Text('1:23' , style: TextStyle(color: ColorsPaths().white_color, fontSize: 20, fontWeight: FontWeight.bold),),
            SizedBox(height: 70,),
            Image.asset(AssetPaths().calling_person_img, height: 200,),
            SizedBox(height: 15,),
            SizedBox(
                width: size.width,
                child: Text('Jessica Alba', style: TextStyle(color: ColorsPaths().white_color, fontSize: 20, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,)),
            SizedBox(
                width: size.width,
                child: Text('is listening....', style: TextStyle(color: ColorsPaths().white_color, fontSize: 15, fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),
          ],


          ),

          ),
          Positioned(
              bottom: 100,
              left: 0.0,
              right: 0.0,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Image.asset(AssetPaths().mute_button, height: 50, ),
                          Image.asset(AssetPaths().loud_button, height: 50,),

                      ],
                    ),
                  ),
                  //calling
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        SizedBox(height: 10,),
                      Image.asset(AssetPaths().call_button, height: 50,),
                    ],
                  )

                ],
              ))

        ],
      ),

    );
  }
}
