import 'package:web3dart/credentials.dart';


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