import 'package:flutter/material.dart';

class PreviewButtonWidget extends StatelessWidget {
  const PreviewButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        child: const Icon(
          Icons.info_outlined,
          color: Colors.white,
        ),
        padding: EdgeInsets.all(0),
        minWidth: 0,
        shape: const CircleBorder(),
        onPressed: () {
          print('additionalPreviewButtonWidget');
        });
  }
}
