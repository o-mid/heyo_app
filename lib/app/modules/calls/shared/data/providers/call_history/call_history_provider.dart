import 'package:heyo/app/modules/calls/shared/data/models/call_model.dart';
import 'package:heyo/app/modules/calls/shared/data/providers/call_history/call_history_abstract_provider.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/providers/database/app_database.dart';
import 'package:sembast/sembast.dart';

class CallHistoryProvider implements CallHistoryAbstractProvider {
  static const String callHistoryStoreName = 'call_history';

  final _store = intMapStoreFactory.store(callHistoryStoreName);

  Future<Database> get _db async => await AppDatabaseProvider.instance.database;

  @override
  Future<void> insert(CallModel call) async {
    await _store.add(await _db, call.toJson());
  }

  @override
  Future<void> deleteAll() async {
    await _store.delete(await _db);
  }

  @override
  Future<void> deleteOne(String callId) async {
    await _store.delete(
      await _db,
      finder: Finder(
        filter: Filter.equals(CallModel.idSerializedName, callId),
      ),
    );
  }

  @override
  Future<List<CallModel>> getAllCalls() async {
    final records = await _store.find(
      await _db,
      finder: Finder(sortOrders: [SortOrder(CallModel.dateSerializedName, false)]),
    );

    return records.map((e) => CallModel.fromJson(e.value)).toList();
  }

  @override
  Future<CallModel?> getOneCall(String callId) async {
    final records = await _store.find(
      await _db,
      finder: Finder(filter: Filter.equals(CallModel.idSerializedName, callId)),
    );

    if (records.isEmpty) {
      return null;
    }

    final callJson = records.first.value;
    return CallModel.fromJson(callJson);
  }

  @override
  Future<List<CallModel>> getCallsFromUserId(String userId) async {
    final records = await _store.find(
      await _db,
      finder: Finder(
        sortOrders: [SortOrder(CallModel.dateSerializedName, false)],
        filter: Filter.equals(
          "${CallModel.userSerializedName}.${UserModel.walletAddressSerializedName}",
          userId,
        ),
      ),
    );

    return records.map((e) => CallModel.fromJson(e.value)).toList();
  }
}
