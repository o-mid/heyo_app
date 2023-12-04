import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/calls/shared/data/models/connected_participant_model/connected_participant_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';

class CallRendererLocalStackWidget extends StatelessWidget {
  const CallRendererLocalStackWidget({
    required this.participantModel,
    super.key,
  });

  final ConnectedParticipantModel participantModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: COLORS.kCallPageDarkGrey,
        border: Border.all(
          color: Colors.black54,
          width: 0.5,
        ),
      ),
      // TODO(AliAzim): the condition for voice and video call should add in here.
      child: !participantModel.videoMode.value
          ? RTCVideoView(
              participantModel.rtcVideoRenderer!,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        CustomCircleAvatar(
                          url: participantModel.iconUrl,
                          size: 48,
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          participantModel.name,
                          style: TEXTSTYLES.kHeaderMedium.copyWith(
                            color: COLORS.kWhiteColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          participantModel.coreId.shortenCoreId,
                          style: TEXTSTYLES.kBodySmall.copyWith(
                            color: COLORS.kWhiteColor.withOpacity(0.6),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
    );
  }
}
