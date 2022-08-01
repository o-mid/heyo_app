import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/web-rtc/signaling.dart';

class CallViewArgumentsModel {
  final UserModel user;
  final bool enableVideo;
  final Session? session;
  final String? callId;
  final bool isAudioCall;

  CallViewArgumentsModel({
    required this.session,
    required this.user,
    required this.callId,
    this.enableVideo = false,
    required this.isAudioCall,
  });
}
