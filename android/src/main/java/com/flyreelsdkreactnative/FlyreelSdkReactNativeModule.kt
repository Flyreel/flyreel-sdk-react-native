package com.flyreelsdkreactnative

import android.content.Context
import android.telecom.Call
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise

class FlyreelSdkReactNativeModule(reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  private var context: Context? = null
  private var currentActivity: android.app.Activity? = null

  override fun getName(): String {
    return NAME
  }

  // Example method
  // See https://reactnative.dev/docs/native-modules-android
  @ReactMethod
  fun multiply(a: Double, b: Double, promise: Promise) {
    promise.resolve(a * b)
  }


  // I don't know what paramaters to import here
  @ReactMethod
  fun startSdk(startType: String, call: Call, method: ReactMethod, promise: Promise) {

    when (startType) {
      "initialize" -> {
        val arguments = call.arguments as Map<*, *>
        val organizationId = arguments["organizationId"] as String
        val settingsVersion = arguments["settingsVersion"] as Int
        val environment = arguments["environment"] as String

        Flyreel.initialize(
          context as Application, FlyreelConfiguration(
            organizationId = organizationId,
            settingsVersion = settingsVersion,
            environment = mapEnvironment(environment)
          )
        )
        result.success(null)
      }

      "open" -> {
        val arguments = call.arguments as Map<*, *>
        val deeplinkUrl = arguments["deeplinkUrl"] as? String
        val shouldSkipLoginPage = arguments["shouldSkipLoginPage"] as Boolean
        (currentActivity as? Context)?.let {
          Flyreel.openFlyreel(
            context = it,
            deeplinkUri = deeplinkUrl?.let { url -> Uri.parse(url) },
            shouldSkipLoginPage = shouldSkipLoginPage
          )
          result.success(null)
        } ?: result.notImplemented()
      }

      "openWithCredentials" -> {
        val arguments = call.arguments as Map<*, *>
        val zipCode = arguments["zipCode"] as String
        val accessCode = arguments["accessCode"] as String
        val shouldSkipLoginPage = arguments["shouldSkipLoginPage"] as Boolean
        (currentActivity as? Context)?.let {
          Flyreel.openFlyreel(
            context = it,
            zipCode = zipCode,
            accessCode = accessCode,
            shouldSkipLoginPage = shouldSkipLoginPage
          )
          result.success(null)
        } ?: result.notImplemented()
      }

      "enableLogs" -> {
        Flyreel.enableLogs()
        result.success(null)
      }

      else -> result.notImplemented()
    }
    promise.resolve(result)  }

  companion object {
    const val NAME = "FlyreelSdkReactNative"
  }
}
