import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/providers/call_controller_provider/call_controller_provider.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';
import 'package:heyo/app/modules/shared/data/repository/account/account_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/calls/data/rtc/models.dart';
import 'package:heyo/app/routes/app_pages.dart';

import 'call_controller_provider.dart';

class AndroidCallControllerProvider implements CallControllerProvider {

  AndroidCallControllerProvider({
    required this.accountInfoRepo,
    required this.contactRepository,
  });

  final AccountRepository accountInfoRepo;
  final ContactRepository contactRepository;

  Future<void> incomingCall(CallId callId,List<CallInfo> calls) async {

    await Get.toNamed(
      Routes.INCOMING_CALL,
      arguments: IncomingCallViewArguments(
        callId: callId,
        isAudioCall: calls.first.isAudioCall,
        members: calls.map((e) => e.remotePeer.remoteCoreId).toList(),
      ),
    );
  }

  @override
  Future<void> declineCall() {
    // TODO: implement declineCall
    throw UnimplementedError();
  }
}

