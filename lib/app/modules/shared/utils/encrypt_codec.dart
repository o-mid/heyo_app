import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
// ignore: implementation_imports
import 'package:sembast/src/api/v2/sembast.dart';

var _random = Random.secure();

/// Random bytes generator
Uint8List _randBytes(int length) {
  return Uint8List.fromList(List<int>.generate(length, (i) => _random.nextInt(256)));
}

/// Generate an encryption password based on a user input password
///
/// It uses MD5 which generates a 16 bytes blob, size needed for Salsa20
Uint8List _generateEncryptPassword(String password) {
  var blob = Uint8List.fromList(md5.convert(utf8.encode(password)).bytes);
  assert(blob.length == 16);
  return blob;
}

/// Salsa20 based encoder
class _EncryptEncoder extends Converter<Object?, String> {
  final Salsa20 salsa20;

  _EncryptEncoder(this.salsa20);

  @override
  String convert(dynamic input) {
    // Generate random initial value
    final iv = _randBytes(8);
    final ivEncoded = base64.encode(iv);
    assert(ivEncoded.length == 12);

    // Encode the input value
    final encoded = Encrypter(salsa20).encrypt(json.encode(input), iv: IV(iv)).base64;

    // Prepend the initial value
    return '$ivEncoded$encoded';
  }
}

/// Salsa20 based decoder
class _EncryptDecoder extends Converter<String, Object?> {
  final Salsa20 salsa20;

  _EncryptDecoder(this.salsa20);

  @override
  dynamic convert(String input) {
    // Read the initial value that was prepended
    assert(input.length >= 12);
    final iv = base64.decode(input.substring(0, 12));

    // Extract the real input
    input = input.substring(12);

    //
    var encrypter = Encrypter(salsa20);

    var decrypted = encrypter.decrypt64(input, iv: IV(iv));

    // Decode the input
    var decoded = json.decode(decrypted);
    if (decoded is Map) {
      return decoded.cast<String, Object?>();
    }
    return decoded;
  }
}

/// Salsa20 based Codec
class _EncryptCodec extends Codec<Object?, String> {
  late _EncryptEncoder _encoder;
  late _EncryptDecoder _decoder;

  _EncryptCodec(Uint8List passwordBytes) {
    var salsa20 = Salsa20(Key(passwordBytes));
    _encoder = _EncryptEncoder(salsa20);
    _decoder = _EncryptDecoder(salsa20);
  }

  @override
  Converter<String, Object?> get decoder => _decoder;

  @override
  Converter<Object?, String> get encoder => _encoder;
}

/// Our plain text signature
const _encryptCodecSignature = 'encrypt';

SembastCodec getEncryptSembastCodec({required String password}) => SembastCodec(
    signature: _encryptCodecSignature, codec: _EncryptCodec(_generateEncryptPassword(password)));
