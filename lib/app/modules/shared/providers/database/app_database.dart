import 'dart:async';
import 'dart:io';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/shared/utils/encrypt_codec.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class AppDatabaseProvider {
  //singleton instance
  static final AppDatabaseProvider _instance = AppDatabaseProvider._();

  //public accessor
  static AppDatabaseProvider get instance => _instance;

  static late AccountInfo _accountInfo;

  //for opening database we use completer which uses for transforming sync code into async code and stores a future in itself
  Completer<Database>? _dbOpenCompleter;

  // private constructor allows us to create instance only from the class
  AppDatabaseProvider._();

  static void init(AccountInfo accountInfo) {
    _accountInfo = accountInfo;
  }

  // Database object accessor
  Future<Database> get database async {
    // If completer is null, AppDatabaseClass is newly instantiated, so database is not yet opened
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      // Calling _openDatabase will also complete the completer with database instance
      _openDatabase();
    }
    // If the database is already opened, awaiting the future will happen instantly.
    // Otherwise, awaiting the returned future will take some time - until complete() is called
    // on the Completer in _openDatabase() below.
    return _dbOpenCompleter!.future;
  }

  Future _openDatabase() async {
    if (Platform.isAndroid) PathProviderAndroid.registerWith();
    if (Platform.isIOS) PathProviderIOS.registerWith();

    // Get a platform-specific directory where persistent app data can be stored
    final appDocumentDir = await getApplicationDocumentsDirectory();
    // Path with the form: /platform-specific-directory/demo.db
    final dbPath = join(appDocumentDir.path, 'heyo.db');

    final password = await _accountInfo.getPrivateKey();
    assert(password != null);

    final database = await databaseFactoryIo.openDatabase(
      dbPath,
      codec: getEncryptSembastCodec(password: password!),
    );
    // Any code awaiting the Completer's future will now start executing
    _dbOpenCompleter!.complete(database);
  }
}
