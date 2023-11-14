import 'dart:convert';
import 'dart:typed_data';

import 'package:core_web3dart/crypto.dart';
import 'package:core_web3dart/web3dart.dart';
import 'package:heyo/app/modules/shared/data/models/get_all_contract_model.dart';

class RegistryInfoModel {
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
      proofOfAddressAddress: json["proofOfAddressAddress"].toString(),
      phoneAddress: json["phoneAddress"].toString(),
      idCardAddress: json["idCardAddress"].toString(),
      passportAddress: json["passportAddress"].toString(),
      driverLicenseAddress: json["driverLicenseAddress"].toString(),
      residenceAddress: json["residenceAddress"].toString(),
      emailAddress: json["emailAddress"].toString(),
      kycTransmitterAddress: json["kycTransmitterAddress"].toString(),
      kycVaultAddress: json["kycVaultAddress"].toString(),
      ctnOracleAddress: json["ctnOracleAddress"].toString(),
      xcbOracleAddress: json["xcbOracleAddress"].toString(),
      nameServiceAddress: json["nameServiceAddress"].toString(),
      cTNAddress: json["cTNAddress"].toString(),
      androidLink: json["androidLink"].toString(),
      iosLink: json["iosLink"].toString(),
      isMaintaining: json["isMaintaining"].toString(),
      latestVersion: json["latestVersion"].toString(),
      minVersion: json["minVersion"].toString(),
    );
  }

  toJSON() => {
        "phoneAddress": phoneAddress,
        "proofOfAddressAddress": proofOfAddressAddress,
        "idCardAddress": idCardAddress,
        "passportAddress": passportAddress,
        "driverLicenseAddress": driverLicenseAddress,
        "residenceAddress": residenceAddress,
        "emailAddress": emailAddress,
        "kycTransmitterAddress": kycTransmitterAddress,
        "kycVaultAddress": kycVaultAddress,
        "ctnOracleAddress": ctnOracleAddress,
        "xcbOracleAddress": xcbOracleAddress,
        "nameServiceAddress": nameServiceAddress,
        "cTNAddress": cTNAddress,
        "androidLink": androidLink,
        "iosLink": iosLink,
        "isMaintaining": isMaintaining,
        "latestVersion": latestVersion,
        "minVersion": minVersion,
      };

  factory RegistryInfoModel.fromContractModel(GetAllContractModel result) {
    final shaAndroidLink = bytesToHex(getSha3ForSC("androidLink"));
    final shaIOSLink = bytesToHex(getSha3ForSC("iosLink"));
    final shaisMaintaining = bytesToHex(getSha3ForSC("isMaintaining"));
    final shalatestVersion = bytesToHex(getSha3ForSC("latestVersion"));
    final shaminVersion = bytesToHex(getSha3ForSC("minVersion"));
    final shaemailAddress = bytesToHex(getSha3ForSC("EmailVerifier"));
    final shaidCardVerif = bytesToHex(getSha3ForSC("IDCardVerifier"));
    final shakycTransmitter = bytesToHex(getSha3ForSC("KYCTransmitter"));
    final shapassport = bytesToHex(getSha3ForSC("PassportVerifier"));
    final shaphone = bytesToHex(getSha3ForSC("PhoneVerifier"));
    final sharesidence = bytesToHex(getSha3ForSC("ResidencePermitVerifier"));
    final shactnOracle = bytesToHex(getSha3ForSC("CTNOracle"));
    final shakycVault = bytesToHex(getSha3ForSC("KYCVault"));
    final shaxcbOracle = bytesToHex(getSha3ForSC("XCBOracle"));
    final shanameSer = bytesToHex(getSha3ForSC("NameService"));
    final shactn = bytesToHex(getSha3ForSC("CTN"));
    final shadriverLisence = bytesToHex(getSha3ForSC("DriverLicenseVerifier"));
    final shaproofOfAddress = bytesToHex(getSha3ForSC("AddressVerifier"));

    // result is a GetAllContractModel object, in which the first byte array is the shaName and the respective second byte array is the contract address or the string value
    final indexAndroidLink = result.var1.indexOf(shaAndroidLink);
    final androidLink = utf8.decode(result.var2[indexAndroidLink]);
    final indexIOSLink = result.var1.indexOf(shaIOSLink);
    final iosLink = utf8.decode(result.var2[indexIOSLink]);
    final indexIsMaintaining = result.var1.indexOf(shaisMaintaining);
    final isMaintaining = utf8.decode(result.var2[indexIsMaintaining]);
    final indexLatestVersion = result.var1.indexOf(shalatestVersion);
    final latestVersion = utf8.decode(result.var2[indexLatestVersion]);
    final indexMinVersion = result.var1.indexOf(shaminVersion);
    final minVersion = utf8.decode(result.var2[indexMinVersion]);
    final indexEmailAddress = result.var1.indexOf(shaemailAddress);
    final emailAddress = utf8.decode(result.var2[indexEmailAddress]);
    final indexIdCardVerif = result.var1.indexOf(shaidCardVerif);
    final idCardAddress = utf8.decode(result.var2[indexIdCardVerif]);
    final indexKycTransmitter = result.var1.indexOf(shakycTransmitter);
    final kycTransmitterAddress = utf8.decode(result.var2[indexKycTransmitter]);
    final indexPassport = result.var1.indexOf(shapassport);
    final passportAddress = utf8.decode(result.var2[indexPassport]);
    final indexPhone = result.var1.indexOf(shaphone);
    final phoneAddress = utf8.decode(result.var2[indexPhone]);
    final indexResidence = result.var1.indexOf(sharesidence);
    final residenceAddress = utf8.decode(result.var2[indexResidence]);
    final indexCtnOracle = result.var1.indexOf(shactnOracle);
    final ctnOracleAddress = utf8.decode(result.var2[indexCtnOracle]);
    final indexKycVault = result.var1.indexOf(shakycVault);
    final kycVaultAddress = utf8.decode(result.var2[indexKycVault]);
    final indexXcbOracle = result.var1.indexOf(shaxcbOracle);
    final xcbOracleAddress = utf8.decode(result.var2[indexXcbOracle]);
    final indexNameService = result.var1.indexOf(shanameSer);
    final nameServiceAddress = utf8.decode(result.var2[indexNameService]);
    final indexCtn = result.var1.indexOf(shactn);
    final cTNAddress = utf8.decode(result.var2[indexCtn]);
    final indexDriverLicense = result.var1.indexOf(shadriverLisence);
    final driverLicenseAddress = utf8.decode(result.var2[indexDriverLicense]);
    final indexProofOfAddress = result.var1.indexOf(shaproofOfAddress);
    final proofOfAddressAddress = utf8.decode(result.var2[indexProofOfAddress]);

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
}

Uint8List getSha3ForSC(String name) {
  return sha3_256(Uint8List.fromList(utf8.encode(name)));
}
