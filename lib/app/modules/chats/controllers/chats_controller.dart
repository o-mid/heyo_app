import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';

class ChatsController extends GetxController {
  // Todo: these are mock data and should be removed later.
  final chats = <ChatModel>[
    ChatModel(
      id: "1",
      name: "Crapps Wallbanger",
      icon: "https://raw.githubusercontent.com/Zunawe/identicons/HEAD/examples/poly.png",
      lastMessage: "I'm still waiting for the reply. I'll let you know once they get back to me.",
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 5)),
    ),
    ChatModel(
      id: "2",
      name: "Fancy Potato",
      icon: "https://avatars.githubusercontent.com/u/6634136?v=4",
      lastMessage: "I can arrange the meeting with her tomorrow if you're ok with that.",
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2, minutes: 5)),
      isOnline: true,
      isVerified: true,
      notificationCount: 4,
    ),
    ChatModel(
      id: "3",
      name: "Manly Cupholder",
      icon: "https://avatars.githubusercontent.com/u/9801359?v=4",
      lastMessage: "That's nice!",
      timestamp: DateTime.now().subtract(const Duration(days: 10, hours: 2, minutes: 5)),
      isOnline: true,
      notificationCount: 11,
    ),
  ].obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
