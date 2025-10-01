import 'dart:io';

import 'package:ai_math_solver/utils/app_strings.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../custom_widget/crop_image_custom_widget.dart';
import '../utils/asset_paths.dart';

late List<CameraDescription> _camera;

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late final CameraDescription camera;
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    initCamera();
    super.initState();
  }

  late List<CameraDescription> _cameras;

  Future<void> initCamera() async {
    try {
      _cameras = await availableCameras();
      // back camera
      final camera = _cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
      );

      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      _initializeControllerFuture = _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }

    _controller = CameraController(camera, ResolutionPreset.max);
    _initializeControllerFuture = _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  int selectedIndex = 0; // default Math selected
  bool isFrontCamera = false; // camera toggle
  bool isFlashOn = false; // flash toggle

  final _picker = ImagePicker();

  final subjects = [
    "Math",
    "Physics",
    "Chemistry",
    "Bio",
    "English",
    "Geography",
  ];

  // Toggle flash on/off
  Future<void> toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    isFlashOn = !isFlashOn;

    await _controller!.setFlashMode(
      isFlashOn ? FlashMode.torch : FlashMode.off,
    );
  }

  Future<void> toggleCamera() async {
    if (_cameras.isEmpty) return;

    // Flip the state
    isFrontCamera = !isFrontCamera;

    // Pick the camera depending on state
    final selectedCamera = _cameras.firstWhere(
      (cam) => isFrontCamera
          ? cam.lensDirection == CameraLensDirection.front
          : cam.lensDirection == CameraLensDirection.back,
    );

    // Dispose old controller
    await _controller?.dispose();

    // Create new controller
    _controller = CameraController(
      selectedCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller?.initialize();

    // Rebuild UI
    if (mounted) {
      setState(() {});
    }
  }

  // Navigate to CropScreen
  void _navigateToCropScreen(File imageFile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CropScreen(imageFile: imageFile, image: imageFile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      _controller != null &&
                      _controller!.value.isInitialized) {
                    return CameraPreview(_controller!);
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Camera error: ${snapshot.error}"),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            // Top bar (scan question row)
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                  Text(
                    AppStrings().scan_question,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      toggleFlash();
                    },
                    child: Image.asset(AssetPaths().flash_button, scale: 2.5),
                  ),
                ],
              ),
            ),

            // Bottom rectangle container
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Scrollable Subjects
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: subjects.length,
                        itemBuilder: (context, index) {
                          final isSelected = index == selectedIndex;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                subjects[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Colors.orange
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Three icons row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Gallery button
                        GestureDetector(
                          onTap: () {
                            _picker.pickImage(source: ImageSource.gallery).then(
                              (XFile? file) {
                                if (file != null) {
                                  _navigateToCropScreen(File(file.path));
                                }
                              },
                            );
                          },
                          child: Image.asset(
                            AssetPaths().gallery_button,
                            scale: 2.5,
                          ),
                        ),

                        // Center button
                        GestureDetector(
                          onTap: () {
                            _controller!.takePicture().then((XFile? file) {
                              if (file != null) {
                                _navigateToCropScreen(File(file.path));
                              }
                            });
                          },
                          child: Image.asset(
                            AssetPaths().scan_screen_buttom_center_button,
                            scale: 2.0,
                          ),
                        ),

                        // Camera toggle button
                        GestureDetector(
                          onTap: toggleCamera,
                          child: Image.asset(
                            AssetPaths().camera_movement_button,
                            scale: 2.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
