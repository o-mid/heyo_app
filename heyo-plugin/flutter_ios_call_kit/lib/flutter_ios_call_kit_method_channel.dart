import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_ios_call_kit_platform_interface.dart';

/// An implementation of [FlutterIosCallKitPlatform] that uses method channels.
class MethodChannelFlutterIosCallKit extends FlutterIosCallKitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ios_call_kit');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
