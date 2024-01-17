class IncomingCallViewArguments {
  final String callId;
  final bool isAudioCall;
  final List<String> members;

  IncomingCallViewArguments({
    required this.callId,
    required this.isAudioCall,
    required this.members,
  });
}
