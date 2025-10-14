import 'package:flutter/material.dart';
import '../dashboard/dashboard.dart';
import '../history/history_screen.dart';
import '../utils/app_strings.dart';
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
    final screenWidth = MediaQuery.of(context).size;

    return Container(
      height: screenWidth.height * 0.16,
      child: Stack(
        children: [
          // ✅ Center Button
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: GestureDetector(
              onTap: () => onTap(2),
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(AssetPaths().center_icon),
                ),
              ),
            ),
          ),

          // ✅ Bottom Navigation Background
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AssetPaths().buttom_navigation_bar),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ✅ Home Button
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Dashboard()),
                        );
                      },
                      child: _buildNavItem(
                        0,
                        AssetPaths().home_button,
                        AppStrings().home,
                      ),
                    ),

                    // ✅ History Button (Now Works)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HistoryScreen()),
                        );
                      },
                      child: _buildNavItem(
                        1,
                        AssetPaths().history_button,
                        AppStrings().history,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Helper for each bottom item
  Widget _buildNavItem(int index, String asset, String label) {
    final isSelected = currentIndex == index;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          asset,
          height: 28,
          color: isSelected ? Colors.orange : Colors.grey,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.orange : Colors.grey,
          ),
        ),
      ],
    );
  }
}
