import 'package:flutter_ios_call_kit/entities/entities.dart';
import 'package:flutter_ios_call_kit/flutter_ios_call_kit.dart';
import 'package:heyo/app/modules/calls/shared/data/providers/call_controller_provider/call_controller_provider.dart';

import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/crypto_account/account_repository.dart';
import 'package:heyo/app/modules/calls/data/rtc/models.dart';
import 'package:uuid/uuid.dart';

class IosCallControllerProvider implements CallControllerProvider {

  IosCallControllerProvider({
    required this.accountInfoRepo,
    required this.contactRepository,
  });

  final AccountRepository accountInfoRepo;
  final ContactRepository contactRepository;

  Future<void> incomingCall(CallId callId,List<CallInfo> calls) async {

    final userModel = await contactRepository
        .getContactById(calls.first.remotePeer.remoteCoreId);
    await showMockCallkitIncoming(Uuid().v4());
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