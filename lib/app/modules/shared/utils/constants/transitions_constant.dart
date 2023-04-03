// ignore_for_file: constant_identifier_names

import 'package:flutter/animation.dart';

class TRANSITIONS {
  static const messagingPage_receiveMsgDurtion = Duration(milliseconds: 150);
  static const messagingPage_receiveMsgcurve = Curves.easeOut;

  static const messagingPage_getAllMsgsDurtion = Duration(milliseconds: 100);
  static const messagingPage_getAllMsgscurve = Curves.easeOutCubic;

  static const messagingPage_sendMsgDurtion = Duration(milliseconds: 100);
  static const messagingPage_sendMsgcurve = Curves.easeOut;

  static const messagingPage_generalMsgTransitionDurtion = Duration(milliseconds: 150);
  static const messagingPage_generalMsgTransitioncurve = Curves.easeInOut;

  static const messagingPage_openRecordModeDurtion = Duration(milliseconds: 150);
  static const messagingPage_openRecordModeCurve = Curves.linear;

  static const messagingPage_closeRecordModeDurtion = Duration(milliseconds: 150);
  static const messagingPage_closeRecordModeCurve = Curves.linear;

  static const messagingPage_closeMessagesLoadingShimmerDurtion = Duration(milliseconds: 200);
}
