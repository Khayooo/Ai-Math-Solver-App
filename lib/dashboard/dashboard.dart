import 'dart:io';
import 'package:ai_math_solver/call%20screen/calling_screen.dart';
import 'package:ai_math_solver/custom_widget/custom_card.dart';
import 'package:ai_math_solver/model/dash_board_icons.dart';
import 'package:ai_math_solver/utils/colors_paths.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../custom_widget/buttom_navigation_bar.dart';
import '../custom_widget/dash_board_icons.dart';
import '../scan screen/scan_screen.dart';
import '../utils/app_strings.dart';
import '../utils/asset_paths.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  int currentIndex = 0;
  // File? _image;
  // final  _picker = ImagePicker();
  // pickImageFromCamera() async {
  //   final  pickedImage = await _picker.pickImage(source: ImageSource.camera);
  //   if(pickedImage != null) {
  //     _image = File(pickedImage.path);
  //     setState(() {
  //       _image;
  //     });
  //   }
  // }

  List<DashBoardIconsModel> dashboardMenuList = [
    DashBoardIconsModel(
      icon: AssetPaths().bot_img,
      text: AppStrings().learn_assistent,
      color: ColorsPaths().dashbord_item_1,
      action: "Learning Assistant",
    ),
    DashBoardIconsModel(
      icon: AssetPaths().content_generator_img,
      text: AppStrings().content_generation,
      color: ColorsPaths().dashbord_item_2,
      action: "Content Generation",
    ),
    DashBoardIconsModel(
      icon: AssetPaths().language_img,
      text: AppStrings().language,
      color: ColorsPaths().dashbord_item_3,
      action: "Language",
    ),
    DashBoardIconsModel(
      icon: AssetPaths().easy_helper_img,
      text: AppStrings().easy_helper,
      color: ColorsPaths().dashbord_item_4,
      action: "Easy Helper",
    ),
    DashBoardIconsModel(
      icon: AssetPaths().physics_img,
      text: AppStrings().physics,
      color: ColorsPaths().dashbord_item_5,
      action: "Physics",
    ),
    DashBoardIconsModel(
      icon: AssetPaths().chemistry_img,
      text: AppStrings().chemistry,
      color: ColorsPaths().dashbord_item_6,
      action: "Chemistry",
    ),
    DashBoardIconsModel(
      icon: AssetPaths().biology_img,
      text: AppStrings().biology,
      color: ColorsPaths().dashbord_item_7,
      action: "Biology",
    ),
    DashBoardIconsModel(
      icon: AssetPaths().math_img,
      text: AppStrings().math,
      color: ColorsPaths().dashbord_item_8,
      action: "Math",
    ),
    DashBoardIconsModel(
      icon: AssetPaths().english_img,
      text: AppStrings().english,
      color: ColorsPaths().dashbord_item_9,
      action: "English",
    ),
    DashBoardIconsModel(
      icon: AssetPaths().geography_img,
      text: AppStrings().geography,
      color: ColorsPaths().dashbord_item_10,
      action: "Geography",
    ),
    DashBoardIconsModel(
      icon: AssetPaths().summarise_img,
      text: AppStrings().summarise,
      color: ColorsPaths().dashbord_item_11,
      action: "Summaries",
    ),
    DashBoardIconsModel(
      icon: AssetPaths().story_img,
      text: AppStrings().story,
      color: ColorsPaths().dashbord_item_12,
      action: "Stories",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(AssetPaths().img_background, fit: BoxFit.fill),
              Positioned(
                top: 60,
                left: 10,
                right: 0.0,
                bottom: 0.0,
                child: Container(
                  height: 390,
                  width: size.width,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings().ask_ai_anything,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsPaths().white_color,
                                ),
                              ),
                              Text(
                                AppStrings().let_solve,
                                style: TextStyle(
                                  color: ColorsPaths().white_color,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Image.asset(
                              AssetPaths().setting_button,
                              height: 30,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomCard(
                              color: ColorsPaths().card_color,
                              img: AssetPaths().female_dummy,
                              text: AppStrings().text_chat,
                              forward_button: AssetPaths().forward_button,
                              onPressed: () {},
                            ),
                            CustomCard(
                              color: ColorsPaths().card_color,
                              img: AssetPaths().dummy_img_2,
                              text: AppStrings().voice_chat,
                              forward_button: AssetPaths().forward_button,
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return const CallingScreen();
                                }));
                              },
                            ),

                            //main
                            CustomCard(
                              color: ColorsPaths().card_color,
                              img: AssetPaths().dummy_img_3,
                              text: AppStrings().upload_image,
                              forward_button: AssetPaths().forward_button,



                              onPressed: () async {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return const ScanScreen();
                                }));

                                // await pickImageFromCamera();
                                //
                                // final picker = ImagePicker();
                                // final image = await picker.pickImage(
                                //     source: ImageSource.camera);
                                //
                                // if (image != null) {
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) =>
                                //           ScanScreen(image: File(image.path)),
                                //     ),
                                //   );
                                // };
                              }
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          //search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [

                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search your subject here....',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  Icon(Icons.search, color: Colors.grey[600], size: 24),
                ],
              ),
            ),
          ),

          //Dashbord item Menu
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: dashboardMenuList.length,
              itemBuilder: (context, index) {
                return DashBoardIcons(
                  icon: dashboardMenuList[index].icon,
                  text: dashboardMenuList[index].text,
                  color: dashboardMenuList[index].color,
                  onPressed: () {
                    if (dashboardMenuList[index].action ==
                        "Learning Assistant") {
                      // ignore: avoid_print
                      print("Learning Assistant Clicked");
                    }
                  },
                );
              },
            ),
          ),


          //Buttom Navigation Bar



        ],
      ),
      bottomNavigationBar: BottomNavigationBarCustom(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
