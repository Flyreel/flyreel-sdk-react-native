@_spi(FlyreelInternal) import Flyreel

@objc(FlyreelSdkReactNative)
class FlyreelSdkReactNative: RCTEventEmitter {

  @objc(initialize:environment:resolve:reject:)
  func initialize(
    _ organizationId: String, environment: String,
    resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock
  ) {
    let configuration = FlyreelConfiguration(
      organizationId: organizationId,
      environment: mapEnvironment(environment: environment)
    )
    FlyreelSDK.shared.set(configuration: configuration)
    resolve(nil)
  }

  @objc(open:reject:)
  func open(
    _ resolve: RCTPromiseResolveBlock,
    rejecter reject: RCTPromiseRejectBlock
  ) {
    let rootView = UIApplication.shared.delegate!.window!!.rootViewController!
    FlyreelSDK.shared.presentFlyreel(on: rootView)
    resolve(nil)
  }

  @objc(openWithDeeplink:shouldSkipLoginPage:resolve:reject:)
  func openWithDeeplink(
    _ deeplink: String, shouldSkipLoginPage: Bool,
    resolve: RCTPromiseResolveBlock,
    rejecter reject: RCTPromiseRejectBlock
  ) {

    let rootView = UIApplication.shared.delegate!.window!!.rootViewController!
    if let deeplinkURL = URL(string: deeplink ?? "") {
      FlyreelSDK.shared.presentFlyreel(
        on: rootView, deepLinkURL: deeplinkURL,
        shouldSkipLoginPage: shouldSkipLoginPage)
    } else {
      FlyreelSDK.shared.presentFlyreel(on: rootView)
    }
    resolve(nil)
  }

  @objc(openWithCredentials:accessCode:shouldSkipLoginPage:resolve:reject:)
  func openWithCredentials(
    _ zipCode: String, accessCode: String, shouldSkipLoginPage: Bool,
    resolve: RCTPromiseResolveBlock,
    rejecter reject: RCTPromiseRejectBlock
  ) {
    let rootView = UIApplication.shared.delegate!.window!!.rootViewController!
    FlyreelSDK.shared.presentFlyreel(
      on: rootView, zipCode: zipCode, accessCode: accessCode,
      shouldSkipLoginPage: shouldSkipLoginPage)

    resolve(nil)
  }

  @objc(checkStatus:accessCode:resolve:reject:)
  func checkStatus(
    _ zipCode: String, accessCode: String,
    resolve: @escaping RCTPromiseResolveBlock,
    rejecter reject: @escaping RCTPromiseRejectBlock
  ) {
    FlyreelSDK.shared.fetchFlyreelStatus(
      zipCode: zipCode, accessCode: accessCode
    ) { statusResult in
      switch statusResult {
      case .success(let flyreelStatus):
        let result: NSMutableDictionary = [:]
        result["status"] = flyreelStatus.status
        result["expiration"] = flyreelStatus.expiration
        resolve(result)
      case .failure(let error):
        if case FlyreelError.apiError(let message, let code) = error {
          reject(String(code), message, nil)
        } else {
          reject("500", "Unexpected error", error)
        }
      }
    }
  }

  @objc(enableLogs:reject:)
  func enableLogs(
    _ resolve: RCTPromiseResolveBlock,
    rejecter reject: RCTPromiseRejectBlock
  ) {
    FlyreelSDK.shared.enableLogs()
    resolve(nil)
  }

  func mapEnvironment(environment: String) -> FlyreelEnvironment {
    switch environment {
    case "production":
      return .production
    case "sandbox":
      return .sandbox
    case "staging":
      return .staging
    default:
      return .production
    }
  }

  // Supported events
  override func supportedEvents() -> [String] {
    return ["FlyreelEvent", "onClose"]
  }

  @objc(addFlyreelEventListener:reject:)
  func addFlyreelEventListener(
    _ resolve: RCTPromiseResolveBlock,
    rejecter reject: RCTPromiseRejectBlock
  ) {
    FlyreelSDK.shared.observeFlyreelEvents { event in
      self.sendEvent(
        withName: "FlyreelEvent", body: event.toFlutterMap())
    }
    resolve(nil)
  }

}
extension FlyreelEvent {
  func toFlutterMap() -> [String: Any?] {
    return [
      "user": user?.toFlutterMap(),
      "name": name,
      "timestamp": ISO8601DateFormatter().string(from: timestamp),
      "activeTime": activeTimeFromTrigger(),
      "coordination": coordinationFromTrigger()?.toFlutterMap(),
      "deviceData": deviceDataFromTrigger()?.toFlutterMap(),
      "messageDetails": messageDetailsFromTrigger()?.toFlutterMap(),
    ]
  }

  private func activeTimeFromTrigger() -> TimeInterval? {
    switch trigger {
    case .questionAsked(let activeTime, _),
        .questionAnswered(let activeTime, _, _),
        .flyreelCompleted(let activeTime),
        .sdkClosed(let activeTime):
      return activeTime
    case .userLoggedIn:
      return nil
    }
  }

  private func coordinationFromTrigger() -> FlyreelCoordinate? {
    switch trigger {
    case .questionAnswered(_, let location, _),
      .userLoggedIn(_, _, let location, _):
      return location
    default:
      return nil
    }
  }

  private func deviceDataFromTrigger() -> FlyreelDeviceData? {
    switch trigger {
    case .userLoggedIn(_, let deviceData, _, _):
      return deviceData
    default:
      return nil
    }
  }

  private func messageDetailsFromTrigger() -> EventMessageDetails? {
    switch trigger {
    case .questionAsked(_, let message),
      .questionAnswered(_, _, let message):
      return message
    default:
      return nil
    }
  }
}

extension FlyreelDeviceData {
  func toFlutterMap() -> [String: String?] {
    return [
      "phoneModel": phoneModel,
      "appVersion": appVersion,
      "appName": appName,
    ]
  }
}

extension FlyreelCoordinate {
  func toFlutterMap() -> [String: Any] {
    return [
      "lat": lat,
      "lng": lng,
    ]
  }
}

extension EventMessageDetails {
  func toFlutterMap() -> [String: Any] {
    return [
      "message": message,
      "messageType": messageType,
      "moduleKey": moduleKey,
      "messageKey": messageKey,
      "phase": phase,
    ]
  }
}

extension FlyreelAnalyticUser {
  func toFlutterMap() -> [String: Any?] {
    return [
      "id": flyreelID,
      "botId": botId,
      "botName": botName,
      "organizationId": organizationId,
      "status": status,
    ]
  }
}
