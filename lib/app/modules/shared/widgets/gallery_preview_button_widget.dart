import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:heyo/generated/assets.gen.dart';

class GalleryPreviewButtonWidget extends StatelessWidget {
  const GalleryPreviewButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        padding: const EdgeInsets.all(0),
        minWidth: 0,
        shape: const CircleBorder(),
        onPressed: () {
          if (kDebugMode) {
            print('additionalPreviewButtonWidget');
          }
        },
        child: Assets.svg.multipleSelectIcon.svg());
  }
}
