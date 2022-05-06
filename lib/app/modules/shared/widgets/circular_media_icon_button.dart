import 'package:flutter/material.dart';

class CircularMediaIconButton extends StatelessWidget {
  final Color backgroundColor;
  final void Function()? onPressed;
  final double padding;
  final Widget? child;
  const CircularMediaIconButton({
    Key? key,
    this.child,
    this.onPressed,
    this.backgroundColor = Colors.white,
    this.padding = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        color: backgroundColor,
        onPressed: onPressed,
        shape: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Center(
            child: child,
            // child: Assets.svg.cameraIcon.svg(
            //   width: 29,
            //   height: 29,
            //   alignment: Alignment.center,
            // ),
          ),
        ));
  }
}
