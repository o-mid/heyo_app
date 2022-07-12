import 'dart:async';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:ed_screen_recorder/ed_screen_recorder.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/call_controller/call_connection_controller.dart';
import 'package:heyo/app/modules/calls/main/data/models/call_participant_model.dart';
import 'package:heyo/app/modules/calls/main/widgets/record_call_dialog.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/web-rtc/signaling.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';

enum CallViewType {
  stack,
  column,
  row,
}

enum RecordState {
  notRecording,
  loading,
  recording,
}

class CallController extends GetxController {
  late CallViewArgumentsModel args;
  final participants = <CallParticipantModel>[].obs;

  // Todo: check whether they are actually enabled or not
  final micEnabled = true.obs;
  final callerVideoEnabled = false.obs;

  final isInCall = true.obs;

  final calleeVideoEnabled = true.obs;

  final isImmersiveMode = false.obs;

  final callDurationSeconds = 0.obs;

  // Todo: reset [callViewType] and [isVideoPositionsFlipped] when other user disables video
  final callViewType = CallViewType.stack.obs;

  final isVideoPositionsFlipped = false.obs;

  bool get isGroupCall =>
      participants
          .where((p) => p.status == CallParticipantStatus.inCall)
          .length >
      1;

  final recordState = RecordState.notRecording.obs;
  final CallConnectionController callConnectionController;
  final P2PState p2pState;
  late String sessionId;

  CallController(
      {required this.callConnectionController, required this.p2pState});

  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  RTCVideoRenderer getRemoteVideRenderer() {
    return _remoteRenderer;
  }

  RTCVideoRenderer getLocalVideRenderer() {
    return _localRenderer;
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  final _screenRecorder = EdScreenRecorder();

  @override
  void onInit() {
    super.onInit();
    args = Get.arguments as CallViewArgumentsModel;
    callerVideoEnabled.value = args.enableVideo;

    setUp();

    participants.add(
      CallParticipantModel(user: args.user),
    );
  }

  Future<void> setUp() async {
    await initRenderers();

    observeSignalingStreams();

    callConnectionController.localStream.listen((stream) {
      _localRenderer.srcObject = stream;

      updateCallerVideoWidget();
    });

    if (args.session == null) {
      await callerSetup();
    } else {
      await calleeSetup();
    }

    if (callConnectionController.getLocalStream() != null) {
      _localRenderer.srcObject = callConnectionController.getLocalStream();
    }

    observeCallStates();
  }

  Future callerSetup() async {
    final callId = DateTime.now().millisecondsSinceEpoch.toString();
    Session session = (await callConnectionController.startCall(
        args.user.walletAddress, callId));
    sessionId = session.sid;

    isInCall.value = false;
    _playWatingBeep();
  }

  Future calleeSetup() async {
    sessionId = args.session!.sid;
    await callConnectionController.acceptCall(args.session!);
    args.session?.pc?.getRemoteStreams().forEach((element) {
      _remoteRenderer.srcObject = element;
      updateCalleeVideoWidget();
    });
    isInCall.value = true;
  }

  void observeCallStates() {
    callConnectionController.callState.listen((state) {
      if (state == CallState.callStateConnected) {
        isInCall.value = true;
        _stopWatingBeep();
      } else if (state == CallState.callStateBye) {
        _localRenderer.srcObject = null;
        _remoteRenderer.srcObject = null;
        _stopWatingBeep();
      }
    });
  }

  void observeSignalingStreams() {
    callConnectionController.removeStream.listen((p0) {
      _remoteRenderer.srcObject = null;
    });
    callConnectionController.remoteStream.listen((stream) {
      _remoteRenderer.srcObject = stream;
      updateCalleeVideoWidget();
    });
  }

  // Todo
  void toggleMuteMic() {
    callConnectionController.muteMic();
    micEnabled.value = !micEnabled.value;
  }

  // Todo
  void toggleMuteCall() {}

  void endCall() {
    if (isInCall.value) {
      callConnectionController.signaling.bye(sessionId);
      _stopWatingBeep();
    } else {
      callConnectionController.signaling.reject(sessionId);
      _stopWatingBeep();
    }
    Get.back();
  }

  // Todo
  void addParticipant() {
    participants.add(
      CallParticipantModel(
        user: args.user,
        status: CallParticipantStatus.inCall,
      ),
    );
  }

  void recordCall() {
    Get.dialog(RecordCallDialog(onRecord: () async {
      recordState.value = RecordState.loading;
      var permission = await Permission.storage.request();
      if (!permission.isGranted) {
        recordState.value = RecordState.notRecording;
        return;
      }

      permission = await Permission.microphone.request();
      if (!permission.isGranted) {
        recordState.value = RecordState.notRecording;
        return;
      }
      await _screenRecorder.startRecordScreen(
        fileName: DateFormat('yMMddhhmmss').format(DateTime.now()),
        audioEnable: true,
      );
      recordState.value = RecordState.recording;
    }));
  }

  void stopRecording() async {
    await _screenRecorder.stopRecord();
    recordState.value = RecordState.notRecording;
  }

  // Todo
  void toggleVideo() {
    callerVideoEnabled.value = !callerVideoEnabled.value;
  }

  void switchCamera() {
    callConnectionController.switchCamera();
  }

  void toggleImmersiveMode() {
    isImmersiveMode.value = !isImmersiveMode.value;
  }

  void updateCallViewType(CallViewType type) => callViewType.value = type;

  void flipVideoPositions() =>
      isVideoPositionsFlipped.value = !isVideoPositionsFlipped.value;

  @override
  void onClose() async {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    callConnectionController.close();
    await _screenRecorder.stopRecord();
  }

  void reorderParticipants(int oldIndex, int newIndex) {
    final p = participants.removeAt(oldIndex);
    participants.insert(newIndex, p);
  }

  final String calleeVideoWidgetId = "callee";
  final String callerVideoWidgetId = "caller";
  void updateCalleeVideoWidget() {
    update([calleeVideoWidgetId]);
  }

  void updateCallerVideoWidget() {
    update([callerVideoWidgetId]);
  }

  RxBool showCallerOptions = false.obs;
  void changeCallerOptions() {
    showCallerOptions.value = !showCallerOptions.value;
    updateCallerVideoWidget();
  }

  void _playWatingBeep() {
    FlutterBeep.playSysSound(AndroidSoundIDs.TONE_SUP_CALL_WAITING);
  }

  void _stopWatingBeep() {
    // silent tone
    FlutterBeep.playSysSound(AndroidSoundIDs.TONE_CDMA_CALL_SIGNAL_ISDN_PAT5);
  }
}
