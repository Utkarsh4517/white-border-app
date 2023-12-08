import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:white_border/features/home/bloc/home_bloc.dart';

class RoundButton extends StatefulWidget {
  final String label;
  final double width;
  final double height;
  const RoundButton({
    required this.height,
    required this.width,
    required this.label,
    super.key,
  });

  @override
  State<RoundButton> createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  final bloc = HomeBloc();
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: bloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {},
      builder: (context, state) {
        return GestureDetector(
          onTapUp: (_) {
            setState(() {
              isSelected = false;
            });
          },
          onTapDown: (_) {
            setState(() {
              isSelected = true;
              bloc.add(RatioButtonClickedEvent(
                canvasWidth: widget.width,
                canvasHeight: widget.height,
              ));
            });
          },
          onTapCancel: () {
            setState(() {
              isSelected = false;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.purple[200] : Colors.white,
            ),
            padding: EdgeInsets.all(isSelected ? 10 : 20),
            // margin: const EdgeInsets.all(30),
            child: Text(
              widget.label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        );
      },
    );
  }
}
