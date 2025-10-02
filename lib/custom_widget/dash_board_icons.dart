import 'package:ai_math_solver/utils/colors_paths.dart';
import 'package:flutter/material.dart';

import '../utils/asset_paths.dart';

class DashBoardIcons extends StatefulWidget {
   DashBoardIcons({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    required this.onPressed,
  });
  final String icon;
  final String text;
  final Color color;
  Function() onPressed;

  @override
  State<DashBoardIcons> createState() => _DashBoardIconsState();
}

class _DashBoardIconsState extends State<DashBoardIcons> {

  @override

  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
        widget.onPressed();
      },
      child: Card(
        color: widget.color,
        
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        child: Padding(
          padding:  EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(widget.icon, height: screenHeight * 0.04,),
              SizedBox(height: 10,),
              Text(widget.text, style: TextStyle(color: ColorsPaths().text_color_dashbord, fontSize: 15, fontWeight: FontWeight.w400),textAlign: TextAlign.center,)
            ],
          ),
        ),
      ),
    );
  }
}
