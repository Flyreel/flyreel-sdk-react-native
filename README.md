# Flyreel React SDK

[![Platform](https://img.shields.io/badge/platform-Android-orange.svg)](https://github.com/Flyreel/flyreel-sdk-android)
[![Platform](https://img.shields.io/badge/platform-iOS-orange.svg)](https://github.com/Flyreel/flyreel-sdk-ios)
[![Languages](https://img.shields.io/badge/language-TS-orange.svg)](https://github.com/Flyreel/flyreel-sdk-react-native)
[![Releases](https://img.shields.io/npm/v/flyreel-sdk-react-native?color=blue)](https://www.npmjs.com/package/flyreel-sdk-react-native)

## Requirements:

### Android

- Android 6+ (minSdk 23)

### iOS

- iOS 13+

## Installation

```bash
$ npm install --save flyreel-sdk-react-native
# --- or ---
$ yarn add flyreel-sdk-react-native
```

_Don't forget to run `pod install` after that !_

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
    <string>We need access to the camera.</string>
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>We need access to your location data</string>
</dict>
```

### Initialization

To use the Flyreel SDK, you must provide a configuration with the following parameters:

`settingsVersion`: Identifier of your remote SDK settings.

`organizationId`: Identifier of your organization.

In your App.tsx file, initialize Flyreel using provided object:

```TS
// initialize Flyreel with organizationId and settingsVersion
await Flyreel.initialize('5d3633f9103a930011996475', 1);
```

### How to open Flyreel chat

Invoke openFlyreel()

```TS
Flyreel.open();
```

### Deep Linking

If you're launching the Flyreel flow from a deep link, push notification, or a custom solution where
user details can be provided automatically, use:

```TS
// open with flyreelZipCode and flyreelAccessCode parameters
Flyreel.openWithCredentials('80212', '6M4T0T', true);

// open with deeplink url with flyreelAccessCode and flyreelZipCode parameters
Flyreel.openWithDeeplink('https://your.custom.url/?flyreelAccessCode=6M4T0T&flyreelZipCode=8021', true);
```
> [!NOTE]
> Last parameter determines whether you want to skip login page and login automatically.

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

## Debug Logs

Enable debug logging for troubleshooting purposes:

```TS
Flyreel.enableLogs();
```

## Sandbox

Verify your implementation in the sandbox mode. Initialize Flyreel with sandbox environment:

```TS
await Flyreel.initializeWithSandbox('5d3633f9103a930011996475', 1);
```