import '../../constants/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/inputs/custom_input_border.dart';

enum CustomTextFieldHeight { Small, Regular }

class CustomTextField extends StatefulWidget {
  final String labelText;
  final String? hintText;
  final String initialValue;
  final bool hasClearSign;
  final Function(String)? onChanged;
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
  final bool autofocus;

  const CustomTextField({
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
    this.autofocus = false,
    super.key,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  InputBorder? border;
  Color? fillColor;
  Color? iconColor;
  bool hasFocus = false;

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
    // only dispose the text editing controller if it is not provided,
    // this will fix the error of the text controller was used after being disposed on TabBar changed
    if (widget.textController == null) {
      controller.dispose();
    }
  }

  InputBorder inputBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: Colors.transparent),
  );

  switchBorders() {
    OutlineInputBorder focusedBorder = CustomInputBorder(
        gapPadding: 8,
        borderSide: BorderSide(
          color: COLORS.kGreenMainColor,
          width: 2.0,
        ),
        secondBorderWidth: 3,
        fillColor: fillColor,
        secondBorderColor: COLORS.kGreenLighterColor);

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
    return Column(
      key: widget.key,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textFieldSection(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 4.0, 0, 0),
          child: Visibility(
            visible: widget.hasError && widget.error.isNotEmpty,
            child: Text(
              widget.error,
              style: TEXTSTYLES.kButtonSmall.copyWith(
                color: COLORS.kStatesErrorColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget textFieldSection() {
    //Removing borders for input design
    //switchBorders();
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              onChanged: widget.onChanged,
              autofocus: widget.autofocus,
              validator: widget.validator,
              focusNode: focusNode,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              controller: controller,
              style: TEXTSTYLES.kHeaderMedium.copyWith(
                color: COLORS.kBlackColor,
              ),
              inputFormatters: widget.inputFormatters,
              decoration: InputDecoration(
                fillColor: COLORS.kBrightBlueColor,
                filled: true,
                //errorText: widget.validator(controller.value.text),
                suffixIcon: widget.rightWidget,
                suffixIconColor: iconColor,
                prefixIconColor: iconColor,
                prefixIcon: widget.leftWidget,
                hintText: widget.hintText ?? widget.labelText,
                //labelText: widget.labelText,
                hintStyle: TEXTSTYLES.kBodyBasic.copyWith(
                  color: COLORS.kTextSoftBlueColor,
                  fontSize: 15,
                ),
                labelStyle: TEXTSTYLES.kBodySmall.copyWith(
                  color: COLORS.kBlackColor,
                  height: 1,
                  fontSize: 15,
                ),
                //border: border,
                //focusedBorder: border,
                //enabledBorder: InputBorder.none,
                //errorBorder: border,
                //disabledBorder: border,
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: inputBorder,
                errorBorder: inputBorder,
                focusedErrorBorder: inputBorder,
                disabledBorder: inputBorder,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: hasError ? COLORS.kStatesErrorColor : COLORS.kTextSoftBlueColor,
      ),
      // child: SvgPicture.asset(ImageAsset.closeSign.path),
    ),
  );
}
