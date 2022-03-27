import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';

import '../../constants/textStyles.dart';

enum CustomTextFieldHeight { Small, Regular }

class CUSTOMTEXTFIELD extends StatefulWidget {
  final String labelText;
  final String? hintText;
  final String initialValue;
  final bool hasClearSign;
  final Function? onChanged;
  final bool hasError;
  final String error;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? textController;
  final bool obscureText;
  final Widget? rightWidget, leftWidget;
  final TextInputType keyboardType;

  final FormFieldValidator<String>? validator;
  final bool? initialFocus;
  final CustomTextFieldHeight heightType;

  const CUSTOMTEXTFIELD({
    Key? key,
    this.heightType = CustomTextFieldHeight.Regular,
    this.hasClearSign = false,
    this.error = "",
    this.textController,
    this.hasError = false,
    this.inputFormatters,
    this.obscureText = false,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.labelText = "",
    this.initialValue = "",
    this.leftWidget,
    this.rightWidget,
    this.validator,
    this.initialFocus,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CUSTOMTEXTFIELD> {
  InputBorder? border;
  Color? fillColor;
  Color? iconColor;
  bool hasFocus = false;

  FocusNode focusNode = FocusNode();

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialFocus == true) {
      focusNode.requestFocus();
    }
    focusNode.addListener(() {
      setState(() {
        hasFocus = focusNode.hasFocus;
      });
    });

    if (widget.textController != null) {
      controller = widget.textController!;
    } else {
      controller.value = TextEditingValue(text: widget.initialValue);
      controller.selection = controller.selection.copyWith(
          baseOffset: widget.initialValue.length,
          extentOffset: widget.initialValue.length);
      controller.addListener(() {
        widget.onChanged == null
            ? null
            : widget.onChanged!((controller.value.text));
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    controller.dispose();
  }

  switchBorders() {
    OutlineInputBorder focusedBorder = OutlineInputBorder(
      gapPadding: 11,
      borderSide: BorderSide(
        color: COLORS.kGreenMainColor,
        width: 2.0,
      ),
    );

    OutlineInputBorder errorBorder = OutlineInputBorder(
        gapPadding: 11,
        borderSide: BorderSide(
            color: COLORS.kStatesErrorColor,
            width: widget.heightType == CustomTextFieldHeight.Small ? 1 : 2.0));

    OutlineInputBorder unFocusedBorder = OutlineInputBorder(
        gapPadding: 11,
        borderSide: BorderSide(color: COLORS.kTextSoftBlueColor, width: 1.0));

    iconColor = widget.hasError
        ? COLORS.kStatesErrorColor
        : hasFocus
            ? COLORS.kGreenMainColor
            : null;

    border = widget.hasError
        ? errorBorder
        : hasFocus
            ? focusedBorder
            : unFocusedBorder;

    fillColor = controller.value.text.isEmpty || widget.hasError
        ? COLORS.kWhiteColor
        : COLORS.kBrightBlueColor;
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      key: this.widget.key,
      children: [
        Container(
          height: 48,
          child: textFieldSection(),
        ),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: fillColor,
            boxShadow: [
              BoxShadow(
                color: COLORS.kGreenLighterColor,
                spreadRadius: 3,
                blurRadius: 0,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Visibility(
            visible: widget.hasError && widget.error.isNotEmpty,
            child: Text(widget.error,
                style: TEXTSTYLES.kButtonSmall
                    .copyWith(color: COLORS.kStatesErrorColor)),
          ),
        )
      ],
    );
  }

  Widget textFieldSection() {
    switchBorders();
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              validator: widget.validator,
              focusNode: focusNode,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              controller: controller,
              style:
                  TEXTSTYLES.kHeaderMedium.copyWith(color: COLORS.kBlackColor),
              inputFormatters: widget.inputFormatters,
              decoration: InputDecoration(
                //errorText: widget.validator(controller.value.text),
                suffixIcon: widget.rightWidget,
                suffixIconColor: iconColor,
                prefixIconColor: iconColor,
                prefixIcon: widget.leftWidget,
                hintText: widget.hintText ?? widget.labelText,
                labelText: widget.labelText,
                hintStyle: TEXTSTYLES.kBodyBasic
                    .copyWith(color: COLORS.kTextSoftBlueColor, fontSize: 15),
                labelStyle: TEXTSTYLES.kBodySmall.copyWith(
                    color: COLORS.kBlackColor, height: 1, fontSize: 15),
                border: border,

                focusedBorder: border,
                enabledBorder: border,
                errorBorder: border,
                disabledBorder: border,
                contentPadding:
                    EdgeInsets.only(left: 16, bottom: 15, top: 15, right: 16),
              ),
            ),
          ),
          widget.hasClearSign && controller.value.text.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(
                    right: 16.0,
                  ),
                  child: removeSign(
                      onPressed: () {
                        controller.clear();
                      },
                      hasError: widget.hasError),
                )
              : Container(),
        ],
      ),
    );
  }
}

Widget removeSign({required Function onPressed, bool hasError = false}) {
  return InkWell(
    onTap: () {
      onPressed();
    },
    child: Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      height: 24,
      width: 24,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              hasError ? COLORS.kStatesErrorColor : COLORS.kTextSoftBlueColor),
      // child: SvgPicture.asset(ImageAsset.closeSign.path),
    ),
  );
}
