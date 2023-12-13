import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heyo/app/modules/intro/data/provider/verification_corepass_abstract_provider.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_manager.dart';
import 'package:heyo/app/modules/shared/providers/crypto/storage/libp2p_storage_provider.dart';
import 'package:heyo/app/modules/shared/utils/datetime_utils.dart';
import 'package:heyo/app/modules/shared/utils/extensions/stream.extension.dart';
import 'package:tuple/tuple.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher_string.dart';

class VerificationCorePassProvider
    extends VerificationCorePassAbstractProvider {
  VerificationCorePassProvider({
    required this.cryptoInfo,
    required this.p2pNodeController,
    required this.dateTimeUtils,
  });

  StreamSubscription? _urlStream;
  final LibP2PStorageProvider cryptoInfo;
  final P2PNodeController p2pNodeController;
  final DateTimeUtils dateTimeUtils;

  @override
  Future<bool> launchVerificationProcess() async {
    final heyoId = await cryptoInfo.getLocalCoreId();

    /// This only uses while just to make sure node is started and advertised successfully
    // while (heyoId == null) {
    //   heyoId = await accountInfo.getLocalCoreId();
    // }
    // App scheme for corePass
    final uri =
        'corepass:sign/?data=$heyoId&conn=heyo://auth&dl=${dateTimeUtils.getCurrentTimeInSeconds(300)}&type=app-link';
    print('Launching : $uri');
    try {
      await launchUrlString(uri);
      debugPrint('The app is installed on the device.');
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<Tuple2<String, String>> listenForResponse() async {
    final rawData = await linkStream.waitForResult(
        condition: (String? value) => value != null && value.isNotEmpty);
    final analyzedData = _extractUri(rawData!);

    return analyzedData!;
  }

  @override
  Future<void> cleanUp() async {
    await _urlStream?.cancel();
    _urlStream = null;
  }

  Tuple2<String, String>? _extractUri(String deepLink) {
    final result = Uri.parse(deepLink).queryParameters;

    if (_checkUriIsInvalid(result)) return null;

    final signature = result['signature'];
    final coreId = result['coreID'];
    if (signature != null && coreId != null) {
      return Tuple2(coreId, signature);
    } else {
      //todo show error
    }
    return null;
  }

  bool _checkUriIsInvalid(Map<String, String> result) {
    return result['signature'] == null || result['coreID'] == null;
  }

  @override
  Future<bool> setCredentials(
    String coreId,
    String signature,
  ) async {
    try {

      await cryptoInfo.setSignature(signature.replaceAll('0x', ''));
      await cryptoInfo.setCorePassCoreId(coreId);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
