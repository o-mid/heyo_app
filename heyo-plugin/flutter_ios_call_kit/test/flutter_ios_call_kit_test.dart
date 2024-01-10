import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ios_call_kit/flutter_ios_call_kit.dart';
import 'package:flutter_ios_call_kit/flutter_ios_call_kit_platform_interface.dart';
import 'package:flutter_ios_call_kit/flutter_ios_call_kit_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterIosCallKitPlatform
    with MockPlatformInterfaceMixin
    implements FlutterIosCallKitPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterIosCallKitPlatform initialPlatform = FlutterIosCallKitPlatform.instance;

  test('$MethodChannelFlutterIosCallKit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterIosCallKit>());
  });

  test('getPlatformVersion', () async {
    FlutterIosCallKit flutterIosCallKitPlugin = FlutterIosCallKit();
    MockFlutterIosCallKitPlatform fakePlatform = MockFlutterIosCallKitPlatform();
    FlutterIosCallKitPlatform.instance = fakePlatform;

    expect(await flutterIosCallKitPlugin.getPlatformVersion(), '42');
  });
}
