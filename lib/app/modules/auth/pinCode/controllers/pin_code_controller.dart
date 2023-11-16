import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/auth/pinCode/views/pin_code_view.dart';
import 'package:heyo/app/modules/shared/widgets/snackbar_widget.dart';

import '../../../shared/utils/constants/colors.dart';

class PinCodeController extends GetxController {
  //TODO: Implement PinCodeController
  TextEditingController pinCodeController = TextEditingController();

  /// First input
  final pinCodeInput = ''.obs;

  ///  Repeat input
  final pinCodeConfirm = ''.obs;

  /// Final confirmed pin code
  final ConfirmedPinCode = ''.obs;

  /// change the text to determine type of pin code or repeat mode
  final typeAgain = false.obs;

  onCompleted(String value) {
    // check that if the pin code alredy has value and need to be confirmed or not
    if (pinCodeInput.value == "") {
      pinCodeInput.value = value;

      // for changeing the title text in ui
      typeAgain.value = true;
      pinCodeController.clear();
    }
    // if pinCodeInput already has a value
    else {
      pinCodeConfirm.value = value;
      // check if the pin code and repeat pin code are the same
      if (pinCodeInput.value == pinCodeConfirm.value) {
        // TODO : impliment the next steps after pin code is confirmed
        ConfirmedPinCode.value = pinCodeInput.value;
        Get.bottomSheet(
          bottomSheet,
          backgroundColor: COLORS.kWhiteColor,
          isDismissible: false,
          persistent: true,
          enableDrag: false,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        );

        // pinCodeController.dispose();
      }
      // if the pin code and repeat pin code are not the same
      else {
        SnackBarWidget.error(
          message: 'Pin code is incorrect, please try again.',
        );
        // clear the valtue of pin code input and repeat pin code input
        ClearInput();
        pinCodeController.clear();
      }
      ;
    }
  }

  void ClearInput() {
    pinCodeInput.value = "";
    pinCodeConfirm.value = "";
    typeAgain.value = false;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
