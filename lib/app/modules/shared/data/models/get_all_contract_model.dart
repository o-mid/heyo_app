import 'dart:typed_data';
import 'package:core_web3dart/crypto.dart';

class GetAllContractModel {
  GetAllContractModel(List<dynamic> response)
      : var1 = (response[0] as List<dynamic>)
            .cast<Uint8List>()
            .map(bytesToHex)
            .toList(),
        var2 = (response[1] as List<dynamic>).cast<Uint8List>();

  final List<String> var1;

  final List<Uint8List> var2;
}
