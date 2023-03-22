import 'package:flutter/widgets.dart';

import '../../data/models/messages/message_model.dart';
import '../../data/models/messages/text_message_model.dart';
import '../../data/models/reaction_model.dart';
import '../../data/models/reply_to_model.dart';
import 'message_item_widget.dart';
import 'message_selection_wrapper.dart';

class MessagesShimmerWidget extends StatelessWidget {
  const MessagesShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return MessageSelectionWrapper(
          isMockMessage: true,
          message: TextMessageModel(
            messageId: "",
            text: "                            ",
            timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 6, minutes: 5)),
            isFromMe: index % 2 == 0 ? true : false,
            senderName: "args.user.chatModel.name",
            senderAvatar: "https://avatars.githubusercontent.com/u/6634136?v=4",
          ),
        );
      },
      itemCount: 10,
    );
  }
}
