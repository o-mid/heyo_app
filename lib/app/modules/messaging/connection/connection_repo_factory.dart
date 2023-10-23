import 'package:heyo/app/modules/messaging/connection/connection_repo.dart';
import 'package:heyo/app/modules/messaging/connection/rtc_connection_repo_impl.dart';
import 'package:heyo/app/modules/messaging/connection/wifi_direct_connection_repo_impl.dart';
import 'package:heyo/app/modules/messaging/unified_messaging_controller.dart';

class ConnectionRepoFactory {
  static ConnectionRepo create(ConnectionType connectionType) {
    switch (connectionType) {
      case ConnectionType.RTC:
        return RTCConnectionRepoImpl();
      case ConnectionType.WiFiDirect:
        return WiFiDirectConnectionRepo();
    }
  }
}
