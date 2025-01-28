import { NativeEventEmitter, NativeModules, Platform } from 'react-native';

interface FlyreelSDK {
  initialize(
    organizationId: String,
    environment?: FlyreelEnvironment
  ): Promise<void>;
  open(): Promise<void>;
  openWithDeeplink(
    deeplinkUrl: String,
    shouldSkipLoginPage: boolean
  ): Promise<void>;
  openWithCredentials(
    zipCode: String,
    accessCode: String,
    shouldSkipLoginPage: boolean
  ): Promise<void>;
  checkStatus(zipCode: String, accessCode: String): Promise<FlyreelCheckStatus>;
  enableLogs(): Promise<void>;
  observeAnalyticEvents(callback: (data: Map<String, any>) => void): () => void;
}

// Define the FlyreelEnvironment enum
export enum FlyreelEnvironment {
  PRODUCTION = 'production',
  SANDBOX = 'sandbox',
  STAGING = 'staging',
}

export type FlyreelCheckStatus = {
  // The status of the Flyreel.
  status: string;

  // The expiration date for Flyreel.
  expiration: string;
};

const LINKING_ERROR =
  `The package '@flyreel/flyreel-sdk-react-native' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const FlyreelModule = NativeModules.Flyreel
  ? NativeModules.Flyreel
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

const eventEmitter = new NativeEventEmitter(NativeModules.Flyreel);

export const Flyreel: FlyreelSDK = {
  initialize(
    organizationId: String,
    environment: FlyreelEnvironment = FlyreelEnvironment.PRODUCTION
  ): Promise<void> {
    return FlyreelModule.initialize(organizationId, environment);
  },

  async checkStatus(
    zipCode: String,
    accessCode: String
  ): Promise<FlyreelCheckStatus> {
    const checkStatus = await FlyreelModule.checkStatus(zipCode, accessCode);
    return { status: checkStatus.status, expiration: checkStatus.expiration };
  },

  observeAnalyticEvents(callback: (data: Map<String, any>) => void) {
    FlyreelModule.addAnalyticEventsListener();

    const subscription = eventEmitter.addListener(
      'FlyreelAnalyticEvent',
      callback
    );

    // Return a function to remove the listener
    return () => subscription.remove();
  },
  open: function (): Promise<void> {
    return FlyreelModule.open();
  },

  openWithDeeplink: function (
    deeplinkUrl: String,
    shouldSkipLoginPage: boolean
  ): Promise<void> {
    return FlyreelModule.openWithDeeplink(deeplinkUrl, shouldSkipLoginPage);
  },
  openWithCredentials: function (
    zipCode: String,
    accessCode: String,
    shouldSkipLoginPage: boolean
  ): Promise<void> {
    return FlyreelModule.openWithCredentials(
      zipCode,
      accessCode,
      shouldSkipLoginPage
    );
  },
  enableLogs: function (): Promise<void> {
    return FlyreelModule.enableLogs();
  },
};
