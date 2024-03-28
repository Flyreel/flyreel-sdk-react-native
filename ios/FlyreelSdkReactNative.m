#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(FlyreelSdkReactNative, NSObject)

RCT_EXTERN_METHOD(multiply:(float)a withB:(float)b
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD((startType: String, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock))

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
