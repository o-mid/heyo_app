//import 'package:flutter/material.dart';
//import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:get/get.dart';
//import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';

//class CallViewTypeColumnWidget extends StatelessWidget {
//  CallViewTypeColumnWidget({
//    Key? key,
//    required this.firstWidget,
//    required this.secondWidget,
//  }) : super(key: key);

//  final controller = Get.find<CallController>();
//  final Widget firstWidget;
//  final Widget secondWidget;

//  @override
//  Widget build(BuildContext context) {
//    return SafeArea(
//      child: Center(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          crossAxisAlignment: CrossAxisAlignment.center,
//          mainAxisSize: MainAxisSize.min,
//          children: [
//            Center(
//              child: Expanded(
//                  child: DraggableGridViewBuilder(
//                children: [
//                  DraggableGridItem(
//                    isDraggable: true,
//                    child: AspectRatio(
//                      aspectRatio: controller.callColumnViewAspectRatio,
//                      child: firstWidget,
//                    ),
//                  ),
//                  DraggableGridItem(
//                    isDraggable: true,
//                    child: AspectRatio(
//                      aspectRatio: controller.callColumnViewAspectRatio,
//                      child: secondWidget,
//                    ),
//                  ),
//                ],
//                dragPlaceHolder: (List<DraggableGridItem> list, int index) {
//                  return PlaceHolderWidget(
//                    child: Container(
//                      color: Colors.transparent,
//                    ),
//                  );
//                },
//                dragFeedback: (List<DraggableGridItem> list, int index) {
//                  return SizedBox(
//                    width: MediaQuery.of(context).size.width,
//                    child: list[index].child,
//                  );
//                },
//                shrinkWrap: true,
//                physics: const ClampingScrollPhysics(),
//                scrollDirection: Axis.vertical,
//                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                  crossAxisCount: 1,
//                  crossAxisSpacing: 0,
//                  mainAxisSpacing: 0,
//                  childAspectRatio: controller.callColumnViewAspectRatio,
//                ),
//                dragCompletion: (List<DraggableGridItem> list, int beforeIndex, int afterIndex) {},
//              )),
//            ),
//            SizedBox(
//              height: controller.isImmersiveMode.value ? 8.h : 100.h,
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
