import 'package:flutter/material.dart';

class MessagesListScrollPhysics extends BouncingScrollPhysics {
  const MessagesListScrollPhysics({ScrollPhysics? parent, bool isFastScroll = false})
      : super(parent: parent);

// this custom ScrollPhysics is extended from the defualt BouncingScrollPhysics class
// with some adjusments based on the our prefences and the physics needed for the messsages list

  @override
  Tolerance get tolerance => const Tolerance(velocity: 0.0);

  @override
  BouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return BouncingScrollPhysics(
      parent: buildParent(ancestor),
      decelerationRate: ScrollDecelerationRate.normal,
    );
  }
}
