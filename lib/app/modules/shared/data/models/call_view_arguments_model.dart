import 'package:heyo/app/modules/calls/shared/data/models/call_user_model.dart';

class CallViewArgumentsModel {
  final CallUserModel user;
  final bool enableVideo;
  final String? callId;
  final bool isAudioCall;

  CallViewArgumentsModel({
    required this.user,
    required this.callId,
    this.enableVideo = false,
    required this.isAudioCall,
  });
}
