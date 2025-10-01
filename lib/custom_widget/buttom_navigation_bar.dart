import 'package:flutter/material.dart';

import '../utils/asset_paths.dart';

class BottomNavigationBarCustom extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex;

  const BottomNavigationBarCustom({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,

      decoration: BoxDecoration(

        image: DecorationImage(
          image: AssetImage(AssetPaths().buttom_navigation_bar),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          GestureDetector(child: Image.asset(AssetPaths().center_icon, height: 30,)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(child: Image.asset(AssetPaths().home_button,scale: 1.5,)),
                GestureDetector(child: Image.asset(AssetPaths().history_button,scale: 1.5,)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String asset, String label) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(asset, height: 30, color: isSelected ? Colors.blue : Colors.grey),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
