import 'dart:io';

import 'package:button_animations/button_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:white_border/constants/dimensions.dart';
import 'package:white_border/features/home/bloc/home_bloc.dart';
import 'package:white_border/features/home/repo/image_handler.dart';
import 'package:white_border/features/home/widgets/custom_canvas.dart';
import 'package:white_border/features/home/widgets/round_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  double canvasWidth = 4000; // Initial canvas width
  double canvasHeight = 4000; // Initial canvas height
  double imageScale = 1.0; // Initial image scale

  final homeBloc = HomeBloc();
  @override
  void initState() {
    super.initState();
    homeBloc.add(HomeInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is RatioChangedState) {
          setState(() {
            canvasWidth = state.canvasWidth;
            canvasHeight = state.canvasHeight;
          });
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case NoImageSelectedState:
            return Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () {
                    homeBloc.add(ImageSelectedEvent(
                      canvasWidth: canvasWidth,
                    ));
                  },
                  child: const Text(
                    'Select an image',
                  ),
                ),
              ),
            );
          case ImageSelectedState:
            final successState = state as ImageSelectedState;
            return Scaffold(
              appBar: AppBar(
                title: const Text('OS White-Board'),
                actions: [
                  Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: IconButton(
                          onPressed: () {
                            ImageHandler.exportImage(
                                imageFile: successState.image,
                                canvasWidth: canvasWidth,
                                canvasHeight: canvasHeight);
                          },
                          icon: const Icon(Icons.download)))
                ],
                centerTitle: true,
                backgroundColor: const Color(0xfffffff0),
              ),
              backgroundColor: const Color(0xfffffff0),
              body: SafeArea(
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: getScreenheight(context) * 0.05),
                        CustomCanvas(
                          image: successState.image,
                          imageScale: successState.imageScale,
                          canvasWidth: canvasWidth,
                          canvasHeight: canvasHeight,
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        height: getScreenheight(context) * 0.25,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Text(
                                'Canvas Size: ${canvasWidth.round()} x ${canvasHeight.round()}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTapDown: (_) {
                                    homeBloc.add(RatioButtonClickedEvent(
                                        canvasWidth: 4000, canvasHeight: 4000));
                                  },
                                  child: const RoundButton(
                                      height: 4000, width: 4000, label: '1.1'),
                                ),
                                GestureDetector(
                                  onTapDown: (_) {
                                    homeBloc.add(RatioButtonClickedEvent(
                                        canvasWidth: 4320, canvasHeight: 5400));
                                  },
                                  child: const RoundButton(
                                      height: 4320, width: 5400, label: '4:5'),
                                ),
                                GestureDetector(
                                  onTapDown: (_) {
                                    homeBloc.add(RatioButtonClickedEvent(
                                        canvasWidth: 7680, canvasHeight: 4320));
                                  },
                                  child: const RoundButton(
                                      height: 7680, width: 4320, label: '16:9'),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                homeBloc.add(ImageSelectedEvent(
                                    canvasWidth: canvasWidth));
                              },
                              child: const Text('Select Image'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          default:
            return const Scaffold(
              body: Center(
                child: Text('Error State'),
              ),
            );
        }
      },
    );
  }
}
