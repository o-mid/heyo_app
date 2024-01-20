import 'dart:convert';
import 'package:core_web3dart/src/crypto/formatting.dart';
import 'package:core_web3dart/web3dart.dart';

extension ValidateCoreId on String {
  bool isValidCoreId() {
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
    //TODO: check with Farzam for having a prefix on hex SDP
    return "0x${bytesToHex(bytes)}";
  }

  String convertHexToString() {
    return utf8.decode(hexToBytes(this));
  }
}

extension StringExtension on String {
  String stringCapitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

extension JsonExtension on String {
  /// wraps keys and values within quotes
  String toValidJson() {
    return replaceAllMapped(RegExp(r'(\w+):'), (Match m) => '"${m[1]}":')
        .replaceAllMapped(RegExp(r':\s*(\w+)'), (Match m) => ': "${m[1]}"');
  }
}
