import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo_wifi_direct/heyo_wifi_direct.dart';

import '../../../routes/app_pages.dart';
import '../../shared/data/models/messages_view_arguments_model.dart';
import '../../wifi_direct/widgets/appbar/wifi_direct_app_bar_widget.dart';
import '../controllers/wifi_direct_connect_controller.dart';

class WifiDirectConnectView extends GetView<WifiDirectConnectController> {
  const WifiDirectConnectView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller.startConnection();
    return Scaffold(
      appBar: wifiDirectAppBarWidget(),
      body: Center(
        child: Column(
                children: [
                  Text(
                    controller.user.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    controller.user.coreId,
                    style: const TextStyle(fontSize: 12),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  Obx(() {
                    late String connectionStatus;

                    switch (controller.connectionStatus.value) {

                      case PeerStatus.peerInvited:
                      connectionStatus = 'Invitation sent';
                        break;

                      case PeerStatus.peerAvailable:
                        connectionStatus = 'Contact available';
                        break;

                      case PeerStatus.peerConnected:
                        print('WifiDirectConnectView peerTCPOpened ${controller.user.coreId}');
                        connectionStatus = 'Connected';
                        Future.delayed(const Duration(milliseconds: 500),() {
                          Get.back();
                          Get.toNamed(
                            Routes.MESSAGES,
                            arguments: MessagesViewArgumentsModel(
                              user: controller.user,
                              connectionType: MessagingConnectionType.wifiDirect,
                            ),
                          );
                        });
                        break;

                      case PeerStatus.peerTCPOpened:
                        print('WifiDirectConnectView peerTCPOpened ${controller.user.coreId}');
                        connectionStatus = 'TCP connection opened';
                        Future.delayed(const Duration(milliseconds: 500),() {
                          Get.back();
                          Get.toNamed(
                            Routes.MESSAGES,
                            arguments: MessagesViewArgumentsModel(
                              user: controller.user,
                              connectionType: MessagingConnectionType.wifiDirect,
                            ),
                          );
                        });
                        break;

                      case PeerStatus.peerUnavailable:
                        connectionStatus = 'Contact unavailable';
                        Future.delayed(const Duration(milliseconds: 500), () => Get.back());
                        break;

                      default:
                        connectionStatus = 'Status unknown';
                        break;
                    }
                    return Text(
                      connectionStatus,
                      style: const TextStyle(fontSize: 14),
                    );
                  })
                ],
        ),
      ),
    );
  }
}
