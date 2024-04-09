import 'package:flutter/cupertino.dart';
import 'package:flutter_ios_call_kit/entities/entities.dart';
import 'package:flutter_ios_call_kit/flutter_ios_call_kit.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';
import 'package:heyo/app/modules/shared/data/repository/account/account_repository.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/modules/call/data/rtc/models.dart';
import 'package:heyo/modules/call/domain/call_repository.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';
import 'package:heyo/modules/features/contact/usecase/get_contact_by_id_use_case.dart';
import 'package:uuid/uuid.dart';

class CallKitProvider {
  CallKitProvider({
    required this.accountInfoRepo,
    required this.getContactByIdUseCase,
    required this.callRepository,
  }) {
    listenerEvent(_onNewEventRecived);
  }

  final AccountRepository accountInfoRepo;
  final GetContactByIdUseCase getContactByIdUseCase;
  final CallRepository callRepository;
  late CallId callId;
  late List<CallInfo> callInfo;

  String _uuid = Uuid().v4();

  // MARK: On Call kit call back event
  // final onCallKitNewEvent = Rxn<CallEvent>();
  Function(CallEvent event)? onCallKitNewEvent;

  void _onNewEventRecived(CallEvent event) {
    onCallKitNewEvent?.call(event);
  }

  @override
  Future<void> incomingCall(CallId callId, List<CallInfo> calls) async {
    this.callId = callId;
    callInfo = calls;
    _uuid = const Uuid().v4();
    final contact = await getContactByIdUseCase
        .execute(calls.first.remotePeer.remoteCoreId);

    final params = CallKitParams(
      id: _uuid,
      nameCaller: calls.first.remotePeer.remoteCoreId.shortenCoreId.endOfCoreId,
      appName: "Heyo",
      type: (callInfo.first.isAudioCall) ? 0 : 1,
      extra: <String, dynamic>{
        'userId': calls.first.remotePeer.remoteCoreId.shortenCoreId.endOfCoreId
      },
    );
    await FlutterIosCallKit.showCallkitIncoming(params);
    debugPrint('🟩 CallKitProvider: incoming Call');
  }

  Future<void> makeCall(
      CallId callId, bool isAudioCall, List<String> members) async {
    // Do implementation for make call with call kit
    final params = CallKitParams(
        id: _uuid,
        nameCaller: members.first.endOfCoreId,
        handle: members.first.shortenCoreId,
        type: isAudioCall ? 0 : 1,
        extra: <String, dynamic>{'userId': members.first.shortenCoreId},
        ios: const IOSParams(handleType: 'generic'));
    await FlutterIosCallKit.startCall(params);
    debugPrint('🟩 CallKitProvider: make Call');
  }

  Future<void> activeCalls() async {
    var calls = await FlutterIosCallKit.activeCalls();
    debugPrint('🟩 CallKitProvider: active Call');
  }

  Future<void> endCurrentCall() async {
    await FlutterIosCallKit.endCall(_uuid!);
    debugPrint('🟩 CallKitProvider: end Current Call');
  }

  Future<void> setCallConnected() async {
    await FlutterIosCallKit.setCallConnected(_uuid!);
    debugPrint('🟩 CallKitProvider: setCallConnected');
  }

  Future<void> endAllCalls(CallId callId) async {
    await callRepository.endOrCancelCall(callId);
    await FlutterIosCallKit.endAllCalls();
    debugPrint('🟩 CallKitProvider: end All Calls');
  }

  Future<void> getDevicePushTokenVoIP() async {
    final devicePushTokenVoIP =
        await FlutterIosCallKit.getDevicePushTokenVoIP();
    debugPrint('🟩 CallKitProvider:  Push Token VoIP');
    debugPrint('------------------ Push Token VoIP ---------------------');
    debugPrint(devicePushTokenVoIP.toString());
  }

  @override
  Future<void> declineCall(CallId callId) async {
    await callRepository.endOrCancelCall(callId);
    await FlutterIosCallKit.endCall(_uuid);
    debugPrint('🟩 CallKitProvider: declineCall');
  }

  Future<void> acceptCall() async {
    await callRepository.acceptCall(callId);
    //TODO farzam, accept
    Get.toNamed(
      Routes.CALL,
      arguments: CallViewArgumentsModel(
        callId: callId,
        isAudioCall: callInfo.first.isAudioCall,
        members: callInfo.map((e) => e.remotePeer.remoteCoreId).toList(),
      ),
    );
    debugPrint("🟩 CallKitProvider: acceptCall");
  }

  Future<void> listenerEvent(void Function(CallEvent) callback) async {
    try {
      FlutterIosCallKit.onEvent.listen((event) async {
        debugPrint('🟩 CallKitProvider: event: $event');
        _onNewEventRecived(event!);

        switch (event!.event) {
          case Event.actionCallIncoming:
            // TODO: received an incoming call
            break;
          case Event.actionCallStart:
            // TODO: started an outgoing call
            // TODO: show screen calling in Flutter
            break;
          case Event.actionCallAccept:
            // TODO: accepted an incoming call
            acceptCall();
            break;
          case Event.actionCallDecline:
            // TODO: declined an incoming call
            callRepository.rejectIncomingCall(callId);
            await FlutterIosCallKit.endCall(_uuid);
            break;
          case Event.actionCallEnded:
            // TODO: ended an incoming/outgoing call
            await FlutterIosCallKit.endCall(_uuid);
            break;
          case Event.actionCallTimeout:
            // TODO: missed an incoming call
            break;
          case Event.actionCallCallback:
            // TODO: only Android - click action `Call back` from missed call notification
            break;
          case Event.actionCallToggleHold:
            // TODO: only iOS
            break;
          case Event.actionCallToggleMute:
            // TODO: only iOS
            break;
          case Event.actionCallToggleDmtf:
            // TODO: only iOS
            break;
          case Event.actionCallToggleGroup:
            // TODO: only iOS
            break;
          case Event.actionCallToggleAudioSession:
            // TODO: only iOS
            break;
          case Event.actionDidUpdateDevicePushTokenVoip:
            // TODO: only iOS
            break;
          case Event.actionCallCustom:
            break;
        }
        callback(event);
      });
    } on Exception catch (e) {
      print(e);
    }
  }
}

Future<void> showMockCallkitIncoming(String uuid) async {
  final params = CallKitParams(
    id: uuid,
    nameCaller: 'Hoorad',
    appName: 'Heyo',
    avatar: 'https://i.pravatar.cc/100',
    handle: '0123456789',
    type: 0,
    duration: 30000,
    textAccept: 'Accept',
    textDecline: 'Decline',
    missedCallNotification: const NotificationParams(
      showNotification: true,
      isShowCallback: true,
      subtitle: 'Missed call',
      callbackText: 'Call back',
    ),
    extra: <String, dynamic>{'userId': '1a2b3c4d'},
    headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
    ios: const IOSParams(
      iconName: 'AppIcon',
      handleType: '',
      supportsVideo: true,
      maximumCallGroups: 2,
      maximumCallsPerCallGroup: 1,
      audioSessionMode: 'default',
      audioSessionActive: true,
      audioSessionPreferredSampleRate: 44100.0,
      audioSessionPreferredIOBufferDuration: 0.005,
      supportsDTMF: true,
      supportsHolding: true,
      supportsGrouping: false,
      supportsUngrouping: false,
      ringtonePath: 'system_ringtone_default',
    ),
  );
  await FlutterIosCallKit.showCallkitIncoming(params);
}
