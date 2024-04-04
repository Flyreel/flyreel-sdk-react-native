import Flyreel

@objc(FlyreelSdkReactNative)
class FlyreelSdkReactNative: NSObject {
    
    @objc(initialize:settingsVersion:environment:resolve:reject:)
    func initialize(_ organizationId: String, settingsVersion: NSNumber, environment: String, resolve: RCTPromiseResolveBlock,
                    rejecter reject: RCTPromiseRejectBlock) -> Void {
        let configuration = FlyreelConfiguration(
                        settingsVersion: settingsVersion.stringValue,
                        organizationId: organizationId,
                        environment: mapEnvironment(environment: environment)
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
    
    func mapEnvironment(environment: String) -> FlyreelEnvironment {
            switch environment {
            case "production":
                return .production
            case "sandbox":
                return .sandbox
            default:
                return .production
            }
        }
}
