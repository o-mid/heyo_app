import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DraggableVideo extends StatefulWidget {
  final Widget child;
  const DraggableVideo({
    super.key,
    required this.child,
  });

  @override
  State<DraggableVideo> createState() => _DraggableVideoState();
}

class _DraggableVideoState extends State<DraggableVideo> {
  double? _x;
  double? _y;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _x,
      top: _y ?? 16.h,
      right: _x == null ? 16.w : null,
      child: Draggable(
        onDragEnd: (dragDetails) {
          setState(
            () {
              _x = dragDetails.offset.dx;
              _x = _x!.clamp(0, context.width - 96);
              // We need to remove offsets like app/status bar from Y
              _y = dragDetails.offset.dy - 100 - MediaQuery.of(context).padding.top;
              _y = _y!.clamp(0, context.height / 2);
            },
          );
        },
        feedback: widget.child,
        childWhenDragging: Container(),
        child: widget.child,
      ),
    );
  }
}
