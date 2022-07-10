import 'package:heyo/app/modules/web-rtc/signaling.dart';

class IncomingCallViewArguments {
  final String sdp;
  final String remotePeerId;
  final String remoteCoreId;
  final String callId;
  final Session session;

  IncomingCallViewArguments(
      {required this.session,
      required this.callId,
      required this.sdp,
      required this.remotePeerId,
      required this.remoteCoreId});
}
