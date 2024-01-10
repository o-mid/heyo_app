#include "include/flutter_ios_call_kit/flutter_ios_call_kit_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_ios_call_kit_plugin.h"

void FlutterIosCallKitPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_ios_call_kit::FlutterIosCallKitPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
