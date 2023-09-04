import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:ed_screen_recorder/ed_screen_recorder.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/call_controller/call_connection_controller.dart';
import 'package:heyo/app/modules/calls/main/data/models/call_participant_model.dart';
import 'package:heyo/app/modules/calls/main/widgets/record_call_dialog.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/messages_view_arguments_model.dart';
import 'package:heyo/app/modules/web-rtc/signaling.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock/wakelock.dart';
import 'package:heyo/app/routes/app_pages.dart';

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
      participants.where((p) => p.status == CallParticipantStatus.inCall).length > 1;

  final recordState = RecordState.notRecording.obs;
  final CallConnectionController callConnectionController;
  //late Session session;
  final Stopwatch stopwatch = Stopwatch();
  Timer? calltimer;

  CallController({required this.callConnectionController});

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

  void message() {
    Get.toNamed(
      Routes.MESSAGES,
      arguments: MessagesViewArgumentsModel(
          coreId: args.user.coreId,
          iconUrl: args.user.iconUrl,
          connectionType: MessagingConnectionType.internet),
    );
  }

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

  void startCallTimer() {
    stopwatch.start();
    calltimer = Timer.periodic(const Duration(seconds: 1), onCallTick);
  }

  void onCallTick(Timer timer) {
    callDurationSeconds.value = stopwatch.elapsed.inSeconds;
  }

  void stopCallTimer() {
    calltimer?.cancel();
    stopwatch.stop();
  }

  Future<void> setUp() async {
    await initRenderers();

    observeSignalingStreams();

    callConnectionController.onLocalStream = ((stream) {
      _localRenderer.srcObject = stream;

      updateCallerVideoWidget();
    });

    if (args.callId == null) {
      await callerSetup();
    } else {
      await calleeSetup();
    }

    if (callConnectionController.getLocalStream() != null) {
      _localRenderer.srcObject = callConnectionController.getLocalStream();
    }

    if (args.isAudioCall) {
      callerVideoEnabled.value = false;
      calleeVideoEnabled.value = false;
      callConnectionController.showLocalVideoStream(false, "", false);
    }
    updateCallerVideoWidget();
    observeCallStates();
    enableWakeScreenLock();
  }

  late String requestedCallId;
  Future callerSetup() async {
    requestedCallId=(await callConnectionController.startCall(
        args.user.walletAddress, args.isAudioCall));

    isInCall.value = false;
    _playWatingBeep();
  }

  Future calleeSetup() async {
    await callConnectionController.acceptCall(args.callId!);

    callConnectionController.getRemoteStreams(args.callId!).forEach((element) {
      _remoteRenderer.srcObject = element;
      updateCalleeVideoWidget();
    });
    isInCall.value = true;
    startCallTimer();
  }

  void observeCallStates() {
    callConnectionController.callState.listen((state) {
      if (state == CallState.callStateConnected) {
        isInCall.value = true;
        _stopWatingBeep();
        startCallTimer();
      } else if (state == CallState.callStateBye) {
        print("call_state : callStateBYE ");

        _stopWatingBeep();
      } else if (state == CallState.callStateOpendCamera) {
        calleeVideoEnabled.value = true;
        updateCalleeVideoWidget();
      } else if (state == CallState.callStateClosedCamera) {
        calleeVideoEnabled.value = false;
        resetCallView();
      }
    });
  }

  void observeSignalingStreams() {
    callConnectionController.removeStream.listen((p0) {
      _remoteRenderer.srcObject = null;
    });
    callConnectionController.onAddRemoteStream = ((stream) {
      print("calll ${_remoteRenderer} : $stream");

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
    if(args.callId==null){
      callConnectionController.endOrCancelCall(requestedCallId);

    }else{
      callConnectionController.endOrCancelCall(args.callId!);

    }
    _stopWatingBeep();
    Get.back();
  }

  // Todo
  void addParticipant() => Get.toNamed(Routes.ADD_PARTICIPATE);

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
    //todo farzam
  //  callConnectionController.showLocalVideoStream(callerVideoEnabled.value, session.sid, true);
  }

  void switchCamera() {
    callConnectionController.switchCamera();
  }

  void toggleImmersiveMode() {
    isImmersiveMode.value = !isImmersiveMode.value;
  }

  void updateCallViewType(CallViewType type) => callViewType.value = type;

  void flipVideoPositions() => isVideoPositionsFlipped.value = !isVideoPositionsFlipped.value;

  @override
  void onClose() async {
    stopCallTimer();

    await callConnectionController.close();
    await _localRenderer.dispose();
    await _remoteRenderer.dispose();
    _stopWatingBeep();
    disableWakeScreenLock();
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

//reset Call View when one peer turn the Video Disabled
  void resetCallView() {
    updateCallViewType(CallViewType.stack);
    isVideoPositionsFlipped.value = false;
  }

  Future<void> enableWakeScreenLock() async {
    await Wakelock.toggle(enable: true);
  }

  Future<void> disableWakeScreenLock() async {
    await Wakelock.toggle(enable: false);
  }

  final Duration callerScaleDuration = const Duration(milliseconds: 200);
  final Duration callerScaleReverseDuration = const Duration(milliseconds: 200);
  final double callColumnViewAspectRatio = 359 / 283;
  final double callRowViewAspectRatio = 175 / 318;
}
