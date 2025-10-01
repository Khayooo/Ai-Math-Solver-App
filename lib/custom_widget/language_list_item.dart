import 'package:ai_math_solver/utils/asset_paths.dart';
import 'package:ai_math_solver/utils/colors_paths.dart';
import 'package:flutter/material.dart';

class LanguageListItem extends StatelessWidget {
  const LanguageListItem({
    super.key,
    required this.languages,
    required this.country,
    required this.selectedIndex,
    required this.index,
  });

  final String languages;
  final int selectedIndex;
  final int index;
  final country;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(height: 30, width: 30, country),
                    SizedBox(width: 10),
                    Text(languages , style: TextStyle(fontWeight: FontWeight.w400),),
                  ],
                ),
                Visibility(
                  visible: selectedIndex == index,
                  child: Image.asset(height: 20,width: 20,AssetPaths().radio_button),
                ),
              ],
            ),
          ),
          Divider(height: 8, color: ColorsPaths().divider_color),
        ],
      ),
    );
  }
}
