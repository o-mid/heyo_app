import 'package:heyo/app/modules/chats/data/models/chat_model.dart';

class UserModel {
  String name;
  String icon;
  String walletAddress;
  String Nickname;
  bool isOnline;
  bool isVerified;
  ChatModel chatModel;
  bool isContact;

  UserModel({
    required this.name,
    required this.icon,
    required this.walletAddress,
    this.isContact = false,
    this.isOnline = false,
    this.isVerified = false,
    this.Nickname = "",
    required this.chatModel,
  });
}
