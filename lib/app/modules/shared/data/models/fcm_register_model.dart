class FCMRegisterModel {
  final String fcmToken;
  final String signature;

  FCMRegisterModel({required this.fcmToken, required this.signature});
  toJson() => {"fcmToken": fcmToken, "signature": signature};
}