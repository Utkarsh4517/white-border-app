import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class ImageHandler {
  static Future<Uint8List?> pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      return result.files.single.bytes;
    }
    return null;
  }

  static Future<Uint8List?> addWhiteBorder(
      {required Uint8List imageBytes}) async {
    img.Image image = img.decodeImage(imageBytes)!;

    int borderSize = 20;
    img.Image canvas = img.Image(
        height: (image.height + 2 * borderSize),
        width: (image.width + 2 * borderSize));
    

  }
}
