import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/models/messages/message_model.dart';
import '../../data/models/messages/text_message_model.dart';
import '../../data/models/reaction_model.dart';
import '../../data/models/reply_to_model.dart';
import 'message_item_widget.dart';
import 'message_selection_wrapper.dart';

class MessagesLoadingWidget extends StatelessWidget {
  const MessagesLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return MessageSelectionWrapper(
            isMockMessage: true,
            message: TextMessageModel(
              messageId: "",
              text: "                            ",
              timestamp: DateTime.now(),
              isFromMe: index % 2 == 0 ? true : false,
              senderName: "",
              senderAvatar: "",
            ),
          );
        },
        itemCount: 10,
      ),
    );
  }
}
