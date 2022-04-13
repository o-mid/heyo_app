import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';

class ChatsController extends GetxController {
  // Todo: these are mock data and should be removed later.
  final chats = <ChatModel>[
    ChatModel(
      name: "Crapps Wallbanger",
      icon: "https://raw.githubusercontent.com/Zunawe/identicons/HEAD/examples/poly.png",
      lastMessage: "I'm still waiting for the reply. I'll let you know once they get back to me.",
      timestamp: "15:45",
      isOnline: true,
    ),
    ChatModel(
      name: "Fancy Potato",
      icon: "https://avatars.githubusercontent.com/u/6634136?v=4",
      lastMessage: "I can arrange the meeting with her tomorrow if you're ok with that.",
      timestamp: "Yesterday",
      isOnline: true,
      notificationCount: 4,
    ),
    ChatModel(
      name: "Manly Cupholder",
      icon: "https://avatars.githubusercontent.com/u/9801359?v=4",
      lastMessage: "That's nice!",
      timestamp: "15/01/2022",
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
