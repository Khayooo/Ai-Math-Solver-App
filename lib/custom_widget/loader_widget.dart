import 'package:ai_math_solver/utils/colors_paths.dart';
import 'package:flutter/material.dart';

import '../utils/app_strings.dart';

class LoaderWidget extends StatefulWidget {
  var isLoading;

  LoaderWidget({super.key, required this.isLoading});

  @override
  State<LoaderWidget> createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<LoaderWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Visibility(
      visible: widget.isLoading,
      child: Container(
        width: size.width,
        height: size.height,
        color: ColorsPaths().whiteOpacityColor,
        child: Center(
          child: Card(
            color: ColorsPaths().white_color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppStrings().ai_is_solving_your_problem,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings().please_wait,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
