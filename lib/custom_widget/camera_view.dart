// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
//
//
//
// class CameraView extends StatefulWidget {
//   const CameraView({
//     super.key,
//   });
//   @override
//   State<CameraView> createState() => _CameraViewState();
// }
// class _CameraViewState extends State<CameraView> {
//   final CameraDescription camera=CameraDescription(name: "", lensDirection: CameraLensDirection.back, sensorOrientation: 0);
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//   @override
//   void initState() {
//     initCamera();
//     super.initState();
//   }
//   initCamera() async {
//     _controller = CameraController(
//       camera,
//       ResolutionPreset.max,
//     );
//     _initializeControllerFuture = _controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     });
//   }
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return  FutureBuilder<void>(
//       future: _initializeControllerFuture,
//       builder: (context, snapshot) {
//         if (!_controller.value.isInitialized) {
//           return CameraPreview(_controller);
//         } else {
//           return Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }
// }
