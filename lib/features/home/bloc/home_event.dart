part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class ImageSelectedEvent extends HomeEvent {
  final double canvasWidth;

  ImageSelectedEvent({
    required this.canvasWidth,
  });
}
