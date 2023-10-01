import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/calls/main/widgets/call_renderer_widget.dart';

class GroupCallWidget extends GetView<CallController> {
  const GroupCallWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allVideoRenderers = controller.getAllConnectedParticipate();
    return Obx(() {
      if (allVideoRenderers.isEmpty) {
        return const Center(child: Text('No remote videos available.'));
      }

      return Column(
        children: [
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: allVideoRenderers.length == 2 ? 1 : 2,
                childAspectRatio: ScreenUtil.defaultSize.aspectRatio *
                    (allVideoRenderers.length == 2 ? 2 : 1),
              ),
              itemCount: allVideoRenderers.length,
              itemBuilder: (context, index) {
                return CallRendererWidget(
                  participateModel: allVideoRenderers[index],
                );
              },
            ),
          ),
          //* This sizeBox is because of call bottom sheet header
          //TODO: AliAzim => It should be removed for ImmersiveMode
          SizedBox(height: 70.h)
        ],
      );
    });
  }
}
