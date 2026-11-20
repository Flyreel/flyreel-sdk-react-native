# Flyreel React SDK

[![Platform](https://img.shields.io/badge/platform-Android-orange.svg)](https://github.com/Flyreel/flyreel-sdk-android)
[![Platform](https://img.shields.io/badge/platform-iOS-orange.svg)](https://github.com/Flyreel/flyreel-sdk-ios)
[![Languages](https://img.shields.io/badge/language-TS-orange.svg)](https://github.com/Flyreel/flyreel-sdk-react-native)
[![Releases](https://img.shields.io/npm/v/@flyreel/flyreel-sdk-react-native?color=blue)](https://www.npmjs.com/package/@flyreel/flyreel-sdk-react-native)

## Requirements

|              | Minimum                                            |
| ------------ | -------------------------------------------------- |
| React Native | 0.75 (tested on 0.88)                              |
| Android      | minSdk 23, Kotlin 2.1+                             |
| iOS          | 15.1                                               |
| Xcode        | 27.2 (the Flyreel iOS SDK is built with Swift 6.4) |

The wrapper ships the native Flyreel SDKs **1.2.3** for both platforms.

## Installation

```bash
$ npm install --save @flyreel/flyreel-sdk-react-native
# --- or ---
$ yarn add @flyreel/flyreel-sdk-react-native
```

### Android

Nothing else is needed. The library adds the Flyreel Maven repository
(`https://flyreelsdk.jfrog.io/artifactory/flyreel-androidsdk`) to your project. If your app
declares repositories in `settings.gradle` with `RepositoriesMode.FAIL_ON_PROJECT_REPOS`, add that
repository there instead.

### iOS

The Flyreel iOS SDK is distributed through Swift Package Manager only (it isn't on CocoaPods
trunk). How you set it up depends on how your app builds React Native.

#### CocoaPods (default)

1. Run `pod install`. It adds the Flyreel Swift package to the Pods project.
2. The Flyreel SDK ships dynamic frameworks that CocoaPods doesn't embed. Add the package to your
   app target too: in Xcode, open **File > Add Package Dependencies…**, enter
   `https://github.com/Flyreel/flyreel-sdk-ios`, choose **Exact Version** `1.2.3`, and add the
   `Flyreel` product to your app target. Skipping this step makes the app crash at launch with
   `Library not loaded: @rpath/Flyreel.framework`.

Commit the app's `project.pbxproj` and
`<App>.xcworkspace/xcshareddata/swiftpm/Package.resolved` after adding the package.

#### Swift Package Manager (`npx react-native spm`)

No extra steps. The library ships its own `ios/Package.swift`, which React Native's SwiftPM
autolinking picks up.

## Upgrading from 0.1.x (Flyreel SDK 1.2.2)

This release moves to the 1.2.3 native SDKs. The JS API is unchanged apart from the new
`observeDiagnosticEvents`.

1. Check the [requirements](#requirements): React Native 0.75+, iOS deployment target 15.1+, and
   Xcode 27.2+ (locally and in CI).
2. **iOS (CocoaPods):**
   - Remove any `pod 'Flyreel'` (or `FlyreelFNOL`, `FlyreelMeshScan`, `FlyreelPanorama`) lines
     from your Podfile; they're no longer used.
   - Run `pod install`. The pod is now named `flyreel_sdk_react_native` (it was
     `flyreel-sdk-react-native`), so `Podfile.lock` shows the old pod removed and the new one
     added. Autolinking handles this.
   - Add the `flyreel-sdk-ios` package to your app target as described in [iOS](#ios).
3. **Android:** remove the `flyreel-fnol`, `flyreel-meshscan` and `flyreel-panorama` JFrog
   repositories if your app added them. Those modules are now bundled in the main SDK.
4. Optionally subscribe to [diagnostic events](#diagnostic-events-internal).
5. Build both platforms. On iOS, check that `Flyreel.framework` and `FlyreelCamera.framework` are
   in the app bundle's `Frameworks` folder.

## Usage

### Permissions on iOS

Since the SDK actively uses some functionalities of the iOS system you need to provide a few
permission settings in your Info.plist file.

```xml
<dict>
    // ...
    <key>NSCameraUsageDescription</key>
    <string>We need access to the camera.</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>We need access to the microphone.</string>
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>We need access to your location data</string>
</dict>
```

### Importing

```TS
import {
  Flyreel,
  FlyreelEnvironment,
  type FlyreelCheckStatus,
  type FlyreelDiagnosticEvent,
} from '@flyreel/flyreel-sdk-react-native';
```

### Initialization

Initialize Flyreel once, at app start, with your organization ID. The environment defaults to
`FlyreelEnvironment.PRODUCTION`.

```TS
await Flyreel.initialize('5d3633f9103a930011996475');
```

Initialize before calling any other method. On Android, opening Flyreel or subscribing to Flyreel
events before `initialize` throws.

### How to open Flyreel chat

```TS
await Flyreel.open();
```

### Deep Linking

If you're launching the Flyreel flow from a deep link, push notification, or a custom solution where
user details can be provided automatically, use:

```TS
// open with flyreelZipCode and flyreelAccessCode parameters
await Flyreel.openWithCredentials('80212', '6M4T0T', true);

// open with deeplink url with flyreelAccessCode and flyreelZipCode parameters
await Flyreel.openWithDeeplink('https://your.custom.url/?flyreelAccessCode=6M4T0T&flyreelZipCode=80212', true);
```

> [!NOTE]
> Last parameter determines whether you want to skip login page and login automatically.

### Flyreel status check

Check a Flyreel's status without opening the flow:

```TS
try {
  const { status, expiration } = await Flyreel.checkStatus('80212', '6M4T0T');
} catch (error) {
  // error.code is usually the API's HTTP status code as a string, e.g. "404"
}
```

### Custom fonts

If you want to use a custom font for Flyreel chat, you have to provide a ttf file to both iOS and
Android Platform.

- in the Android directory, you can put the ttf file in the main/assets folder or the main/res/font
  folder.
- for iOS, you have to go with
  the [Apple instruction](https://developer.apple.com/documentation/uikit/text_display_and_fonts/adding_a_custom_font_to_your_app)
  to add a custom font to your project.

Then, you can use the font's name in the Flyreel dashboard panel. For example, if you have added
font **my_font.ttf** to the assets folder, you can use **my_font** as a font name in the Flyreel
dashboard.

## Sandbox

Verify your implementation in the sandbox mode:

```TS
await Flyreel.initialize('5d3633f9103a930011996475', FlyreelEnvironment.SANDBOX);
```

## Logging and events

The SDK has three tools for visibility. They're independent; use any combination.

| Tool                        | Use it for                                                         | Reaches JS? |
| --------------------------- | ------------------------------------------------------------------ | ----------- |
| `enableLogs()`              | Debugging on a device connected to Xcode or Android Studio         | No          |
| `observeFlyreelEvents()`    | Product analytics: login, questions, completion, close             | Yes         |
| `observeDiagnosticEvents()` | Production visibility into media capture, uploads, sync and submit | Yes         |

Each `observe…` call returns a function that removes the listener. Subscribe once (for example
at app start, after `initialize`) rather than inside a component that re-renders. Each call adds
another JS listener, so subscribing twice delivers every event twice.

### Debug logs

```TS
Flyreel.enableLogs();
```

The native SDKs then write free-text logs: iOS to `os_log` (Xcode or Console.app, prefixed
`[FlyreelSDK]`), Android to Logcat (tag `FlyreelSDK`). JS can't read these logs, so they never
reach your analytics or crash reporting. Use diagnostic events for production.

### Flyreel events

```TS
const unsubscribe = Flyreel.observeFlyreelEvents((event: any) => {
  switch (event.name) {
    case 'flyreel_completed':
      YourAnalyticsProvider.trackEvent('flyreel_completed', {
        user_id: event.user?.id,
        active_time: event.activeTime,
      });
      break;
    case 'sdk_closed':
      console.log('Flyreel closed', event.activeTime);
      break;
  }
});
```

Each event is a plain object (the callback's TypeScript type says `Map<String, any>`, but the value
isn't a `Map`):

| Field            | Type    | Notes                                                                                                                   |
| ---------------- | ------- | ----------------------------------------------------------------------------------------------------------------------- |
| `name`           | string  | `user_logged_in`, `question_asked`, `question_answered`, `flyreel_completed` or `sdk_closed`                            |
| `timestamp`      | string  | ISO 8601                                                                                                                |
| `user`           | object  | `id`, `botId`, `botName`, `organizationId`, `status`; Android also has `loginType` (`manual_login` \| `deeplink_login`) |
| `activeTime`     | number? | **iOS: seconds, Android: milliseconds.** Absent on `user_logged_in`.                                                    |
| `coordination`   | object? | `{ lat, lng }`, on `user_logged_in` and `question_answered`                                                             |
| `deviceData`     | object? | `phoneModel`, `appVersion`, `appName` (Android also `phoneManufacturer`), on `user_logged_in`                           |
| `messageDetails` | object? | `message`, `messageType`, `moduleKey`, `messageKey` (iOS also `phase`), on `question_asked` and `question_answered`     |

### Diagnostic events (internal)

> [!IMPORTANT]
> Internal API for Flyreel's own apps. The schema can change between SDK releases; check
> `schemaVersion`.

Diagnostic events are structured events about the media pipeline: capture, local save, upload
attempts (with retries, timeouts and resumes), answer submission, background sync and the final
submit. They're meant to be forwarded to tools like FullStory or Firestore so reports of missing
media or failed uploads can be diagnosed in production.

```TS
const unsubscribe = Flyreel.observeDiagnosticEvents((event: FlyreelDiagnosticEvent) => {
  FullStory.event(event.name, event);
  if (event.level !== 'info') {
    firestore()
      .doc(`v4MediaLogs/${event.flyreelId}/events/${event.eventId}`)
      .set(event);
  }
});
```

**Subscribe at app start, before opening Flyreel.** The SDKs don't replay events: anything
emitted with no subscriber is dropped, and background sync can emit events outside the Flyreel
flow. Nothing is persisted by the SDK, so persist on your side if needed.

Each event is a flat object: the envelope fields plus the event's attributes.

| Field           | Type                             | Notes                                                                 |
| --------------- | -------------------------------- | --------------------------------------------------------------------- |
| `eventId`       | string                           | UUID. Use it as the de-duplication key or document ID.                |
| `name`          | string                           | See the catalog below.                                                |
| `timestamp`     | number                           | Milliseconds since the epoch.                                         |
| `level`         | `'info' \| 'warning' \| 'error'` |                                                                       |
| `schemaVersion` | number                           | Bumped on breaking changes to names or attributes.                    |
| `platform`      | string                           | `ios` or `android`                                                    |
| `sdkVersion`    | string                           | Native Flyreel SDK version                                            |
| `flyreelId`     | string                           | Present on every catalog event; groups everything for one inspection. |

Attribute values are strings, numbers or booleans. Optional attributes are omitted when unknown.
Events never contain URLs, tokens, user-entered text, coordinates or addresses.

**Correlation IDs**

| Attribute           | Meaning                                                                            |
| ------------------- | ---------------------------------------------------------------------------------- |
| `answerId`          | `<messageId>:<moduleId>:<iterationId>` for one answer                              |
| `mediaId`           | The captured file's name. Stable across retries and relaunches.                    |
| `attemptId`         | One upload attempt. A new ID per attempt, live or sync.                            |
| `uploadSessionTail` | `…` plus the last 6 characters of the upload session ID, for matching backend logs |
| `origin`            | `live` (right after capture) or `sync` (background or final sync)                  |

Group an item's attempts by `mediaId`, join uploads to answers with `answerId`, and group a whole
inspection by `flyreelId`.

**Event catalog**

| Event                     | Level          | When                                                                           |
| ------------------------- | -------------- | ------------------------------------------------------------------------------ |
| `media_keep_failed`       | error          | The capture couldn't be saved locally.                                         |
| `media_upload_queued`     | info           | A live upload joins the queue.                                                 |
| `media_upload_started`    | info           | An upload attempt (or bundle part) begins.                                     |
| `media_upload_resumed`    | info           | An attempt continues a saved upload session.                                   |
| `media_upload_retrying`   | warning        | A transient failure; the SDK backs off and retries.                            |
| `media_upload_succeeded`  | info           | The attempt finished.                                                          |
| `media_upload_failed`     | error          | The attempt gave up.                                                           |
| `media_upload_cancelled`  | warning        | The attempt was cancelled (re-answer, edit, chat closed, sync timeout).        |
| `media_cached_for_sync`   | warning        | A live upload didn't finish; the answer is cached for sync to retry.           |
| `answer_submit_deferred`  | info           | A media answer is cached for sync because its media is still uploading.        |
| `answer_submit_started`   | info           | A media answer is posted.                                                      |
| `answer_submit_succeeded` | info           | The post succeeded.                                                            |
| `answer_submit_failed`    | warning        | The post failed; the answer stays cached for sync.                             |
| `sync_pass_started`       | info           | A sync pass with cached answers begins.                                        |
| `media_answer_skipped`    | error          | Sync dropped an answer because its media file is gone. **That media is lost.** |
| `sync_pass_finished`      | info / warning | A sync pass ends (`result`: `ok`, `partial` or `failed`).                      |
| `flyreel_submit_summary`  | info / error   | The final submit ran. `mediaStillLocal > 0` means media was lost.              |

Failures carry `reason` and, when known, `httpStatus` and `errorCode` (an iOS `URLError` code or
an Android exception class name). `reason` is one of `offline`, `connection_lost`, `timeout`,
`server_error`, `rate_limited`, `session_rejected`, `unauthenticated`, `api_error`,
`no_upload_url`, `no_download_url`, `incomplete_upload`, `file_missing`, `file_changed`,
`empty_file`, `keep_failed`, `media_pending`, `cancelled` or `unknown`.

Events worth alerting on:

- `media_answer_skipped`
- `media_keep_failed`
- `flyreel_submit_summary` with `mediaStillLocal > 0` or `unsyncedAnswers > 0`
- `media_upload_failed`, grouped by `reason`

Volume is low: about 3–8 events per media item, plus a few per sync pass and per submit.

## Firewall whitelisting

Here is a list of Flyreel's hosts in case you need to whitelist URLs.

```
api3.flyreel.co
sandbox.api3.flyreel.co
```
