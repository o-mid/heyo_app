import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'expandable_bottom_sheet_controller.dart';

/// An enum representing different sides of a screen
enum Side { Top, Bottom }

/// Bottom app bar with an animated, expandable content body
class ExpandableBottomSheet extends StatefulWidget {
  /// The content visible when the [ExpandableBottomSheet]
  /// is expanded
  final Widget? expandedBody;

  /// The height of the expanded [ExpandableBottomSheet]
  final double? expandedHeight;

  /// The content of the bottom sheet
  final Widget? bottomSheetBody;

  /// A [ExpandableBottomSheetController] to use with the
  /// [ExpandableBottomSheet]
  final ExpandableBottomSheetController? controller;

  /// A [Side] which determines which side of the
  /// screen the panel is attached to
  final Side attachSide;

  /// Height of the bottom sheet
  final double height;

  /// [BoxConstraints] which determines the final height
  /// of the panel
  final BoxConstraints? constraints;

  /// Background [Color] for the panel
  final Color? expandedBackColor;

  /// [Color] of the bottom sheet
  final Color? bottomSheetColor;

  /// Margin on the horizontal axis
  /// for the bottom app bar content
  final double horizontalMargin;

  /// Offset for the content from
  /// the bottom of the bottom app bar
  final double bottomOffset;

  /// [Decoration] for the panel container
  final Decoration? expandedDecoration;

  /// [Decoration] for the bottom app bar
  final Decoration? sheetDecoration;

  const ExpandableBottomSheet({
    Key? key,
    this.expandedBody,
    this.expandedHeight,
    this.horizontalMargin = 16,
    this.bottomOffset = 10,
    this.height = kToolbarHeight,
    this.attachSide = Side.Bottom,
    this.constraints,
    this.bottomSheetColor,
    this.sheetDecoration,
    this.bottomSheetBody,
    this.expandedBackColor,
    this.expandedDecoration,
    this.controller,
  })  : assert(!(expandedBackColor != null && expandedDecoration != null)),
        super(key: key);

  @override
  _ExpandableBottomSheetState createState() => _ExpandableBottomSheetState();
}

class _ExpandableBottomSheetState extends State<ExpandableBottomSheet> {
  ExpandableBottomSheetController? _controller;
  late double panelState;

  void _handleBottomBarControllerAnimationTick() {
    if (_controller!.state.value == panelState) return;
    panelState = _controller!.state.value;
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateBarController();
    panelState = _controller!.state.value;
  }

  @override
  void didUpdateWidget(ExpandableBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) _updateBarController();
  }

  @override
  void dispose() {
    _controller?.state.removeListener(_handleBottomBarControllerAnimationTick);
    // We don't own the _controller Animation, so it's not disposed here.
    super.dispose();
  }

  void _updateBarController() {
    final ExpandableBottomSheetController newController =
        widget.controller ?? DefaultBottomBarController.of(context);

    if (newController == _controller) return;

    if (_controller != null) {
      _controller!.state.removeListener(_handleBottomBarControllerAnimationTick);
    }

    _controller = newController;

    if (_controller != null) {
      _controller!.state.addListener(_handleBottomBarControllerAnimationTick);
    }
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets viewPadding = widget.attachSide == Side.Bottom
        ? EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom)
        : EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);

    return LayoutBuilder(
      builder: (context, layoutConstraints) {
        final constraints = widget.constraints ??
            layoutConstraints.deflate(
              EdgeInsets.only(
                top: kToolbarHeight * 1.5,
                bottom: widget.height,
              ),
            );

        final finalHeight = widget.expandedHeight ?? constraints.maxHeight - viewPadding.vertical;

        _controller!.dragLength = finalHeight;

        return Stack(
          alignment:
              widget.attachSide == Side.Bottom ? Alignment.bottomCenter : Alignment.topCenter,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.horizontalMargin),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, -3),
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.05),
                        )
                      ],
                    ),
                    child: Container(
                      height: panelState * finalHeight +
                          widget.height +
                          widget.bottomOffset +
                          viewPadding.vertical,
                      decoration: widget.expandedDecoration ??
                          BoxDecoration(
                            color: widget.expandedBackColor,
                            borderRadius: BorderRadius.circular(20.r).copyWith(
                              bottomLeft: Radius.zero,
                              bottomRight: Radius.zero,
                            ),
                          ),
                      child: Opacity(
                        opacity: panelState > 0.25 ? 1 : panelState * 4,
                        child: widget.expandedBody,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: widget.height,
              child: Transform.scale(
                scale: 1 - panelState,
                child: widget.bottomSheetBody,
              ),
            ),
          ],
        );
      },
    );
  }
}
