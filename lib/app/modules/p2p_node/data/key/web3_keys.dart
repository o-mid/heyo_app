import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_bip39/bip39.dart';
import 'package:flutter_bip39/src/models/seed_model.dart';
import 'package:heyo/app/modules/p2p_node/auth_keys_model.dart';
import 'package:heyo/app/modules/p2p_node/data/key/cryptography_key_generator.dart';
import 'package:pointycastle/digests/sha3.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';

class Web3Keys extends CryptographyKeyGenerator {
  @override
  Future<String> generateAddress(String privateKey) async {
    // TODO: get the actual address from the web3 lib
    // TODO: uncomment this for production
    // final addr = await Ed448Goldilock.getPublicKeyFromPrivateKey(privateKey);
    final pub = privateKeyBytesToPublic(hexToBytes(privateKey));
    final addr = publicKeyToAddress(pub);
    return bytesToHex(addr, include0x: true);
  }

  @override
  Future<String> generateCoreIdFromPriv(String privateKey) async {
    // TODO: get the actual address from the web3 lib
    // TODO: uncomment this for production

    // final addr = await Ed448Goldilock.getPublicKeyFromPrivateKey(privateKey);
    final pub = privateKeyBytesToPublic(hexToBytes(privateKey));
    final addr = publicKeyToAddress(pub);
    return bytesToHex(addr, include0x: true);
  }

  @override
  List<String> generate_mnemonic() {
    final _mns = generateMnemonic();
    return _mns.split(" ");
  }

  @override
  Future<KeysModel> generatePrivateKeysFromMneomonic(
      List<String> phrases, String pinCode) async {
    final _mns = phrases.join(" ");
    final _seed = mnemonicToSeed(_mns, passphrase: pinCode);

    String _privGoldilockKey = await _getGoldilockKey(_seed);
    String aesKey = _getAesKey(_seed);
    return KeysModel(_privGoldilockKey, aesKey);
  }

  Future<String> _getGoldilockKey(SeedModel _seed) async {
    // TODO: uncomment this for production

    // final _privGoldilockKey = await Ed448Goldilock.generatePrivateKey(
    //     bytesToHex(_seed.goldilockKeySeed));
    // return _privGoldilockKey;

    final _privGoldilockKey = EthPrivateKey.createRandom(Random());
    return bytesToHex((_privGoldilockKey.privateKey));
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
    // TODO: uncomment this for production

    // final pub = await Ed448Goldilock.getPublicKeyFromPrivateKey(privKey);
    final pub = privateKeyBytesToPublic(hexToBytes(privKey));
    return bytesToHex(pub);
  }

  @override
  String generateSHA3Hash(String txt) {
    return bytesToHex(keccak256(hexToBytes(txt)));
  }


}
