import 'dart:convert';

import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';


extension ValidateCoreId on String {
  bool isValid() {
    try {
      EthereumAddress.fromHex(this);
      return true;
    } catch (err) {
      return false;
    }
  }
}
extension Hex on String {
  String getHex(){
    List<int> bytes=utf8.encode(this);
    return "0x${bytesToHex(bytes)}";
  }
}