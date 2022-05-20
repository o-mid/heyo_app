import 'package:heyo/app/modules/chats/data/models/chat_model.dart';

class UserModel {
  String name;
  String icon;
  String walletAddress;
  String nickname;
  bool isOnline;
  bool isVerified;
  ChatModel? chatModel;

  UserModel({
    required this.name,
    required this.icon,
    required this.walletAddress,
    this.isOnline = false,
    this.isVerified = false,
    this.nickname = "",
    this.chatModel,
  });
}
