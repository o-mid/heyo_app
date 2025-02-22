import UIKit
import PushKit
import Flutter
import flutter_local_notifications
import flutter_ios_call_kit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }
      
     // This is required to make any communication available in the action isolate.
      FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
      }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Call back from Recent history
  override func application(_ application: UIApplication,
                            continue userActivity: NSUserActivity,
                            restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

      guard let handleObj = userActivity.handle else {
          return false
      }

      guard let isVideo = userActivity.isVideo else {
          return false
      }
      let objData = handleObj.getDecryptHandle()
      let nameCaller = objData["nameCaller"] as? String ?? ""
      let handle = objData["handle"] as? String ?? ""
      let data = flutter_ios_call_kit.Data(id: UUID().uuidString, nameCaller: nameCaller, handle: handle, type: isVideo ? 1 : 0)
      //set more data...
      //data.nameCaller = nameCaller
      SwiftFlutterIosCallKitPlugin.sharedInstance?.startCall(data, fromPushKit: true)

      return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
  }

  // Handle updated push credentials
  func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
      print(credentials.token)
      let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
      print(deviceToken)
      //Save deviceToken to your server
      SwiftFlutterIosCallKitPlugin.sharedInstance?.setDevicePushTokenVoIP(deviceToken)
  }

  func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
      print("didInvalidatePushTokenFor")
      SwiftFlutterIosCallKitPlugin.sharedInstance?.setDevicePushTokenVoIP("")
  }

  // Handle incoming pushes
  func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
      print("didReceiveIncomingPushWith")
      guard type == .voIP else { return }

      let id = payload.dictionaryPayload["id"] as? String ?? ""
      let nameCaller = payload.dictionaryPayload["nameCaller"] as? String ?? ""
      let handle = payload.dictionaryPayload["handle"] as? String ?? ""
      let isVideo = payload.dictionaryPayload["isVideo"] as? Bool ?? false

      let data = flutter_ios_call_kit.Data(id: id, nameCaller: nameCaller, handle: handle, type: isVideo ? 1 : 0)
      //set more data
      data.extra = ["user": "abc@123", "platform": "ios"]
      //data.iconName = ...
      //data.....
      SwiftFlutterIosCallKitPlugin.sharedInstance?.showCallkitIncoming(data, fromPushKit: true)

      //Make sure call completion()
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
          completion()
      }
  }

}
