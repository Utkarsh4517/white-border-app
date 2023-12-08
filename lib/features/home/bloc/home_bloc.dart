// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:white_border/features/home/repo/image_handler.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<ImageSelectedEvent>(imageSelectedEvent);
    on<RatioButtonClickedEvent>(ratioButtonClickedEvent);
  }

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) {
    emit(NoImageSelectedState());
  }

  FutureOr<void> imageSelectedEvent(
      ImageSelectedEvent event, Emitter<HomeState> emit) async {
    var record = await ImageHandler.pickImage(canvasWidth: event.canvasWidth);
    emit(ImageSelectedState(image: record!.$1, imageScale: record.$2));
  }

  FutureOr<void> ratioButtonClickedEvent(
      RatioButtonClickedEvent event, Emitter<HomeState> emit) {
    emit(RatioChangedState(
      canvasWidth: event.canvasWidth,
      canvasHeight: event.canvasHeight,
    ));
    print('Ratio changed : ${event.canvasWidth} x ${event.canvasHeight}');
  }
}
