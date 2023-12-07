import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/domain/call_repository.dart';
import 'package:heyo/app/modules/calls/domain/models.dart';
import 'package:heyo/app/modules/calls/shared/data/models/all_participant_model/all_participant_model.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_user_model.dart';
import 'package:heyo/app/modules/calls/shared/data/models/connected_participant_model/connected_participant_model.dart';
import 'package:heyo/app/modules/calls/shared/data/models/local_participant_model/local_participant_model.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';
import 'package:heyo/app/modules/shared/data/models/messages_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/repository/crypto_account/account_repository.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
//import 'package:heyo/app/modules/web-rtc/signaling.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:wakelock/wakelock.dart';

//enum CallViewType {
//  stack,
//  column,
//  row,
//}

class CallController extends GetxController {
  CallController({
    required this.callRepository,
    required this.accountInfo,
  });

  final CallRepository callRepository;
  final AccountRepository accountInfo;

  //* CallViewArgumentsModel will not effect the UI
  late CallViewArgumentsModel args;

  RxList<ConnectedParticipantModel> connectedRemoteParticipates =
      RxList<ConnectedParticipantModel>();

  Rx<LocalParticipantModel?> localParticipate = Rx(null);

  RxList<AllParticipantModel> participants = RxList<AllParticipantModel>();

  final isImmersiveMode = false.obs;

  final isInCall = false.obs;

  final isVideoPositionsFlipped = false.obs;

  RxBool get isGroupCall => (connectedRemoteParticipates.length > 1).obs;

  final Stopwatch stopwatch = Stopwatch();
  Timer? callTimer;

  //final micEnabled = true.obs;
  //final callerVideoEnabled = false.obs;
  //final isInCall = true.obs;
  //final calleeVideoEnabled = true.obs;
  //final callDurationSeconds = 0.obs;
  //final callViewType = CallViewType.stack.obs;
  //late Session session;

  RxList<ConnectedParticipantModel> getAllConnectedParticipate() {
    //* Use this item for group call
    //* The first video renderer is the local Renderer,
    return RxList([
      localParticipate.value!.mapToConnectedParticipantModel(),
      ...connectedRemoteParticipates,
    ]);
  }

  String getConnectedParticipantsName() {
    //* This item will loop all call connected user
    //* Return their name as string and split them with comma
    return connectedRemoteParticipates
        .map((element) => element.name)
        .toList()
        .join(', ');
  }

  Future<void> initLocalRenderer() async {
    final localParticipateCoreId = await accountInfo.getUserAddress();
    localParticipate.value = LocalParticipantModel(
      name: localParticipateCoreId!.shortenCoreId,
      iconUrl: 'https://avatars.githubusercontent.com/u/7847725?v=4',
      coreId: localParticipateCoreId,
      // TODO(AliAzim): audio & video mode should be get from the call.
      audioMode: true.obs,
      videoMode: true.obs,
      callDurationInSecond: 0.obs,
      frondCamera: true.obs,
    );

    if (localParticipate.value!.videoMode.isTrue) {
      final localRenderer = RTCVideoRenderer();
      await localRenderer.initialize();

      localParticipate.value =
          localParticipate.value!.copyWith(rtcVideoRenderer: localRenderer);

      callRepository.onLocalStream = (stream) {
        localRenderer.srcObject = stream;
        updateCallerVideoWidget();
      };
    }
  }

  void message() {
    //TODO shoud passed correct coreId
    Get.toNamed(
      Routes.MESSAGES,
      arguments: MessagesViewArgumentsModel(
        coreId: '',
        iconUrl: '',
        connectionType: MessagingConnectionType.internet,
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    args = Get.arguments as CallViewArgumentsModel;
    initCall();
  }

  void startCallTimer() {
    stopwatch.start();
    callTimer = Timer.periodic(const Duration(seconds: 1), onCallTick);
  }

  void onCallTick(Timer timer) {
    localParticipate.value!.callDurationInSecond.value =
        stopwatch.elapsed.inSeconds;
  }

  void stopCallTimer() {
    callTimer?.cancel();
    stopwatch.stop();
  }

  Future<void> initCall() async {
    await initLocalRenderer();

    observeOnChangeParticipate();

    /*final callStreams = await callRepository.getCallStreams();
    debugPrint('onAddCallStream Callee Set: ${callStreams.length}');
    _applyCallStreams(callStreams);*/
    observeSignalingStreams();

    if (args.callId == null) {
      //* This means you start the call (you are caller)
      await startCalling();
    } else {
      //* This mean you join the call (You are callee)
      await inCallSetUp();
    }

    if (callRepository.getLocalStream() != null) {
      localParticipate.value!.rtcVideoRenderer!.srcObject =
          callRepository.getLocalStream();
    }
    print("Call type ${(args.isAudioCall)}");
    if (args.isAudioCall) {
      //callerVideoEnabled.value = false;
      //calleeVideoEnabled.value = false;
      callRepository.showLocalVideoStream(false, '', false);
    }

    //* adding participate into bottom sheet
    // TODO(AliAzim): This list will be change in future
    for (final element in args.members) {
      // TODO(AliAzim): should be check isContact or not
      participants.add(
        AllParticipantModel(
          name: element.shortenCoreId,
          coreId: element.shortenCoreId,
          iconUrl: 'https://avatars.githubusercontent.com/u/7847725?v=4',
        ),
      );
    }

    updateCallerVideoWidget();
    observeCallStates();
    await enableWakeScreenLock();
  }

  void _applyCallStreams(List<CallStream> callStreams) {
    for (final element in callStreams) {
      addRTCRenderer(element);
    }
  }

  late String requestedCallId;

  Future<void> startCalling() async {
    requestedCallId = await callRepository.startCall(
      args.members.first,
      args.isAudioCall,
    );

    isInCall.value = false;
    _playWatingBeep();
  }

  Future<void> addRTCRenderer(CallStream callStream) async {
    // TODO(AliAzim): condition should be add to check if video is enable or not
    final renderer = RTCVideoRenderer();
    await renderer.initialize();
    renderer.srcObject = callStream.remoteStream;
    //_remoteRenderers.add(renderer);
    //TODO: The data should return from CallStream,
    // or input of method should be CallItemModel
    final remoteParticipate = ConnectedParticipantModel(
      audioMode: true.obs,
      videoMode: true.obs,
      coreId: callStream.coreId,
      name: callStream.coreId.shortenCoreId,
      iconUrl: 'https://avatars.githubusercontent.com/u/6645136?v=4',
      stream: callStream.remoteStream,
      rtcVideoRenderer: renderer,
    );
    connectedRemoteParticipates.add(remoteParticipate);
    //updateCalleeVideoWidget();
  }

  Future<void> inCallSetUp() async {
     await callRepository.acceptCall(args.callId!);
    //* I move mock in controller to pass callId

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
    callRepository.onChangeParticipateStream = (participant) {
      debugPrint('Change participate observer in Call Controller...');
      //debugPrint(participant.toString());
      participants.add(participant);
    };
  }

  void observeSignalingStreams() {
    //todo remove stream logic!
    /* callRepository.onRemoveRemoteStream =((stream){
      _remoteRenderers.srcObject = null;
    });*/
    callRepository.onAddCallStream = (callStateView) {
      debugPrint('onAddCallStream : $callStateView');
      //print("calll ${_remoteRenderers} : $stream");
      //TODO refactor this if related to the call state
      if (!isInCall.value) {
        isInCall.value = true;
        _stopWatingBeep();
        startCallTimer();
      }

      addRTCRenderer(callStateView);
    };
  }

  // Todo
  void toggleMuteMic() {
    callRepository.muteMic();
    localParticipate.value!.audioMode.value =
        !localParticipate.value!.audioMode.value;
    //micEnabled.value = !micEnabled.value;
  }

  // Todo
  void toggleMuteCall() {}

  Future<void> endCall() async {
    if (args.callId == null) {
      await callRepository.endOrCancelCall(requestedCallId);
    } else {
      await callRepository.endOrCancelCall(args.callId!);
    }
    _stopWatingBeep();
    Get.back();
  }

  void pushToAddParticipate() => Get.toNamed(Routes.ADD_PARTICIPATE);

  Future<void> addParticipant(List<AllParticipantModel> selectedUsers) async {
    for (final element in selectedUsers) {
      debugPrint(element.coreId);

      await callRepository.addMember(element.coreId);
    }
  }

  // Todo
  void toggleVideo() {
    //callerVideoEnabled.value = !callerVideoEnabled.value;
    localParticipate.value!.videoMode.value =
        !localParticipate.value!.videoMode.value;
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

  //void updateCallViewType(CallViewType type) => callViewType.value = type;

  void flipVideoPositions() =>
      isVideoPositionsFlipped.value = !isVideoPositionsFlipped.value;

  Future<void> disposeRTCRender() async {
    for (var participate in connectedRemoteParticipates) {
      if (participate.rtcVideoRenderer != null) {
        await participate.rtcVideoRenderer!.dispose();
      }
    }
  }

  @override
  Future<void> onClose() async {
    stopCallTimer();

    await callRepository.closeCall();
    await localParticipate.value!.rtcVideoRenderer!.dispose();
    await disposeRTCRender();
    _stopWatingBeep();
    await disableWakeScreenLock();
  }

  void reorderParticipants(int oldIndex, int newIndex) {
    final p = participants.removeAt(oldIndex);
    participants.insert(newIndex, p);
  }

  final String calleeVideoWidgetId = 'callee';
  final String callerVideoWidgetId = 'caller';

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
    //updateCallViewType(CallViewType.stack);
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
      name: '',
      iconUrl: 'https://avatars.githubusercontent.com/u/6645136?v=4',
      walletAddress: args.members.first,
      coreId: args.members.first,
    );
  }
}
