#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_REMAP_MODULE(Flyreel, FlyreelSdkReactNative, NSObject)

RCT_EXTERN_METHOD(initialize:(NSString *)organizationId
                  settingsVersion:(nonnull NSNumber *)settingsVersion
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(initializeWithSandbox:(NSString *)organizationId
                  settingsVersion:(nonnull NSNumber *)settingsVersion
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(initializeWithStaging:(NSString *)organizationId
                  settingsVersion:(nonnull NSNumber *)settingsVersion
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(open:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(openWithDeeplink:(NSString *)deeplinkUrl
                  shouldSkipLoginPage:(BOOL)shouldSkipLoginPage
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(openWithCredentials:(NSString *)zipCode
                  accessCode:(NSString *)accessCode
                  shouldSkipLoginPage:(BOOL)shouldSkipLoginPage
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(checkStatus:(NSString *)zipCode
                  accessCode:(NSString *)accessCode
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(enableLogs:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

@end
