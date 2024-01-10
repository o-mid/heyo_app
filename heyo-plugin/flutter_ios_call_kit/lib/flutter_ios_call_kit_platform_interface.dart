import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_ios_call_kit_method_channel.dart';

abstract class FlutterIosCallKitPlatform extends PlatformInterface {
  /// Constructs a FlutterIosCallKitPlatform.
  FlutterIosCallKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterIosCallKitPlatform _instance = MethodChannelFlutterIosCallKit();

  /// The default instance of [FlutterIosCallKitPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterIosCallKit].
  static FlutterIosCallKitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterIosCallKitPlatform] when
  /// they register themselves.
  static set instance(FlutterIosCallKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
