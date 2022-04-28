import 'package:heyo/app/modules/shared/providers/secure_storage/local_storages_abstract.dart';
import 'package:heyo/app/modules/shared/utils/constants/strings_constant.dart';

class P2PSecret {
  final LocalStorageAbstractProvider localProvider;

  P2PSecret({required this.localProvider});

  Future<String?> getP2PSecret() async {
    final _p2pSecret = await localProvider.readFromStorage(P2P_KEY_IN_STORE);
    return _p2pSecret;
  }

  Future<void> setP2PSecret(String p2pSecret) async {
    await localProvider.saveToStorage(P2P_KEY_IN_STORE, p2pSecret);
  }
}
