import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:photo_view/photo_view.dart';

class CustomCanvas extends StatelessWidget {
  final File? image;
  final double imageScale;
  final double canvasWidth;
  final double canvasHeight;
  final double displayScale;

  const CustomCanvas({
    Key? key,
    required this.image,
    required this.imageScale,
    required this.canvasWidth,
    required this.canvasHeight,
    this.displayScale = 0.25, // Adjust this value as needed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double imageScale = 1.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        double adjustedDisplayScale = displayScale;

        // Adjust the display scale if it exceeds the available width or height
        if (constraints.maxWidth < canvasWidth * displayScale ||
            constraints.maxHeight < canvasHeight * displayScale) {
          adjustedDisplayScale = math.min(
            constraints.maxWidth / canvasWidth,
            constraints.maxHeight / canvasHeight,
          );
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: canvasWidth * adjustedDisplayScale,
          height: canvasHeight * adjustedDisplayScale,
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
            initialScale: imageScale * adjustedDisplayScale,
            tightMode: true,
          ),
        );
      },
    );
  }
}
