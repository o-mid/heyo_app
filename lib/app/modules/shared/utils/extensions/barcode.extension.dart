import 'dart:convert';
import 'package:heyo/app/modules/shared/utils/constants/strings_constant.dart';

extension QRParser on String {
  String getCoreId() => split(SHARED_ADDR_SEPARATOR)[0];

  String getPeerId() => split(SHARED_ADDR_SEPARATOR)[1];

  List<String> getAddresses() => split(SHARED_ADDR_SEPARATOR)[2] != null // Todo(qr)
      ? (jsonDecode(split(SHARED_ADDR_SEPARATOR)[2]) as List<dynamic>).cast<String>()
      : <String>[];
}
