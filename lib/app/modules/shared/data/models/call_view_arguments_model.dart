class CallViewArgumentsModel {

  CallViewArgumentsModel({
    required this.callId,
    required this.isAudioCall, required this.members,
  });
  final String? callId;
  final bool isAudioCall;
  final List<String> members;
}
