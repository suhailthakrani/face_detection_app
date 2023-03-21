// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:camera/src/camera_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class FacePainter extends CustomPainter {
  final List<Face> faces;
  CameraController cameraController;

  FacePainter(
    this.faces,
    this.cameraController,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    for (var i = 0; i < faces.length; i++) {
      final face = faces[i];

      canvas.drawRect(
        faces.length > 1
            ? Rect.fromLTRB(
                face.boundingBox.left - 50,
                face.boundingBox.top - 50,
                face.boundingBox.right - 20,
                face.boundingBox.bottom - 20,
              )
            : Rect.fromLTRB(
                face.boundingBox.left - 20,
                face.boundingBox.top - 20,
                face.boundingBox.right - 20,
                face.boundingBox.bottom,
              ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) => true;
}


/*
CustomPaint(
  painter: FacePainter(faces),
  child: Image.file(_imageFile!),
)

class FacePainter extends CustomPainter {
  final List<Face> faces;

  FacePainter(this.faces);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (final face in faces) {
      canvas.drawRect(face.boundingBox, paint);
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return faces != oldDelegate.faces;
  }
}
*/
