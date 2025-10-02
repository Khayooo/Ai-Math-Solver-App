import 'package:ai_math_solver/utils/colors_paths.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final String img;
  final String text;
  final Color color;
  final String forward_button;
  final Function? onPressed;

  const CustomCard({
    super.key,
    required this.img,
    required this.text,
    required this.color,
    required this.forward_button,
    required this.onPressed,
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [

          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: (){
              widget.onPressed!();
            },
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(widget.img, height: 80,width: 70,),
                Text(widget.text, style: TextStyle(color: ColorsPaths().white_color, fontSize: 13, fontWeight: FontWeight.w400),textAlign: TextAlign.center,),
                Padding(
                  padding: const EdgeInsets.only(left: 65),
                  child: Image.asset(widget.forward_button, height: 20,),
                ),
              ]
            )
          ),
        ],
      ),
    );
  }
}
