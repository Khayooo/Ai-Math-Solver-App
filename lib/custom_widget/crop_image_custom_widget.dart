// CropScreen.dart
import 'dart:io';
import 'package:ai_math_solver/utils/colors_paths.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class CropScreen extends StatefulWidget {
  final File image;



  const CropScreen({super.key, required this.image, required File imageFile, });

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  File? _croppedFile;

  Future<void> _cropImage() async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: widget.image.path,

      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: ColorsPaths().orange_color,
          // toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),

        ],

    );

    if (croppedFile != null) {
      setState(() {
        if (mounted)
        _croppedFile = File(croppedFile.path);
      });
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
      // appBar: AppBar(title: Text("Crop Image"),),
      body: Stack(
        children: [
          /// Full screen image (cropped ya original)
          Positioned.fill(
            child: _croppedFile != null
                ? Image.file(_croppedFile!, fit: BoxFit.cover)
                : Image.file(widget.image, fit: BoxFit.cover),
          ),

          /// Top Row (Scan Question / Back Button)
          // Positioned(
          //   top: 40,
          //   left: 16,
          //   right: 16,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       // Back Button
          //       IconButton(
          //         icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          //         onPressed: () => Navigator.pop(context),
          //       ),
          //       const Text(
          //         "Scan Question",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 20,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //       const SizedBox(width: 40), // balance ke liye
          //     ],
          //   ),
          // ),

          /// Bottom Rectangle Button
          // Positioned(
          //   bottom: 20,
          //   left: 16,
          //   right: 16,
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.deepOrange,
          //       padding: const EdgeInsets.symmetric(vertical: 14),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //     ),
          //     onPressed: () {
          //       if (_croppedFile != null) {
          //         Navigator.pop(context, _croppedFile);
          //       } else {
          //         Navigator.pop(context, widget.image);
          //       }
          //     },
          //     child: const Text(
          //       "Use This Image",
          //       style: TextStyle(fontSize: 18, color: Colors.white),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
