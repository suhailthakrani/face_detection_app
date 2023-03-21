import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({Key? key}) : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_imageFile != null) ...[
          Image.file(_imageFile!),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              // Detect faces in the selected image here.
            },
            child: Text('Detect Faces'),
          ),
        ] else ...[
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _pickImage(ImageSource.camera),
            child: Text('Take Picture'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _pickImage(ImageSource.gallery),
            child: Text('Pick from Gallery'),
          ),
        ],
      ],
    );
  }
}
