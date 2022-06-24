import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_bip39/bip39.dart';
import 'package:flutter_bip39/src/models/seed_model.dart';
import 'package:heyo/app/modules/p2p_node/data/key/cryptography_key_generator.dart';
import 'package:pointycastle/digests/sha3.dart';

import 'package:core_web3dart/src/crypto/formatting.dart';
import 'package:core_web3dart/web3dart.dart';
import 'package:core_web3dart/crypto.dart';

class Web3Keys extends CryptographyKeyGenerator {
  final Web3Client web3client;

  Web3Keys({required this.web3client});

  @override
  Future<String> generateAddress(String privateKey) async {
   return XCBPrivateKey.fromHex(privateKey).extractAddress(await web3client.getNetworkId()).hex;
  }

  @override
  Future<String> generateCoreIdFromPriv(String privateKey) async {
    final pub = privateKeyBytesToPublic(hexToBytes(privateKey));
    final addr = publicKeyToAddress(pub, await web3client.getNetworkId());
    return bytesToHex(addr, include0x: true);
  }

  @override
  List<String> generate_mnemonic() {
    final _mns = generateMnemonic();
    return _mns.split(" ");
  }

  @override
  Future<String> generatePrivateKeysFromMneomonic(List<String> phrases,
      String pinCode) async {
    final _mns = phrases.join(" ");
    final _seed = mnemonicToSeed(_mns, passphrase: pinCode);

    //TODO check moji bytesToHex
    XCBPrivateKey xcbPrivateKey = await XCBPrivateKey.createPrivateKey(
        bytesToHex(_seed.goldilockKeySeed), 0);
    final privateKey = bytesToHex(xcbPrivateKey.privateKey);

    return privateKey;
  }

  String _getAesKey(SeedModel _seed) {
    final SHA3Digest sha3digest = SHA3Digest(512);
    sha3digest.reset();
    final shaRes = sha3digest
        .process(Uint8List.fromList(utf8.encode(_seed.aesKeySeed.map((byte) {
      return byte.toRadixString(16).padLeft(2, '0');
    }).join(''))));
    final shaHex = bytesToHex(shaRes);
    final aesKey = shaHex.substring(0, 32);
    return aesKey;
  }

  @override
  Future<String> getPublicKeyFromPrivate(String privKey) async {
    final pub = privateKeyBytesToPublic(hexToBytes(privKey));
    return bytesToHex(pub);
  }

}
