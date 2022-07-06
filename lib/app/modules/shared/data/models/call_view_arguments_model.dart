import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';

class CallViewArgumentsModel {
  final UserModel user;
  final bool initiateCall;
  final bool enableVideo;
  final String? callId;

  CallViewArgumentsModel({
    required this.user,
    required this.initiateCall,
    required this.callId,
    this.enableVideo = false,
  });
}
