import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/shared/widgets/glassmorphic_container.dart';

class ReactionBox extends StatelessWidget {
  final MessageModel message;
  const ReactionBox({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: 315.w,
      height: 64.h,
      borderRadius: 8.r,
      blur: 10.r,
      border: 0,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF466087).withOpacity(0.1),
          const Color(0xFF466087).withOpacity(0.05),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(12.w),
        color: Colors.white.withOpacity(0.62),
        child: Row(
          children: [
            _buildEmoji(Emojis.redHeart),
            _buildEmoji(Emojis.faceWithTearsOfJoy),
            _buildEmoji(Emojis.astonishedFace),
            _buildEmoji(Emojis.thumbsUp),
            _buildEmoji(Emojis.thumbsDown),
            _buildEmoji(Emojis.sadButRelievedFace),
          ],
        ),
      ),
    );
  }

  Widget _buildEmoji(String emoji) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Get.find<MessagesController>().toggleReaction(message, emoji);
          Get.find<MessagesController>().clearSelected();
        },
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(emoji),
        ),
      ),
    );
  }
}
