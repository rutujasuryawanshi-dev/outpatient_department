// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
//
// class AddFaceidScreen extends StatefulWidget {
//   const AddFaceidScreen({super.key});
//
//   @override
//   State<AddFaceidScreen> createState() => _AddFaceidScreenState();
// }
//
// class _AddFaceidScreenState extends State<AddFaceidScreen> {
//   CameraController? _cameraController;
//   bool _isDetecting = false;
//   FaceDetector? _faceDetector;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     _faceDetector = GoogleMlKit.vision.faceDetector();
//   }
//
//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     final frontCamera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
//
//     _cameraController = CameraController(
//       frontCamera,
//       ResolutionPreset.medium,
//       enableAudio: false,
//     );
//
//     await _cameraController?.initialize();
//
//     _cameraController?.startImageStream((image) async {
//       if (_isDetecting) return;
//       _isDetecting = true;
//
//       final inputImage = InputImage.fromBytes(
//         bytes: image.planes[0].bytes,
//         inputImageData: InputImageData(
//           size: Size(image.width.toDouble(), image.height.toDouble()),
//           imageRotation: InputImageRotation.rotation0deg,
//           inputImageFormat: InputImageFormat.nv21,
//           planeData: image.planes.map((plane) {
//             return InputImagePlaneMetadata(
//               bytesPerRow: plane.bytesPerRow,
//               height: plane.height,
//               width: plane.width,
//             );
//           }).toList(),
//         ),
//       );
//
//       // Detect faces
//       final faces = await _faceDetector?.processImage(inputImage);
//
//       if (faces != null && faces.isNotEmpty) {
//         _onFaceDetected(faces.first);  // Capture first face (or modify for multiple faces)
//       }
//
//       _isDetecting = false;
//     });
//   }
//
//   void _onFaceDetected(Face face) {
//     // Here, you would save the face data (features) for future comparison or the image.
//     final faceImage = _cameraController?.value.previewSize;
//
//     // Save the face data to secure storage or database
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Face successfully registered!')));
//     _stopCamera();
//   }
//
//   Future<void> _stopCamera() async {
//     await _cameraController?.stopImageStream();
//     await _cameraController?.dispose();
//     _cameraController = null;
//   }
//
//   @override
//   void dispose() {
//     _stopCamera();
//     _faceDetector?.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           if (_cameraController != null && _cameraController!.value.isInitialized)
//             SizedBox(
//               height: 300,
//               width: double.infinity,
//               child: CameraPreview(_cameraController!),
//             ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () => _initializeCamera(),
//             child: Text('Scan Face'),
//           ),
//         ],
//       ),
//     );
//   }
// }
