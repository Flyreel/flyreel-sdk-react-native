import { NativeModules, Platform } from 'react-native';

type FlyreelSDKType = {
  initialize(organizationId: String, settingsVersion: number): Promise<void>;
  initializeWithSandbox(
    organizationId: String,
    settingsVersion: number
  ): Promise<void>;
  open(): Promise<void>;
  openWithDeeplink(
    deeplinkUrl: String,
    shouldSkipLoginPage: Boolean
  ): Promise<void>;
  openWithCredentials(
    zipCode: String,
    accessCode: String,
    shouldSkipLoginPage: boolean
  ): Promise<void>;
  enableLogs(): Promise<void>;
};

const LINKING_ERROR =
  `The package 'flyreel-sdk-react-native' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const Flyreel = NativeModules.Flyreel
  ? NativeModules.Flyreel
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export default Flyreel as FlyreelSDKType;
