class UserContact {
  String coreId;
  String nickName;
  String icon;

  UserContact(
      {required this.coreId, required this.nickName, required this.icon});

  static const NICK_NAME = "nickName";
  static const CORE_ID = "coreId";
  static const ICON = "icon";

  Map<String, dynamic> toMap() {
    return {
      NICK_NAME: nickName,
      CORE_ID: coreId,
      ICON: icon,
    };
  }

  static UserContact fromMap(Map<String, dynamic> map) {
    return UserContact(
        nickName: map[NICK_NAME], coreId: map[CORE_ID], icon: map[ICON]);
  }
}
