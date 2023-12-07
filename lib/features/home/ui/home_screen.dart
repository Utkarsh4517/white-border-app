// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  double canvasWidth = 341.33; // Initial canvas width
  double canvasHeight = 256; // Initial canvas height
  double imageScale = 1.0; // Initial image scale

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomCanvas(
              image: _image,
              imageScale: imageScale,
              canvasWidth: canvasWidth,
              canvasHeight: canvasHeight,
            ),
            const SizedBox(height: 20),
            Text(
                'Canvas Size: ${canvasWidth.round()} x ${canvasHeight.round()}'),
            Slider(
              value: imageScale,
              min: 0.1,
              max: 2.0,
              onChanged: (value) {
                setState(() {
                  imageScale = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildRatioButton('1:1', 300.0, 300.0),
                _buildRatioButton('4:5', 360.0, 450.0),
                _buildRatioButton('16:9', 365.71, 205.71),
              ],
            ),
            ElevatedButton(
              onPressed: () => _pickImage(),
              child: const Text('Select Image'),
            ),
            ElevatedButton(
              onPressed: () => _exportImage(),
              child: const Text('Export Image'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatioButton(String label, double width, double height) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          // Update the canvas size based on the aspect ratio and image scale
          canvasWidth = width;
          canvasHeight = height;
        });
      },
      child: Text(label),
    );
  }

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = Image.file(File(pickedFile.path));
      final Completer<ui.Image> completer = Completer<ui.Image>();

      image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
          (ImageInfo info, bool _) {
            completer.complete(info.image);
          },
        ),
      );

      final ui.Image img = await completer.future;

      setState(() {
        _image = File(pickedFile.path);
        // Calculate initial scale to fit the image inside the canvas
        imageScale = (canvasWidth / img.width).clamp(0.1, 2.0);
      });
    }
  }

Future<void> _exportImage() async {
  if (_image != null) {
    final imageBytes = await _image!.readAsBytes();
    final ui.Image image = await decodeImageFromList(Uint8List.fromList(imageBytes));

    // Calculate the scaling factors to fit the image within the canvas while maintaining its aspect ratio
    double scaleFactor = canvasWidth / image.width;
    if (image.height * scaleFactor > canvasHeight) {
      scaleFactor = canvasHeight / image.height;
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Set the canvas background to white
    canvas.drawColor(Colors.white, BlendMode.srcOver);

    // Calculate the position to center the image within the canvas
    final double offsetX = (canvasWidth - image.width * scaleFactor) / 2.0;
    final double offsetY = (canvasHeight - image.height * scaleFactor) / 2.0;

    // Draw the image on the canvas with the calculated scale and position
    canvas.drawImageRect(
      image,
      Rect.fromPoints(Offset(0.0, 0.0), Offset(image.width.toDouble(), image.height.toDouble())),
      Rect.fromPoints(Offset(offsetX, offsetY), Offset(canvasWidth - offsetX, canvasHeight - offsetY)),
      Paint(),
    );

    // Export the canvas as an image file
    final picture = recorder.endRecording();
    final img = await picture.toImage(canvasWidth.toInt(), canvasHeight.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    // Save the image file using image_gallery_saver package
    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(buffer));

    if (result['isSuccess']) {
      print('Image saved successfully: ${result['filePath']}');
    } else {
      print('Error saving image: ${result['error']}');
    }
  }
}
}

class CustomCanvas extends StatelessWidget {
  final File? image;
  final double imageScale;
  final double canvasWidth;
  final double canvasHeight;

  const CustomCanvas({
    Key? key,
    required this.image,
    required this.imageScale,
    required this.canvasWidth,
    required this.canvasHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: canvasWidth,
      height: canvasHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: PhotoView(
        imageProvider: image != null
            ? FileImage(image!) as ImageProvider
            : const AssetImage('assets/placeholder.png'),
        backgroundDecoration: const BoxDecoration(color: Colors.white),
        minScale: PhotoViewComputedScale.contained,
        maxScale: 2.0,
        initialScale: imageScale,
        tightMode: true,
      ),
    );
  }
}
