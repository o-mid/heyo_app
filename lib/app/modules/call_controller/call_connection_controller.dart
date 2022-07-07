import 'package:get/get.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';
import 'package:heyo/app/modules/web-rtc/signaling.dart';
import 'package:heyo/app/routes/app_pages.dart';

class CallConnectionController extends GetxController {
  Signaling signaling;
  AccountInfo accountInfo;
  late Rx<CallState?> callState = Rx(null);
  late dynamic localStream;

  @override
  void onInit() async {
    signaling.onLocalStream = ((stream) {
      localStream = stream;
    });

    signaling.onCallStateChange = (session, state) async {
      callState.value = state;

      print("Call State changed, state is: $state");

      if (state == CallState.CallStateRinging) {
        Get.toNamed(Routes.INCOMING_CALL,
            arguments: IncomingCallViewArguments(
                session: session,
                callId: "",
                sdp: session.sid,
                remoteCoreId: session.cid,
                remotePeerId: session.pid!));
      } else if (state == CallState.CallStateBye) {
        if (Get.currentRoute == Routes.CALL) {
          Get.until((route) => Get.currentRoute != Routes.CALL);
        } else if (Get.currentRoute == Routes.INCOMING_CALL) {
          Get.until((route) => Get.currentRoute != Routes.INCOMING_CALL);
        }
      }
    };
  }

  CallConnectionController(
      {required this.signaling, required this.accountInfo});

  Future<Session> startCall(String remoteId, String callId) async {
    String? selfCoreId = await accountInfo.getCoreId();
    return await signaling.invite(remoteId, 'video', false, selfCoreId!);
  }

  Future acceptCall(Session session) async {
    signaling.accept(
      session.sid,
    );
  }

  void switchCamera() {
    signaling.switchCamera();
  }

  void muteMic() {
    signaling.muteMic();
  }

  void rejectCall(String sessionId) {
    signaling.reject(sessionId);
  }

  void close() {
    signaling.close();
    localStream = null;
  }


}
