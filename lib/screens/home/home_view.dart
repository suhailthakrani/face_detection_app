import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:face_detection_app/main.dart';
import 'package:face_detection_app/screens/home/face_painter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late CameraController cameraController;
  bool isWorking = false;
  late FaceDetector faceDetector;
  List<Face> faces = [];
  File? _image;
  @override
  void initState() {
    super.initState();
    initiliazeCamera();
  }

  initiliazeCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      cameraController.startImageStream((CameraImage image) {
        if (!isWorking) {
          isWorking = true;
          detect(image);
        }
      });
    });
    faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
      enableContours: false,
      enableClassification: false,
      enableTracking: true,
    ));
  }

  detect(CameraImage image) async {
    try {
      final inputImage = InputImage.fromBytes(
        bytes: _concatenatePlanes(image.planes),
        inputImageData: InputImageData(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          imageRotation: InputImageRotation.rotation90deg,
          inputImageFormat: InputImageFormat.yuv420,
          planeData: [],
        ),
      );
      final List<Face> faces = await faceDetector.processImage(inputImage);
      setState(() {
        this.faces = faces;
      });
    } catch (e) {
      print(e);
    }
    isWorking = false;
  }

  @override
  void dispose() {
    cameraController.dispose();
    faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!cameraController.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(child: CameraPreview(cameraController)),
          CustomPaint(
            painter: FacePainter(faces, cameraController),
          ),
        ],
      ),
    );
  }

  Uint8List _concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  Future<XFile?> _takePicture() async {
    if (!cameraController.value.isInitialized) {
      return null;
    }
    if (cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      return file;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        // _image = File(pickedFile.path);
      });
      // _runModelOnImage();
    }
  }
}
