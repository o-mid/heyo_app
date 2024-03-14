import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_ios_call_kit/entities/call_event.dart';
import 'package:get/get.dart' hide navigator;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/modules/call/data/ios_call_kit/ios_call_kit_provider.dart';
import 'package:heyo/modules/call/data/media_sources.dart';
import 'package:heyo/modules/call/domain/call_repository.dart';
import 'package:heyo/modules/call/domain/models.dart';
import 'package:heyo/app/modules/calls/shared/data/models/all_participant_model/all_participant_model.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_user_model.dart';
import 'package:heyo/app/modules/calls/shared/data/models/connected_participant_model/connected_participant_model.dart';
import 'package:heyo/app/modules/calls/shared/data/models/local_participant_model/local_participant_model.dart';
import 'package:heyo/app/modules/calls/usecase/contact_availability_use_case.dart';
import 'package:heyo/app/modules/calls/usecase/get_contact_user_use_case.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';
import 'package:heyo/app/modules/shared/data/models/messages_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/messaging_participant_model.dart';
import 'package:heyo/app/modules/shared/data/repository/account/account_repository.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:wakelock/wakelock.dart';

//enum CallViewType {
//  stack,
//  column,
//  row,
//}

class CallController extends GetxController with GetTickerProviderStateMixin {
  CallController({
    required this.callRepository,
    required this.accountInfo,
    required this.getContactUserUseCase,
    required this.contactAvailabilityUseCase,
    required this.iOSCallKitProvider,
  });

  final CallRepository callRepository;
  final AccountRepository accountInfo;
  final GetContactUserUseCase getContactUserUseCase;
  final ContactAvailabilityUseCase contactAvailabilityUseCase;
  final CallKitProvider iOSCallKitProvider;

  //* CallViewArgumentsModel will not effect the UI
  late CallViewArgumentsModel args;

  RxList<MediaDeviceInfo> audioOutputs = RxList();
  Rxn<MediaDeviceInfo> selectedAudioOutput = Rxn();

  RxList<ConnectedParticipantModel> connectedRemoteParticipates =
      RxList<ConnectedParticipantModel>();

  Rx<LocalParticipantModel?> localParticipate = Rx(null);

  RxList<AllParticipantModel> participants = RxList<AllParticipantModel>();

  final fullScreenMode = false.obs;

  final isInCall = false.obs;

  final isVideoPositionsFlipped = false.obs;

  RxBool get isGroupCall => (connectedRemoteParticipates.length > 1).obs;

  final Stopwatch stopwatch = Stopwatch();
  Timer? callTimer;

  late final AnimationController animationController;

  final localRenderer = RTCVideoRenderer();

  //final micEnabled = true.obs;
  //final callerVideoEnabled = false.obs;
  //final isInCall = true.obs;
  //final calleeVideoEnabled = true.obs;
  //final callDurationSeconds = 0.obs;
  //final callViewType = CallViewType.stack.obs;
  //late Session session;

  //RxList<ConnectedParticipantModel> getAllConnectedParticipate() {
  //  //* Use this item for group call
  //  //* The first video renderer is the local Renderer,
  //  return RxList([
  //    localParticipate.value!.mapToConnectedParticipantModel(),
  //    ...connectedRemoteParticipates,
  //  ]);
  //}

  String getConnectedParticipantsName() {
    //* This item will loop all call connected user
    //* Return their name as string and split them with comma
    return connectedRemoteParticipates
        .map((element) => element.name)
        .toList()
        .join(', ');
  }

  Future<void> initLocalRenderer() async {
    await localRenderer.initialize();

    final localParticipateCoreId = await accountInfo.getUserAddress();
    localParticipate.value = LocalParticipantModel(
      name: localParticipateCoreId!.shortenCoreId,
      coreId: localParticipateCoreId,
      // TODO(AliAzim): audio & video mode should be get from the call.
      audioMode: true.obs,
      videoMode: (!args.isAudioCall).obs,
      callDurationInSecond: 0.obs,
      frondCamera: true.obs,
      rtcVideoRenderer: localRenderer,
    );

    if (callRepository.getLocalStream() != null) {
      _applyLocalStream(callRepository.getLocalStream()!);
    }
    callRepository.onLocalStream = _applyLocalStream;
  }

  void _applyLocalStream(MediaStream stream) {
    localParticipate.value!.rtcVideoRenderer!.srcObject = stream;
    updateCallerVideoWidget();
    callRepository.showLocalVideoStream(!args.isAudioCall, false);
  }

  void message() {
    Get.toNamed(
      Routes.MESSAGES,
      arguments: MessagesViewArgumentsModel(
        connectionType: MessagingConnectionType.internet,
        participants: [
          MessagingParticipantModel(
            coreId: args.members.first,
            chatId: args.members.first,
          ),
        ],
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    args = Get.arguments as CallViewArgumentsModel;
    initCall();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    if (Platform.isIOS){

      iOSCallKitProvider.onCallKitNewEvent = (event) {

        debugPrint('➡️ CallController: onCallKitNewEvent');
        switch (event.event) {
          case Event.actionCallEnded:
            endCall();
          case Event.actionCallToggleMute:
          // TODO: only iOS
            toggleMuteMic();
          default:
        }
      };
    }

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
    // check isAudioCall for toggle show video
    await initLocalRenderer();

    if (args.callId == null) {
      //* This means you start the call (you are caller)
      await startCalling();
    } else {
      //* This mean you join the call (You are callee)
      await inCallSetUp();
    }
    await getAudioSources();
    setDefaultAudioSource();
    await observeRemoteStreams();

    print("Call type ${(args.isAudioCall)}");

    await onChangeParticipant();

    updateCallerVideoWidget();
    await enableWakeScreenLock();
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

  //TODO farzam refacor
  Future<void> streamUpdated(
    CallStream callStream,
    int index,
    ConnectedParticipantModel connectedParticipantModel,
  ) async {
    if (connectedParticipantModel.rtcVideoRenderer == null &&
        callStream.remoteStream != null) {
      final renderer = RTCVideoRenderer();
      await renderer.initialize();
      renderer.srcObject = callStream.remoteStream;

      //* To get the name if current user save this coreId to contact
      final userContact = await contactAvailabilityUseCase.execute(
        coreId: callStream.coreId,
      );
      final remoteParticipate = ConnectedParticipantModel(
        audioMode: true.obs,
        videoMode: (!callStream.isAudioCall).obs,
        coreId: callStream.coreId,
        name: userContact.name,
        stream: callStream.remoteStream,
        rtcVideoRenderer: renderer,
      );
      connectedRemoteParticipates[index] = remoteParticipate;
    } else {
      connectedRemoteParticipates[index] = connectedRemoteParticipates[index]
          .copyWith(videoMode: (!callStream.isAudioCall).obs);
    }
  }

  Future<void> createConnectedParticipantModel(CallStream callStream) async {
    print(
        " createConnectedParticipantModel : ${callStream.isAudioCall} : ${callStream.remoteStream}");
    RTCVideoRenderer? renderer;
    if (callStream.remoteStream != null) {
      renderer = RTCVideoRenderer();
      await renderer.initialize();
      renderer.srcObject = callStream.remoteStream;
    }
    //* To get the name if current user save this coreId to contact
    final userContact = await contactAvailabilityUseCase.execute(
      coreId: callStream.coreId,
    );

    connectedRemoteParticipates.add(
      ConnectedParticipantModel(
        audioMode: true.obs,
        videoMode:
            (renderer == null) ? false.obs : (!callStream.isAudioCall).obs,
        coreId: callStream.coreId,
        name: userContact.name,
        stream: callStream.remoteStream,
        rtcVideoRenderer: renderer,
      ),
    );
  }

  Future<void> onNewParticipateReceived(CallStream callStream) async {
    // TODO(AliAzim): condition should be add to check if video is enable or not
    var isRemoteAvailable = false;
    for (var index = 0; index < connectedRemoteParticipates.length; index++) {
      if (connectedRemoteParticipates[index].coreId == callStream.coreId) {
        isRemoteAvailable = true;
        streamUpdated(callStream, index, connectedRemoteParticipates[index]);
        break;
      }
    }
    if (isRemoteAvailable) {
      return;
    }
    await createConnectedParticipantModel(callStream);

    //updateCalleeVideoWidget();
  }

  Future<void> inCallSetUp() async {
    //await callRepository.acceptCall(args.callId!);
    //* I move mock in controller to pass callId

    isInCall.value = true;
    startCallTimer();
  }

  Future<void> onChangeParticipant() async {
    //* adding participate into bottom sheet
    for (final element in args.members) {
      await addOrUpdateAllParticipate(coreId: element);
    }

    //* Observe the changes in onChangeParticipateStream
    callRepository.onChangeParticipateStream = (participant) async {
      debugPrint('New participate added to call => $participants');
      await addOrUpdateAllParticipate(coreId: participant.coreId);
    };
  }

  Future<void> addOrUpdateAllParticipate({
    required String coreId,
    AllParticipantStatus status = AllParticipantStatus.calling,
  }) async {
//* To get the name if current user save this coreId to contact
    final userContact = await contactAvailabilityUseCase.execute(
      coreId: coreId,
    );
    final participant = AllParticipantModel(
      name: userContact.name,
      coreId: coreId,
      status: status,
    );

    //* check if the participant is already in list or not
    final participantIndex =
        participants.indexWhere((item) => item.coreId == coreId);

    if (participantIndex == -1) {
      participants.add(participant.copyWith(name: userContact.name));
    } else {
      participants[participantIndex] = participant;
    }
  }

  Future<void> removeFromAllParticipate(String coreId) async {
    //* check if the participant is already in list or not
    final participantIndex =
        participants.indexWhere((item) => item.coreId == coreId);

    if (participantIndex != -1) {
      participants.removeAt(participantIndex);
    }
  }

  Future<void> observeRemoteStreams() async {
    final callStreams = await callRepository.getCallStreams();
    print(" ${callStreams.length} : ${callRepository.hashCode}");

    callRepository
      ..onCallStreamReceived = (callStateView) {
        debugPrint(
          'bbbbbbbb onAddCallStream : $callStateView : ${callStateView.remoteStream} : ${callRepository.hashCode}',
        );
        //print("calll ${_remoteRenderers} : $stream");
        //TODO refactor this if related to the call state
        if (!isInCall.value) {
          isInCall.value = true;
          _stopWatingBeep();
          startCallTimer();
        }

        onNewParticipateReceived(callStateView);
        addOrUpdateAllParticipate(
          coreId: callStateView.coreId,
          status: AllParticipantStatus.accepted,
        );
      }
      ..onRemoveStream = (coreId) {
        for (var index = 0;
            index < connectedRemoteParticipates.length;
            index++) {
          if (connectedRemoteParticipates[index].coreId == coreId) {
            connectedRemoteParticipates
                .remove(connectedRemoteParticipates[index]);
            break;
          }
        }
        removeFromAllParticipate(coreId);
      };

    for (final element in callStreams) {
      await onNewParticipateReceived(element);
    }
  }

  // Todo
  void toggleMuteMic() {
    callRepository.muteMic();
    localParticipate.value!.audioMode.value =
        !localParticipate.value!.audioMode.value;
    //micEnabled.value = !micEnabled.value;
  }

  // Todo
  void switchAudioSource() {}

  Future<void> endCall() async {

    if (args.callId == null) {
      await callRepository.endOrCancelCall(requestedCallId);
      if (Platform.isIOS){
        await iOSCallKitProvider.endAllCalls(requestedCallId);
        debugPrint('➡️ CallController: endCall');
      }
    } else {
      await callRepository.endOrCancelCall(args.callId!);
      if (Platform.isIOS){
        await iOSCallKitProvider.endAllCalls(args.callId!);
        debugPrint('➡️ CallController: endCall');
      }
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
    bool videoMode = !localParticipate.value!.videoMode.value;
    localParticipate.value!.videoMode.value = videoMode;
    callRepository.showLocalVideoStream(videoMode, true);
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
    fullScreenMode.value = !fullScreenMode.value;
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
    if (localParticipate.value != null) {
      await localParticipate.value!.rtcVideoRenderer!.dispose();
    }
    await disposeRTCRender();
    _stopWatingBeep();
    await disableWakeScreenLock();
    animationController.dispose();
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
      walletAddress: args.members.first,
      coreId: args.members.first,
    );
  }

  void switchFullSCreenMode() => fullScreenMode.value = !fullScreenMode.value;

  Future<void> getAudioSources() async {
    audioOutputs
      ..clear()
      ..addAll(await callRepository.getAudioOutputs());
  }

  void setDefaultAudioSource() {
    final earpieceInfo = audioOutputs
        .firstWhereOrNull((p0) => p0.label == AudioOutputSources.earpiece.name);
    if (earpieceInfo == null) {
      final firstSource = audioOutputs.first;
      selectedAudioOutput.value = firstSource;
      print("Output selected 1");
      callRepository.setAudioSource(firstSource.deviceId);
    } else {
      selectedAudioOutput.value = earpieceInfo;
      print("Output selected 2");
      callRepository.setAudioSource(earpieceInfo.deviceId);
    }
  }

  void onSelectAudioOutput(String deviceId) {
    selectedAudioOutput.value = audioOutputs.firstWhereOrNull(
      (element) => element.deviceId == deviceId,
    );
    callRepository.setAudioSource(deviceId);
  }

}
