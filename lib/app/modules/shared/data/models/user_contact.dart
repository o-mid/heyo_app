class UserContact {
  String coreId;
  String nickName;
  String icon;

  UserContact(
      {required this.coreId, required this.nickName, required this.icon});

  static const _NICK_NAME = "nickName";
  static const _CORE_ID = "coreId";
  static const _ICON = "icon";

  Map<String, dynamic> toMap() {
    return {
      _NICK_NAME: nickName,
      _CORE_ID: coreId,
      _ICON: icon,
    };
  }

  static UserContact fromMap(Map<String, dynamic> map) {
    return UserContact(
        nickName: map[_NICK_NAME], coreId: map[_CORE_ID], icon: map[_ICON]);
  }

  static String nickNameGetSerializeName() {
    return _NICK_NAME;
  }
}
