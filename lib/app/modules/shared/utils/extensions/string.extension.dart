import 'dart:convert';
import 'package:core_web3dart/src/crypto/formatting.dart';
import 'package:core_web3dart/web3dart.dart';
extension ValidateCoreId on String {
  bool isValid() {
    try {
      XCBAddress.fromHex(this);
      return true;
    } catch (err) {
      return false;
    }
  }
}

extension Hex on String {
  String getHex() {
    List<int> bytes = utf8.encode(this);
    return "0x${bytesToHex(bytes)}";
  }

  String convertHexToString() {
    return utf8.decode(hexToBytes(this));
  }
}
