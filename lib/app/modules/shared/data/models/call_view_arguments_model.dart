import 'package:heyo/app/modules/calls/shared/data/models/call_user_model.dart';

class CallViewArgumentsModel {
  final bool enableVideo;
  final String? callId;
  final bool isAudioCall;
  final List<String> members;

  CallViewArgumentsModel({
    required this.callId,
    this.enableVideo = false,
    required this.isAudioCall,
    required this.members,
  });
}
