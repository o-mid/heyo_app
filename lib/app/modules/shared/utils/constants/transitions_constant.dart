// ignore_for_file: constant_identifier_names

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

class TRANSITIONS {
  // Navigation transitions
  /// Transition.fade (general navigation)
  static const navigation_generalPageTransition = Transition.fade;

  /// Duration(milliseconds: 150) (general navigation)
  static const navigation_generalPageTransitionDurtion = Duration(milliseconds: 150);

  ///  Curves.linear (general navigation)
  static const navigation_generalPageTransitionCurve = Curves.linear;

  // messaging screen transitions
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

  static const messagingPage_KeyboardVisibilityDurtion = Duration(milliseconds: 150);
  static const messagingPage_KeyboardVisibilityCurve = Curves.ease;

  static const messagingPage_closeMessagesLoadingShimmerDurtion = Duration(milliseconds: 200);

  static const messagingPage_DatachannelConnectionStatusDurtion = Duration(milliseconds: 400);
  static const messagingPage_DatachannelConnectionStatusCurve = Curves.easeInOut;

  // call screen transitions
  static const callPage_DraggableVideoAnimatedSizeCurve = Curves.easeInOut;

  // SingUp screen transitions
  static const singupPage_ChangePageIndicatorsDurtion = Duration(milliseconds: 350);
  static const singupPage_ChangePageIndicatorsCurve = Curves.ease;

  // ConnectionStatusWidget transitions
  static const connectionStatus_StatusSwitcherDurtion = Duration(milliseconds: 400);
  static const connectionStatus_StatusCurve = Curves.easeInOut;
}
