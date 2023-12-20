import 'dart:convert';
import 'dart:typed_data';

import 'package:core_web3dart/crypto.dart';
import 'package:core_web3dart/web3dart.dart';
import 'package:heyo/contracts/Registry.g.dart';

class RegistryInfoModel {
  RegistryInfoModel(
      {required this.phoneAddress,
      required this.idCardAddress,
      required this.passportAddress,
      required this.driverLicenseAddress,
      required this.residenceAddress,
      required this.emailAddress,
      required this.kycTransmitterAddress,
      required this.kycVaultAddress,
      required this.ctnOracleAddress,
      required this.xcbOracleAddress,
      required this.nameServiceAddress,
      required this.cTNAddress,
      required this.androidLink,
      required this.iosLink,
      required this.isMaintaining,
      required this.latestVersion,
      required this.minVersion,
      required this.proofOfAddressAddress});

  factory RegistryInfoModel.fromJSON(Map<String, dynamic> json) {
    return RegistryInfoModel(
      proofOfAddressAddress: json['proofOfAddressAddress'].toString(),
      phoneAddress: json['phoneAddress'].toString(),
      idCardAddress: json['idCardAddress'].toString(),
      passportAddress: json['passportAddress'].toString(),
      driverLicenseAddress: json['driverLicenseAddress'].toString(),
      residenceAddress: json['residenceAddress'].toString(),
      emailAddress: json['emailAddress'].toString(),
      kycTransmitterAddress: json['kycTransmitterAddress'].toString(),
      kycVaultAddress: json['kycVaultAddress'].toString(),
      ctnOracleAddress: json['ctnOracleAddress'].toString(),
      xcbOracleAddress: json['xcbOracleAddress'].toString(),
      nameServiceAddress: json['nameServiceAddress'].toString(),
      cTNAddress: json['cTNAddress'].toString(),
      androidLink: json['androidLink'].toString(),
      iosLink: json['iosLink'].toString(),
      isMaintaining: json['isMaintaining'].toString(),
      latestVersion: json['latestVersion'].toString(),
      minVersion: json['minVersion'].toString(),
    );
  }

  factory RegistryInfoModel.fromContractModel(GetAll rawModel) {
    final result = rawModel.var1.map(bytesToHex).toList();
    final shaAndroidLink = bytesToHex(getSha3ForSC('androidLink'));
    final shaIOSLink = bytesToHex(getSha3ForSC('iosLink'));
    final shaisMaintaining = bytesToHex(getSha3ForSC('isMaintaining'));
    final shalatestVersion = bytesToHex(getSha3ForSC('latestVersion'));
    final shaminVersion = bytesToHex(getSha3ForSC('minVersion'));
    final shaemailAddress = bytesToHex(getSha3ForSC('EmailVerifier'));
    final shaidCardVerif = bytesToHex(getSha3ForSC('IDCardVerifier'));
    final shakycTransmitter = bytesToHex(getSha3ForSC('KYCTransmitter'));
    final shapassport = bytesToHex(getSha3ForSC('PassportVerifier'));
    final shaphone = bytesToHex(getSha3ForSC('PhoneVerifier'));
    final sharesidence = bytesToHex(getSha3ForSC('ResidencePermitVerifier'));
    final shactnOracle = bytesToHex(getSha3ForSC('CTNOracle'));
    final shakycVault = bytesToHex(getSha3ForSC('KYCVault'));
    final shaxcbOracle = bytesToHex(getSha3ForSC('XCBOracle'));
    final shanameSer = bytesToHex(getSha3ForSC('NameService'));
    final shactn = bytesToHex(getSha3ForSC('CTN'));
    final shadriverLisence = bytesToHex(getSha3ForSC('DriverLicenseVerifier'));
    final shaproofOfAddress = bytesToHex(getSha3ForSC('AddressVerifier'));

    // result is a GetAllContractModel object, in which the first byte array is the shaName and the respective second byte array is the contract address or the string value
    final indexAndroidLink = result.indexOf(shaAndroidLink);
    final androidLink = utf8.decode(rawModel.var2[indexAndroidLink]);
    final indexIOSLink = result.indexOf(shaIOSLink);
    final iosLink = utf8.decode(rawModel.var2[indexIOSLink]);
    final indexIsMaintaining = result.indexOf(shaisMaintaining);
    final isMaintaining = utf8.decode(rawModel.var2[indexIsMaintaining]);
    final indexLatestVersion = result.indexOf(shalatestVersion);
    final latestVersion = utf8.decode(rawModel.var2[indexLatestVersion]);
    final indexMinVersion = result.indexOf(shaminVersion);
    final minVersion = utf8.decode(rawModel.var2[indexMinVersion]);
    final indexEmailAddress = result.indexOf(shaemailAddress);
    final emailAddress = utf8.decode(rawModel.var2[indexEmailAddress]);
    final indexIdCardVerif = result.indexOf(shaidCardVerif);
    final idCardAddress = utf8.decode(rawModel.var2[indexIdCardVerif]);
    final indexKycTransmitter = result.indexOf(shakycTransmitter);
    final kycTransmitterAddress = utf8.decode(rawModel.var2[indexKycTransmitter]);
    final indexPassport = result.indexOf(shapassport);
    final passportAddress = utf8.decode(rawModel.var2[indexPassport]);
    final indexPhone = result.indexOf(shaphone);
    final phoneAddress = utf8.decode(rawModel.var2[indexPhone]);
    final indexResidence = result.indexOf(sharesidence);
    final residenceAddress = utf8.decode(rawModel.var2[indexResidence]);
    final indexCtnOracle = result.indexOf(shactnOracle);
    final ctnOracleAddress = utf8.decode(rawModel.var2[indexCtnOracle]);
    final indexKycVault = result.indexOf(shakycVault);
    final kycVaultAddress = utf8.decode(rawModel.var2[indexKycVault]);
    final indexXcbOracle = result.indexOf(shaxcbOracle);
    final xcbOracleAddress = utf8.decode(rawModel.var2[indexXcbOracle]);
    final indexNameService = result.indexOf(shanameSer);
    final nameServiceAddress = utf8.decode(rawModel.var2[indexNameService]);
    final indexCtn = result.indexOf(shactn);
    final cTNAddress = utf8.decode(rawModel.var2[indexCtn]);
    final indexDriverLicense = result.indexOf(shadriverLisence);
    final driverLicenseAddress = utf8.decode(rawModel.var2[indexDriverLicense]);
    final indexProofOfAddress = result.indexOf(shaproofOfAddress);
    final proofOfAddressAddress = utf8.decode(rawModel.var2[indexProofOfAddress]);

    return RegistryInfoModel(
      proofOfAddressAddress: XCBAddress.fromHex(proofOfAddressAddress).hexNo0x,
      phoneAddress: XCBAddress.fromHex(phoneAddress).hexNo0x,
      idCardAddress: XCBAddress.fromHex(idCardAddress).hexNo0x,
      passportAddress: XCBAddress.fromHex(passportAddress).hexNo0x,
      driverLicenseAddress: XCBAddress.fromHex(driverLicenseAddress).hexNo0x,
      residenceAddress: XCBAddress.fromHex(residenceAddress).hexNo0x,
      emailAddress: XCBAddress.fromHex(emailAddress).hexNo0x,
      kycTransmitterAddress: XCBAddress.fromHex(kycTransmitterAddress).hexNo0x,
      kycVaultAddress: XCBAddress.fromHex(kycVaultAddress).hexNo0x,
      xcbOracleAddress: XCBAddress.fromHex(xcbOracleAddress).hexNo0x,
      nameServiceAddress: XCBAddress.fromHex(nameServiceAddress).hexNo0x,
      ctnOracleAddress: XCBAddress.fromHex(ctnOracleAddress).hexNo0x,
      cTNAddress: XCBAddress.fromHex(cTNAddress).hexNo0x,
      androidLink: androidLink,
      iosLink: iosLink,
      isMaintaining: isMaintaining,
      latestVersion: latestVersion,
      minVersion: minVersion,
    );
  }

  final String phoneAddress;
  final String idCardAddress;
  final String passportAddress;
  final String driverLicenseAddress;
  final String proofOfAddressAddress;
  final String residenceAddress;
  final String emailAddress;
  final String kycTransmitterAddress;
  final String kycVaultAddress;
  final String ctnOracleAddress;
  final String xcbOracleAddress;
  final String nameServiceAddress;
  final String cTNAddress;
  final String androidLink;
  final String iosLink;
  final String isMaintaining;
  final String latestVersion;
  final String minVersion;

  toJSON() => {
        'phoneAddress': phoneAddress,
        'proofOfAddressAddress': proofOfAddressAddress,
        'idCardAddress': idCardAddress,
        'passportAddress': passportAddress,
        'driverLicenseAddress': driverLicenseAddress,
        'residenceAddress': residenceAddress,
        'emailAddress': emailAddress,
        'kycTransmitterAddress': kycTransmitterAddress,
        'kycVaultAddress': kycVaultAddress,
        'ctnOracleAddress': ctnOracleAddress,
        'xcbOracleAddress': xcbOracleAddress,
        'nameServiceAddress': nameServiceAddress,
        'cTNAddress': cTNAddress,
        'androidLink': androidLink,
        'iosLink': iosLink,
        'isMaintaining': isMaintaining,
        'latestVersion': latestVersion,
        'minVersion': minVersion,
      };
}

Uint8List getSha3ForSC(String name) {
  return sha3_256(Uint8List.fromList(utf8.encode(name)));
}
