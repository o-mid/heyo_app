import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/bindings/priority_bindings_interface.dart';
import 'package:heyo/app/modules/shared/data/providers/events/send_event_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/events/send_event_provider_impl.dart';
import 'package:heyo/app/modules/shared/data/providers/network/dio/dio_network_request.dart';
import 'package:heyo/app/modules/shared/data/providers/network/netowrk_request_provider.dart';

class NetworkBindings with HighPriorityBindings {
  @override
  void executeHighPriorityBindings() {
    Get
      ..put<NetworkRequest>(
        DioNetworkRequest(),
        permanent: true,
      )
      ..put<SendEventProvider>(SendEventProviderImpl());
  }
}
