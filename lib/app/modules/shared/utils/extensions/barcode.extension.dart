import 'dart:convert';
import 'package:heyo/app/modules/shared/utils/constants/strings_constant.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';



extension QRParser on Barcode {
  String getCoreId() => code.toString().split(SHARED_ADDR_SEPARATOR)[0];

  String getPeerId() => code.toString().split(SHARED_ADDR_SEPARATOR)[1];

  List<String> getAddresses() =>
      code.toString().split(SHARED_ADDR_SEPARATOR)[2] != null
          ? (jsonDecode(code.toString().split(SHARED_ADDR_SEPARATOR)[2])
      as List<dynamic>)
          .cast<String>()
          : <String>[];
}