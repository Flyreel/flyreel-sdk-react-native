@objc(FlyreelSdkReactNative)
class FlyreelSdkReactNative: NSObject {
    
    @objc(multiply:withB:withResolver:withRejecter:)
    func multiply(a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        resolve(a*b)
    }
    @objc(startSdk:zipCode:accessCode:organizationId:settingsVersion:enviornment:deeplinkUrl:shouldSkipLoginPage:)
    func startSdk(startType: String, zipCode: String, accessCode: String, organizationId: String, settingsVersion: String, enviornment: String, deeplinkUrl: String, shouldSkipLoginPage: Bool) {
    resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        switch startType {
        case "initialize":
            let configuration = FlyreelConfiguration(
                settingsVersion: String(settingsVersion),
                organizationId: organizationId,
                environment: mapEnvironment(environment: enviornment)
            )
            
            FlyreelSDK.shared.set(configuration: configuration)
            result(nil)
        case "open":
            let rootView = UIApplication.shared.delegate!.window!!.rootViewController!
            
            if let deeplinkURL = URL(string: deeplink ?? "") {
                FlyreelSDK.shared.presentFlyreel(on: rootView, deepLinkURL: deeplinkURL, shouldSkipLoginPage: shouldSkipLoginPage)
            } else {
                FlyreelSDK.shared.presentFlyreel(on: rootView)
            }
            result(nil)
        case "openWithCredentials":
            let rootView = UIApplication.shared.delegate!.window!!.rootViewController!
            
            FlyreelSDK.shared.presentFlyreel(on: rootView, zipCode: zipCode, accessCode: accessCode, shouldSkipLoginPage: shouldSkipLoginPage)
            
            result(nil)
        case "enableLogs":
            FlyreelSDK.shared.enableLogs()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    }
}
