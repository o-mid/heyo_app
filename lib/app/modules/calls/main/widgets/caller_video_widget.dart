import 'package:flutter/material.dart';
import 'package:heyo/generated/assets.gen.dart';

// Todo: Replace this with local video webrtc
class CallerVideoWidget extends StatelessWidget {
  const CallerVideoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Assets.png.caller.image();
  }
}
