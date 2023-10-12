import 'package:heyo/app/modules/calls/shared/data/models/call_history_model/call_history_model.dart';
import 'package:heyo/app/modules/calls/shared/data/providers/call_history/call_history_abstract_provider.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_abstract_repo.dart';

class CallHistoryRepo implements CallHistoryAbstractRepo {
  final CallHistoryAbstractProvider callHistoryProvider;

  CallHistoryRepo({required this.callHistoryProvider});

  @override
  Future<void> addCallToHistory(CallHistoryModel call) async {
    await callHistoryProvider.insert(call);
  }

  @override
  Future<List<CallHistoryModel>> getAllCalls() {
    return callHistoryProvider.getAllCalls();
  }

  @override
  Future<CallHistoryModel?> getOneCall(String callId) {
    return callHistoryProvider.getOneCall(callId);
  }

  @override
  Future<void> deleteAllCalls() async {
    await callHistoryProvider.deleteAll();
  }

  @override
  Future<void> deleteOneCall(String callId) async {
    await callHistoryProvider.deleteOne(callId);
  }

  @override
  Future<List<CallHistoryModel>> getCallsFromUserId(String userId) {
    return callHistoryProvider.getCallsFromUserId(userId);
  }

  @override
  Future<Stream<List<CallHistoryModel>>> getCallsStream() {
    return callHistoryProvider.getCallsStream();
  }

  @override
  Future<void> updateCall(CallHistoryModel call) async {
    await callHistoryProvider.insert(call);
  }
}
