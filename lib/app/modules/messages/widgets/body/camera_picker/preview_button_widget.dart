import 'package:flutter/material.dart';
import 'package:heyo/generated/assets.gen.dart';

class PreviewButtonWidget extends StatelessWidget {
  const PreviewButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        child: Assets.svg.multipleSelectIcon.svg(),
        padding: const EdgeInsets.all(0),
        minWidth: 0,
        shape: const CircleBorder(),
        onPressed: () {
          print('additionalPreviewButtonWidget');
        });
  }
}
