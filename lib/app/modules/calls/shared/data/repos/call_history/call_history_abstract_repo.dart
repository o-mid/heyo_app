import 'package:heyo/app/modules/calls/shared/data/models/call_model.dart';

abstract class CallHistoryAbstractRepo {
  Future<void> addCallToHistory(CallModel call);

  Future<List<CallModel>> getAllCalls();

  Future<CallModel?> getOneCall(String callId);

  Future<List<CallModel>> getCallsFromUserId(String userId);

  Future<void> deleteAllCalls();

  Future<void> deleteOneCall(String callId);

  Future<Stream<List<CallModel>>> getCallsStream();

  Future<void> updateCall(CallModel call);
}
