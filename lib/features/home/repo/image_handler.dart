// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

class ImageHandler {
  static Future<(File, double)?> pickImage(
      {required double canvasWidth}) async {
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
      final imageScale = (canvasWidth / img.width).clamp(0.1, 2.0);
      return (File(pickedFile.path), imageScale);
    }
    return null;
  }

  static Future<void> exportImage({
    required File imageFile,
    required double canvasWidth,
    required double canvasHeight,
  }) async {
    final imageBytes = await imageFile.readAsBytes();
    final ui.Image image =
        await decodeImageFromList(Uint8List.fromList(imageBytes));

    double scaleFactor = canvasWidth / image.width;
    if (image.height * scaleFactor > canvasHeight) {
      scaleFactor = canvasHeight / image.height;
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawColor(Colors.white, BlendMode.srcOver);

    final double offsetX = (canvasWidth - image.width * scaleFactor) / 2.0;
    final double offsetY = (canvasHeight - image.height * scaleFactor) / 2.0;

    canvas.drawImageRect(
      image,
      Rect.fromPoints(const Offset(0.0, 0.0),
          Offset(image.width.toDouble(), image.height.toDouble())),
      Rect.fromPoints(Offset(offsetX, offsetY),
          Offset(canvasWidth - offsetX, canvasHeight - offsetY)),
      Paint(),
    );

    // Export the canvas as an image file
    final picture = recorder.endRecording();
    final img =
        await picture.toImage(canvasWidth.toInt(), canvasHeight.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(buffer));

    if (result['isSuccess']) {
      print('Image saved successfully: ${result['filePath']}');
    } else {
      print('Error saving image: ${result['error']}');
    }
  }
}
