import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerTest extends StatefulWidget {
  const ImagePickerTest({Key? key}) : super(key: key);

  @override
  State<ImagePickerTest> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePickerTest> {
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image Picker Example'),
        ),
        body: Center(
          child: _image == null
              ? const Text('No image selected.')
              : Image.file(_image!),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: getImage,
          child: const Icon(Icons.add_a_photo),
        ));
  }
}
