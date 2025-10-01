import 'package:ai_math_solver/custom_widget/language_list_item.dart';
import 'package:ai_math_solver/model/app_language.dart';
import 'package:ai_math_solver/utils/app_strings.dart';
import 'package:ai_math_solver/utils/asset_paths.dart';
import 'package:ai_math_solver/utils/colors_paths.dart';
import 'package:flutter/material.dart';

import '../dashboard/dashboard.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  List<AppLanguages> languages = [
    AppLanguages(language: 'English', country: AssetPaths().us_logo),
    AppLanguages(language: 'Arabic', country: AssetPaths().arabic_logo),
    AppLanguages(language: 'India', country: AssetPaths().india_logo),
    AppLanguages(language: 'English', country: AssetPaths().portugal_logo),
    AppLanguages(language: 'Portugal', country: AssetPaths().russia_logo),
    AppLanguages(language: 'Russia', country: AssetPaths().russia_logo),
    AppLanguages(language: 'Turkey', country: AssetPaths().turkey_logo),
    AppLanguages(language: 'Spain', country: AssetPaths().spain_logo),
    AppLanguages(language: 'German', country: AssetPaths().german_logo),
  ];
  int selectedIndex = 0;
  int intemcount = 0;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text.rich(
            TextSpan(
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              children: <TextSpan>[
                TextSpan(
                  text: AppStrings().select,
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: AppStrings().language,
                  style: TextStyle(color: ColorsPaths().color),
                ),
              ],
            ),
          ),
          centerTitle: false,
          backgroundColor: Colors.white,
          actions: [
            Container(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsPaths().color,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const Dashboard();
                  }));
                },
                child: Text(
                  AppStrings().done,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),

        body: Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: languages.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: LanguageListItem(
                languages: languages[index].language,
                country: languages[index].country,
                selectedIndex: selectedIndex,
                index: index,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
