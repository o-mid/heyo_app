import 'dart:io';

import 'package:flutter/services.dart';

Future<Uint8List> pathToUnit8list({required String filePath}) {
  File file = File(filePath);

  return file.readAsBytes();
}
