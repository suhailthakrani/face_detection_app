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
        Rect.fromLTRB(
          face.boundingBox.left,
          face.boundingBox.top,
          face.boundingBox.right,
          face.boundingBox.bottom,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) => true;
}
