import 'package:flutter/animation.dart';

class ANIMATIONS {
  static const receiveMsgDurtion = Duration(milliseconds: 150);
  static const receiveMsgcurve = Curves.easeOut;

  static const getAllMsgsDurtion = Duration(milliseconds: 100);
  static const getAllMsgscurve = Curves.easeOutCubic;

  static const sendMsgDurtion = Duration(milliseconds: 100);
  static const sendMsgcurve = Curves.easeOut;

  static const generalMsgTransitionDurtion = Duration(milliseconds: 150);
  static const generalMsgTransitioncurve = Curves.easeInOut;

  static const openRecordModeDurtion = Duration(milliseconds: 150);
  static const openRecordModeCurve = Curves.linear;

  static const closeRecordModeDurtion = Duration(milliseconds: 150);
  static const closeRecordModeCurve = Curves.linear;

  static const closeMessagesLoadingShimmerDurtion = Duration(milliseconds: 200);
}
