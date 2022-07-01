class UserContact {
  String coreId;
  String nickName;
  String icon;

  UserContact({
    required this.coreId,
    required this.nickName,
    required this.icon,
  });

  factory UserContact.fromJson(Map<String, dynamic> json) => UserContact(
        coreId: json["coreId"],
        nickName: json["nickName"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "coreId": coreId,
        "nickName": nickName,
        "icon": icon,
      };
}
