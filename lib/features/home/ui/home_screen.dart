// ignore_for_file: avoid_print
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:white_border/constants/dimensions.dart';
import 'package:white_border/features/home/bloc/home_bloc.dart';
import 'package:white_border/features/home/repo/image_handler.dart';
import 'package:white_border/features/home/widgets/custom_canvas.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  double canvasWidth = 1000; // Initial canvas width
  double canvasHeight = 1000; // Initial canvas height
  double imageScale = 1.0; // Initial image scale

  final homeBloc = HomeBloc();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: getScreenheight(context) * 0.15),
                  CustomCanvas(
                    image: _image,
                    imageScale: imageScale,
                    canvasWidth: canvasWidth,
                    canvasHeight: canvasHeight,
                  ),
                  const SizedBox(height: 20),
                  Text(
                      'Canvas Size: ${canvasWidth.round()} x ${canvasHeight.round()}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildRatioButton('1:1', 4000, 4000),
                      _buildRatioButton('4:5', 4320, 5400),
                      _buildRatioButton('16:9', 7680, 4320),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var record = await ImageHandler.pickImage(
                          canvasWidth: canvasWidth);
                      setState(() {
                        _image = record!.$1;
                        imageScale = record.$2;
                      });
                    },
                    child: const Text('Select Image'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ImageHandler.exportImage(
                        imageFile: _image!,
                        canvasWidth: canvasWidth,
                        canvasHeight: canvasHeight,
                      );
                    },
                    child: const Text('Export Image'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
}
