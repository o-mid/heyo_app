class CallViewArgumentsModel {

  CallViewArgumentsModel({
    required this.callId,
    required this.isAudioCall, required this.members, this.enableVideo = false,
  });
  final bool enableVideo;
  final String? callId;
  final bool isAudioCall;
  final List<String> members;
}
