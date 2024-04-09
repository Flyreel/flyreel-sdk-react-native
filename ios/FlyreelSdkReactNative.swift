import Flyreel

@objc(FlyreelSdkReactNative)
class FlyreelSdkReactNative: NSObject {
    
    @objc(initialize:settingsVersion:resolve:reject:)
    func initialize(_ organizationId: String, settingsVersion: NSNumber, resolve: RCTPromiseResolveBlock,
                    rejecter reject: RCTPromiseRejectBlock) -> Void {
        let configuration = FlyreelConfiguration(
                        settingsVersion: settingsVersion.stringValue,
                        organizationId: organizationId,
                        environment: FlyreelEnvironment.production
                    )
        FlyreelSDK.shared.set(configuration: configuration)
        resolve(nil)
    }

    @objc(initializeWithSandbox:settingsVersion:resolve:reject:)
    func initializeWithSandbox(_ organizationId: String, settingsVersion: NSNumber, resolve: RCTPromiseResolveBlock,
                    rejecter reject: RCTPromiseRejectBlock) -> Void {
        let configuration = FlyreelConfiguration(
                        settingsVersion: settingsVersion.stringValue,
                        organizationId: organizationId,
                        environment: FlyreelEnvironment.sandbox
                    )
        FlyreelSDK.shared.set(configuration: configuration)
        resolve(nil)
    }
    
    @objc(open:reject:)
    func open(_ resolve: RCTPromiseResolveBlock,
              rejecter reject: RCTPromiseRejectBlock) -> Void {
        let rootView = UIApplication.shared.delegate!.window!!.rootViewController!
        FlyreelSDK.shared.presentFlyreel(on: rootView)
        resolve(nil)
    }

    @objc(openWithDeeplink:shouldSkipLoginPage:resolve:reject:)
    func openWithDeeplink(_ deeplink: String, shouldSkipLoginPage: Bool, resolve: RCTPromiseResolveBlock,
              rejecter reject: RCTPromiseRejectBlock) -> Void {

        let rootView = UIApplication.shared.delegate!.window!!.rootViewController!
        if let deeplinkURL = URL(string: deeplink ?? "") {
            FlyreelSDK.shared.presentFlyreel(on: rootView, deepLinkURL: deeplinkURL, shouldSkipLoginPage: shouldSkipLoginPage)
        } else {
            FlyreelSDK.shared.presentFlyreel(on: rootView)
        }
        resolve(nil)
    }
    
    @objc(openWithCredentials:accessCode:shouldSkipLoginPage:resolve:reject:)
    func openWithCredentials(_ zipCode: String, accessCode: String, shouldSkipLoginPage: Bool, resolve: RCTPromiseResolveBlock,
                             rejecter reject: RCTPromiseRejectBlock) -> Void {
        let rootView = UIApplication.shared.delegate!.window!!.rootViewController!
        FlyreelSDK.shared.presentFlyreel(on: rootView, zipCode: zipCode, accessCode: accessCode, shouldSkipLoginPage: shouldSkipLoginPage)
        
        resolve(nil)
    }
    
    @objc(enableLogs:reject:)
    func enableLogs(_ resolve: RCTPromiseResolveBlock,
                    rejecter reject: RCTPromiseRejectBlock) -> Void {
        FlyreelSDK.shared.enableLogs()
        resolve(nil)
    }
}
