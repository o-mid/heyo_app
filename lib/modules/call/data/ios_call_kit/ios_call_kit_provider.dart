import 'package:flutter_ios_call_kit/entities/entities.dart';
import 'package:flutter_ios_call_kit/flutter_ios_call_kit.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';
import 'package:heyo/app/modules/shared/data/repository/account/account_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/modules/call/data/rtc/models.dart';
import 'package:heyo/modules/call/domain/call_repository.dart';
import 'package:uuid/uuid.dart';

class CallKitProvider {

  CallKitProvider({
    required this.accountInfoRepo,
    required this.contactRepository,
    required this.callRepository,
  }) {
    listenerEvent(_onNewEventRecived);
  }

  final AccountRepository accountInfoRepo;
  final ContactRepository contactRepository;
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
    final userModel = await contactRepository
        .getContactById(calls.first.remotePeer.remoteCoreId);

    final params = CallKitParams(
        id: _uuid,
        nameCaller: userModel?.name,
        appName: "Heyo",
        type: (callInfo.first.isAudioCall) ? 0 : 1,);
    await FlutterIosCallKit.showCallkitIncoming(params);
    print('🟩 IosCallController: incoming Call');
  }

  Future<void> makeCall(CallId callId, UserModel user) async {

    // Do implementation for make call with call kit
    final params = CallKitParams(
      id: _uuid,
      nameCaller: user.nickname.isEmpty
          ? user.coreId.shortenCoreId
          : user.nickname.tr,
      handle: '0123456789',
      type: 1,
      extra: <String, dynamic>{'userId': user.coreId},
      ios: const IOSParams(handleType: 'number'),
    );
    await FlutterIosCallKit.startCall(params);
    print('🟩 IosCallController: make Call');
  }

  Future<void> activeCalls() async {

    var calls = await FlutterIosCallKit.activeCalls();
    print('🟩 IosCallController: active Call');
  }

  Future<void> endCurrentCall() async {

    await FlutterIosCallKit.endCall(_uuid!);
    print('🟩 IosCallController: end Current Call');
  }

  Future<void> endAllCalls() async {

    await callRepository.endOrCancelCall(callId);
    await FlutterIosCallKit.endAllCalls();
    print('🟩 IosCallController: end All Calls');
  }

  Future<void> getDevicePushTokenVoIP() async {
    var devicePushTokenVoIP = await FlutterIosCallKit.getDevicePushTokenVoIP();
    print(devicePushTokenVoIP);
    print('🟩 IosCallController: get Device Push Token VoIP');
  }

  @override
  Future<void> declineCall() async {

    await callRepository.endOrCancelCall(callId);
    await FlutterIosCallKit.endCall(_uuid);
    print('🟩 IosCallController: declineCall');
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
    print("🟩 acceptCall");
  }

  Future<void> listenerEvent(void Function(CallEvent) callback) async {
    try {
      FlutterIosCallKit.onEvent.listen((event) async {
        print('🟩 IosCallController: event: $event');
        _onNewEventRecived(event!);

        switch (event!.event) {
          case Event.actionCallIncoming:
            // TODO: received an incoming call
            print("🟩 IosCallController: Event.actionCallIncoming");
            break;
          case Event.actionCallStart:
            // TODO: started an outgoing call
            // TODO: show screen calling in Flutter
            print("🟩 IosCallController: Event.actionCallStart");
            break;
          case Event.actionCallAccept:
            // TODO: accepted an incoming call
            print("🟩 IosCallController: Event.actionCallAccept");
            acceptCall();
            break;
          case Event.actionCallDecline:
            // TODO: declined an incoming call
            print("🟩 IosCallController: Event.actionCallDecline");
            callRepository.rejectIncomingCall(callId);
            await FlutterIosCallKit.endCall(_uuid);
            break;
          case Event.actionCallEnded:
            // TODO: ended an incoming/outgoing call
            print("🟩 IosCallController: Event.actionCallEnded");
            // callRepository.endOrCancelCall(callId);
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
      iconName: 'CallKitLogo',
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
