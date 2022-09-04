import 'package:flutter/material.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';

class CallViewTypeRowWidget extends StatelessWidget {
  CallViewTypeRowWidget({
    Key? key,
    required this.firstWidget,
    required this.secondWidget,
  }) : super(key: key);

  final controller = Get.find<CallController>();
  final Widget firstWidget;
  final Widget secondWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Spacer(
          flex: 1,
        ),
        Obx(() {
          return Text(
            "${controller.callDurationSeconds.value ~/ 60}:${(controller.callDurationSeconds.value % 60).toString().padLeft(2, "0")}",
            style: TEXTSTYLES.kBodyBasic.copyWith(color: COLORS.kWhiteColor),
          );
        }),
        CustomSizes.largeSizedBoxHeight,
        Expanded(
          flex: 5,
          child: DraggableGridViewBuilder(
            dragPlaceHolder: (List<DraggableGridItem> list, int index) {
              return PlaceHolderWidget(
                child: Container(
                  color: Colors.transparent,
                ),
              );
            },
            dragFeedback: (List<DraggableGridItem> list, int index) {
              return list[index].child;
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: controller.callRowViewAspectRatio,
            ),
            dragCompletion: (List<DraggableGridItem> list, int beforeIndex, int afterIndex) {
              print('onDragAccept: $beforeIndex -> $afterIndex');
            },
            children: [
              DraggableGridItem(
                isDraggable: true,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: AspectRatio(
                      aspectRatio: controller.callRowViewAspectRatio,
                      child: firstWidget,
                    )),
              ),
              DraggableGridItem(
                isDraggable: true,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: AspectRatio(
                      aspectRatio: controller.callRowViewAspectRatio,
                      child: secondWidget,
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
