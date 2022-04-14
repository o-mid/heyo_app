/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsPngGen {
  const $AssetsPngGen();

  /// File path: assets/png/benefits001.png
  AssetGenImage get benefits001 =>
      const AssetGenImage('assets/png/benefits001.png');

  /// File path: assets/png/benefits002.png
  AssetGenImage get benefits002 =>
      const AssetGenImage('assets/png/benefits002.png');

  /// File path: assets/png/benefits003.png
  AssetGenImage get benefits003 =>
      const AssetGenImage('assets/png/benefits003.png');

  /// File path: assets/png/benefits004.png
  AssetGenImage get benefits004 =>
      const AssetGenImage('assets/png/benefits004.png');

  /// File path: assets/png/icon.png
  AssetGenImage get icon => const AssetGenImage('assets/png/icon.png');

  /// File path: assets/png/keys.png
  AssetGenImage get keys => const AssetGenImage('assets/png/keys.png');

  /// File path: assets/png/profile1.png
  AssetGenImage get profile1 => const AssetGenImage('assets/png/profile1.png');

  /// File path: assets/png/profile2.png
  AssetGenImage get profile2 => const AssetGenImage('assets/png/profile2.png');

  /// File path: assets/png/profile3.png
  AssetGenImage get profile3 => const AssetGenImage('assets/png/profile3.png');

  /// File path: assets/png/profile4.png
  AssetGenImage get profile4 => const AssetGenImage('assets/png/profile4.png');

  /// File path: assets/png/splash.png
  AssetGenImage get splash => const AssetGenImage('assets/png/splash.png');

  /// File path: assets/png/welcome.png
  AssetGenImage get welcome => const AssetGenImage('assets/png/welcome.png');
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/InviteIcon.svg
  SvgGenImage get inviteIcon => const SvgGenImage('assets/svg/InviteIcon.svg');

  /// File path: assets/svg/account.svg
  SvgGenImage get account => const SvgGenImage('assets/svg/account.svg');

  /// File path: assets/svg/call.svg
  SvgGenImage get call => const SvgGenImage('assets/svg/call.svg');

  /// File path: assets/svg/chat.svg
  SvgGenImage get chat => const SvgGenImage('assets/svg/chat.svg');

  /// File path: assets/svg/corePass_logo.svg
  SvgGenImage get corePassLogo =>
      const SvgGenImage('assets/svg/corePass_logo.svg');

  /// File path: assets/svg/heyo_logo.svg
  SvgGenImage get heyoLogo => const SvgGenImage('assets/svg/heyo_logo.svg');

  /// File path: assets/svg/newChatIcon.svg
  SvgGenImage get newChatIcon =>
      const SvgGenImage('assets/svg/newChatIcon.svg');

  /// File path: assets/svg/newGroupIcon.svg
  SvgGenImage get newGroupIcon =>
      const SvgGenImage('assets/svg/newGroupIcon.svg');

  /// File path: assets/svg/new_chat.svg
  SvgGenImage get newChat => const SvgGenImage('assets/svg/new_chat.svg');

  /// File path: assets/svg/search_nearby.svg
  SvgGenImage get searchNearby =>
      const SvgGenImage('assets/svg/search_nearby.svg');

  /// File path: assets/svg/verified.svg
  SvgGenImage get verified => const SvgGenImage('assets/svg/verified.svg');

  /// File path: assets/svg/wallet.svg
  SvgGenImage get wallet => const SvgGenImage('assets/svg/wallet.svg');
}

class Assets {
  Assets._();

  static const $AssetsPngGen png = $AssetsPngGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName);

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    Color? color,
    BlendMode colorBlendMode = BlendMode.srcIn,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    Clip clipBehavior = Clip.hardEdge,
    bool cacheColorFilter = false,
    SvgTheme? theme,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
      theme: theme,
    );
  }

  String get path => _assetName;
}
