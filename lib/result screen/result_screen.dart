import 'package:ai_math_solver/utils/app_strings.dart';
import 'package:ai_math_solver/utils/asset_paths.dart';
import 'package:ai_math_solver/utils/colors_paths.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(AssetPaths().back_button, scale: 3.0),
        title: Text(
          "Result Screen ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          Image.asset(AssetPaths().result_screen_history_button, scale: 2.0),
          PopupMenuButton<String>(
            icon: Image.asset(AssetPaths().dotes_button, scale: 2.0),
            color: ColorsPaths().white_color,
            onSelected: (value) {
              if (value == "export") {

              }

              // for testing
              else if (value == "delete") {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Are you sure want to delete this chat",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                               textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Cancel Button
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side:  BorderSide(color: ColorsPaths().light_orange_color, ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: ColorsPaths().orange_color, fontSize: 16),
                                  ),
                                ),
                                // del vutton
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 17, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                  onPressed: () {
                                      // del logic

                                  },
                                  child: Container(

                                    decoration: BoxDecoration(
                                      gradient:  LinearGradient(
                                        transform: GradientRotation(0.20),
                                        colors: [ColorsPaths().light_orange_color,ColorsPaths().orange_color ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 17, vertical: 12),
                                    child: const Text(
                                      "Yes Delete",
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }



              // else if (value == "delete") {
              //   showDialog(),
              //
              // }
            },

            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                  
                  value: "export", child: Row(
                children: [
                   Image.asset(AssetPaths().export_button, scale: 2.0),
                  SizedBox(width: 10),
                  Text("Export"),
                ],
              )),
              PopupMenuItem<String>(value: "delete", child: Row(
                children: [
                  Image.asset(AssetPaths().delete_button, scale: 2.0),
                  SizedBox(width: 10),
                  Text("Delete" , style: TextStyle(color: ColorsPaths().red_color),),
                ],
              )),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
              height: 130,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: ColorsPaths().white_light_color,
            ),
          ),

          Container(
            height: 250,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: ColorsPaths().white_light_color,
            ),

            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings().short_answer,
                    style: TextStyle(fontSize: 15 , fontWeight: FontWeight.w500),
                  ),
                  Image.asset(
                    AssetPaths().result_screen_small_button,
                    scale: 2.0,
                  ),
                ],
              ),
            ),
          ),

          Stack(
            children: [
              Container(
                height: 300,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorsPaths().white_light_color,
                ),
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings().answer_in_detail,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                    Image.asset(
                      AssetPaths().result_screen_small_button,
                      scale: 2.0,
                    ),
                  ],
                ),
              ),
              // Positioned(
              //   bottom: 0.0,
              //   child: Container(
              //   margin: EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(12),
              //     color: ColorsPaths().white_light_color_less_opicty,
              // ),
              // ),
              // )
            ]
          ),
        ],
      ),
    );
  }
}
