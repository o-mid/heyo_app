import 'package:heyo/app/modules/messaging/connection/connection_repo.dart';
import 'package:heyo/app/modules/messaging/connection/rtc_connection_repo_impl.dart';
import 'package:heyo/app/modules/messaging/connection/wifi_direct_connection_repo_impl.dart';
import 'package:heyo/app/modules/messaging/unified_messaging_controller.dart';

import 'connection_data_handler.dart';

class ConnectionRepoFactory {
  static ConnectionRepo create(ConnectionType connectionType, DataHandler dataHandler) {
    switch (connectionType) {
      case ConnectionType.RTC:
        return RTCConnectionRepoImpl(dataHandler: dataHandler);
      case ConnectionType.WiFiDirect:
        return WiFiDirectConnectionRepoImpl(dataHandler: dataHandler);
    }
  }
}
