import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:ed_screen_recorder/ed_screen_recorder.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/domain/models.dart';
import 'package:heyo/app/modules/calls/main/data/models/call_participant_model.dart';
import 'package:heyo/app/modules/calls/main/widgets/record_call_dialog.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_user_model.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';
import 'package:heyo/app/modules/shared/data/models/messages_view_arguments_model.dart';
//import 'package:heyo/app/modules/web-rtc/signaling.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock/wakelock.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/app/modules/calls/domain/call_repository.dart';

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
  final CallRepository callRepository;

  //late Session session;
  final Stopwatch stopwatch = Stopwatch();
  Timer? calltimer;

  CallController({required this.callRepository});

  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RxList<RTCVideoRenderer> videoRenderers = RxList();

  RTCVideoRenderer getLocalVideRenderer() {
    return _localRenderer;
  }

  RxList<RTCVideoRenderer> getRemoteVideoRenderers() {
    return videoRenderers;
  }

  initRenderers() async {
    await _localRenderer.initialize();
    //await _remoteRenderers.initialize();
  }

  final _screenRecorder = EdScreenRecorder();

  void message() {
    //TODO shoud passed correct coreId
    Get.toNamed(
      Routes.MESSAGES,
      arguments: MessagesViewArgumentsModel(
          coreId: "",
          iconUrl: "",
          connectionType: MessagingConnectionType.internet),
    );
  }

  @override
  void onInit() {
    super.onInit();
    args = Get.arguments as CallViewArgumentsModel;
    callerVideoEnabled.value = args.enableVideo;
    setUp();
    args.members.forEach((element) {
      //TODO should be check isContact or not
      participants.add(
        CallParticipantModel(
          name: element,
          coreId: element,
          iconUrl: "",
        ),
      );
    });
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
    observeOnChangeParticipate();

    callRepository.onLocalStream = ((stream) {
      _localRenderer.srcObject = stream;

      updateCallerVideoWidget();
    });

    if (args.callId == null) {
      await callerSetup();
    } else {
      await calleeSetup();
    }

    if (callRepository.getLocalStream() != null) {
      _localRenderer.srcObject = callRepository.getLocalStream();
    }

    if (args.isAudioCall) {
      callerVideoEnabled.value = false;
      calleeVideoEnabled.value = false;
      callRepository.showLocalVideoStream(false, "", false);
    }
    updateCallerVideoWidget();
    observeCallStates();
    enableWakeScreenLock();
  }

  late String requestedCallId;

  Future callerSetup() async {
    requestedCallId =
        (await callRepository.startCall(args.members.first, args.isAudioCall));

    isInCall.value = false;
    _playWatingBeep();
  }

  addRTCRenderer(CallStream callStream) async {
    RTCVideoRenderer renderer = RTCVideoRenderer();
    await renderer.initialize();
    renderer.srcObject = callStream.remoteStream;
    videoRenderers.add(renderer);
    updateCalleeVideoWidget();
  }

  Future calleeSetup() async {
    await callRepository.acceptCall(args.callId!);

    List<CallStream> callStreams = await callRepository.getCallStreams();
    print("onAddCallStream Callee Set: ${callStreams.length}");

    for (var element in callStreams) {
      addRTCRenderer(element);
    }

    isInCall.value = true;
    startCallTimer();
  }

  void observeCallStates() {
    //TODO it requires another logic
    /* callRepository.callState.listen((state) {
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
    });*/
  }

  void observeOnChangeParticipate() {
    callRepository.onChangeParticipateStream = ((participates) {
      print("SAAAAAAAG");
      debugPrint(participates.toString());
    });
  }

  void observeSignalingStreams() {
    //todo remove stream logic!
    /* callRepository.onRemoveRemoteStream =((stream){
      _remoteRenderers.srcObject = null;
    });*/
    callRepository.onAddCallStream = ((callStateView) {
      print("onAddCallStream : ${callStateView}");
      //print("calll ${_remoteRenderers} : $stream");
      //TODO refactor this if related to the call state
      if (!isInCall.value) {
        isInCall.value = true;
        _stopWatingBeep();
        startCallTimer();
      }

      addRTCRenderer(callStateView);
    });
  }

  // Todo
  void toggleMuteMic() {
    callRepository.muteMic();
    micEnabled.value = !micEnabled.value;
  }

  // Todo
  void toggleMuteCall() {}

  void endCall() async {
    if (args.callId == null) {
      await callRepository.endOrCancelCall(requestedCallId);
    } else {
      await callRepository.endOrCancelCall(args.callId!);
    }
    _stopWatingBeep();
    Get.back();
  }

  void pushToAddParticipate() => Get.toNamed(Routes.ADD_PARTICIPATE);

  //void addParticipant(List<ParticipateItem> selectedUsers) {
  //  for (var element in selectedUsers) {
  //    debugPrint(element.coreId);
  //    participants.add(
  //      CallParticipantModel(user: element.mapToCallUserModel()),
  //    );
  //    callRepository.addMember(element.coreId);
  //  }
  //}

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
    callRepository.switchCamera();
  }

  //* Mock for incoming call
  void incomingMock() {
    Get.toNamed(
      Routes.INCOMING_CALL,
      arguments: IncomingCallViewArguments(
        callId: "args.callId!",
        isAudioCall: args.isAudioCall,
        members: args.members,
      ),
    );
  }

  void toggleImmersiveMode() {
    isImmersiveMode.value = !isImmersiveMode.value;
  }

  void updateCallViewType(CallViewType type) => callViewType.value = type;

  void flipVideoPositions() =>
      isVideoPositionsFlipped.value = !isVideoPositionsFlipped.value;

  Future<void> disposeRTCRender() async {
    for (var element in videoRenderers) {
      await element.dispose();
    }
  }

  @override
  void onClose() async {
    stopCallTimer();

    await callRepository.closeCall();
    await _localRenderer.dispose();
    await disposeRTCRender();
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

  //TODO Call
  CallUserModel getMockUser() {
    return CallUserModel(
      name: "",
      iconUrl: "https://avatars.githubusercontent.com/u/6645136?v=4",
      walletAddress: args.members.first,
      coreId: args.members.first,
    );
  }
}
