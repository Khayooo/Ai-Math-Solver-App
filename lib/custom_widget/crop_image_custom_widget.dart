// CropScreen.dart
import 'dart:io';
import 'package:ai_math_solver/utils/asset_paths.dart';
import 'package:ai_math_solver/utils/colors_paths.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import '../result screen/result_screen.dart';
import '../scan screen/scan_screen.dart';

class CropScreen extends StatefulWidget {
  final File image;
  final String selectedSubject;

  const CropScreen({super.key, required this.image, required File imageFile, required  this.selectedSubject});

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  File? _croppedFile;



  // ✂️ Crop image function
  Future<void> _cropImage() async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: widget.image.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: ColorsPaths().orange_color,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _croppedFile = File(croppedFile.path);
      });
    } else {
      Navigator.pop(context);
    }
  }

  //  Process image via AI model
  Future<void> _processImage() async {
    if (_croppedFile == null) return;

    //  Show loader dialog
   // _showLoadingDialog(context);

    try {

      //  Hide loader
      if (mounted) Navigator.pop(context);

      // Navigate to ImageProcessScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            image: _croppedFile!,
            selectedSubject: widget.selectedSubject,
            prompt: widget.selectedSubject,
            shortAnswer: '',
            detailedAnswer: '',
            imageFile: widget.image,),
        ),
      );

    } catch (e) {
      if (mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing image: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _cropImage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: _croppedFile != null
                ? Image.file(_croppedFile!, fit: BoxFit.cover)
                : Image.file(widget.image, fit: BoxFit.cover),

          ),
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //  Retake button back to ScanScreen
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return  ScanScreen(selectedSubject: widget.selectedSubject,);
                    }));
                  },
                  child: Image.asset(AssetPaths().retake_pic, scale: 2.5),
                ),

                GestureDetector(
                  onTap: () async {

                    await _processImage();


                  },
                  child: Image.asset(AssetPaths().done_button, scale: 2.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
