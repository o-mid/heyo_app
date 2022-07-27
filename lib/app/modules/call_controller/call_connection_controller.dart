import 'package:get/get.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';
import 'package:heyo/app/modules/web-rtc/signaling.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallConnectionController extends GetxController {
  final Signaling signaling;
  final AccountInfo accountInfo;
  Rx<CallState?> callState = Rxn<CallState>();
  Rx<MediaStream?> remoteStream = Rxn<MediaStream>();
  Rx<MediaStream?> removeStream = Rxn<MediaStream>();
  Rx<MediaStream?> localStream = Rxn<MediaStream>();

  MediaStream? _localStream;

  @override
  void onInit() {
    init();
  }

  MediaStream? getLocalStream() => _localStream;

  Future<void> init() async {
    signaling.onLocalStream = ((stream) {
      _localStream = stream;
      localStream.value = stream;
    });

    observeCallStatus();
  }

  void observeCallStatus() {
    signaling.onCallStateChange = (session, state) async {
      callState.value = state;

      print("Call State changed, state is: $state");

      if (state == CallState.callStateRinging) {
        Get.toNamed(Routes.INCOMING_CALL,
            arguments: IncomingCallViewArguments(
                session: session,
                callId: "",
                sdp: session.sid,
                remoteCoreId: session.cid,
                remotePeerId: session.pid!));
      } else if (state == CallState.callStateBye) {
        if (Get.currentRoute == Routes.CALL) {
          Get.until((route) => Get.currentRoute != Routes.CALL);
        } else if (Get.currentRoute == Routes.INCOMING_CALL) {
          Get.until((route) => Get.currentRoute != Routes.INCOMING_CALL);
        }
      }
    };
    signaling.onAddRemoteStream = (session, stream) async {
      remoteStream.value = stream;
    };
    signaling.onRemoveRemoteStream = (session, stream) async {
      removeStream.value = stream;
    };
  }

  CallConnectionController({required this.signaling, required this.accountInfo});

  Future<Session> startCall(String remoteId, String callId, bool isAudioCall) async {
    String? selfCoreId = await accountInfo.getCoreId();
    return await signaling.invite(remoteId, 'video', false, selfCoreId!, isAudioCall);
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

  void showLocalVideoStream(bool value, String? sessionId, bool changeCallState) {
    signaling.showLocalVideoStream(value);
    if (changeCallState == true && sessionId != null) {
      if (value == true) {
        signaling.peerOpendCamera(sessionId);
      } else {
        signaling.peerClosedCamera(sessionId);
      }
    }
  }

  void rejectCall(String sessionId) {
    signaling.reject(sessionId);
  }

  void close() {
    signaling.close();
    localStream.value = null;
  }
}
