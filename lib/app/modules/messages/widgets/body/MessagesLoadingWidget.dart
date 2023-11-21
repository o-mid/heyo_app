import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:heyo/app/modules/messages/data/models/messages/text_message_model.dart';
import 'package:heyo/app/modules/messages/widgets/body/message_selection_wrapper.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:shimmer/shimmer.dart';

class MessagesLoadingWidget extends StatelessWidget {
  const MessagesLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      baseColor: COLORS.kShimmerBase,
      highlightColor: COLORS.kShimmerHighlight,
      // this will return a list of mock messages for the loading state of the messaging screen
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return MessageSelectionWrapper(
            isMockMessage: true,
            message: TextMessageModel(
              messageId: '',
              chatId: '',
              text: '                            ',
              timestamp: DateTime.now(),
              isFromMe: index % 2 == 0 ? true : false,
              senderName: '',
              senderAvatar: '',
            ),
          );
        },
        itemCount: 10,
      ),
    );
  }
}
