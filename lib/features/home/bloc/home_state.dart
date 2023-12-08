part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

abstract class HomeActionState extends HomeState {}

final class HomeInitial extends HomeState {}

class NoImageSelectedState extends HomeState {}

class ImageSelectedState extends HomeState {
  final File image;
  final double imageScale;
  ImageSelectedState({
    required this.image,
    required this.imageScale,
  });
}

class RatioChangedState extends HomeActionState {
  final double canvasWidth;
  final double canvasHeight;
  RatioChangedState({
    required this.canvasWidth,
    required this.canvasHeight,
  });
}
