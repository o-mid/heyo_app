import 'package:heyo/app/modules/shared/data/providers/events/send_event_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/events/send_event_provider_impl.dart';
import 'package:heyo/app/modules/shared/data/providers/network/dio/dio_network_request.dart';
import 'package:heyo/app/modules/shared/data/providers/network/netowrk_request_provider.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/core/di/priority_injector_interface.dart';

class NetworkInjector with HighPriorityInjector {
  @override
  void executeHighPriorityInjector() {
    inject
      ..registerSingleton<NetworkRequest>(
        DioNetworkRequest(),
        //permanent: true,
      )
      ..registerSingleton<SendEventProvider>(SendEventProviderImpl());
  }
}
