class UserModel {
  String name;
  String icon;
  String walletAddress;
  bool isOnline;
  bool isVerified;

  UserModel({
    required this.name,
    required this.icon,
    required this.walletAddress,
    this.isOnline = false,
    this.isVerified = false,
  });
}
