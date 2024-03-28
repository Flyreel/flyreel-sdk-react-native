package com.flyreelsdkreactnative

import android.app.Application
import android.content.Context
import android.net.Uri
import android.telecom.Call
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise
import com.lexisnexis.risk.flyreel.Flyreel
import com.lexisnexis.risk.flyreel.FlyreelConfiguration
import com.lexisnexis.risk.flyreel.FlyreelEnvironment

class FlyreelSdkReactNativeModule(reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  private var context: Context? = null
  private var currentActivity: android.app.Activity? = null

  override fun getName(): String {
    return NAME
  }

  private fun mapEnvironment(environment: String) =
    when (environment) {
      "production" -> FlyreelEnvironment.Production
      "sandbox" -> FlyreelEnvironment.Sandbox
      else -> throw Exception("Wrong Flyreel environment")
    }

  // Example method
  // See https://reactnative.dev/docs/native-modules-android
  @ReactMethod
  fun multiply(a: Double, b: Double, promise: Promise) {
    promise.resolve(a * b)
  }


  @ReactMethod
  fun startSdk(startType: String,zipCode: String, accessCode: String, organizationId: String, settingsVersion: Int, environment: String, deeplinkUrl: String, shouldSkipLoginPage: Boolean, promise: Promise) {

    when (startType) {
      "initialize" -> {
        Flyreel.initialize(
          context as Application, FlyreelConfiguration(
            organizationId = organizationId,
            settingsVersion = settingsVersion,
            environment = mapEnvironment(environment)
          )
        )
        promise.resolve(null)
      }

      "open" -> {
        (currentActivity as? Context)?.let {
          Flyreel.openFlyreel(
            context = it,
            deeplinkUri = deeplinkUrl?.let { url -> Uri.parse(url) },
            shouldSkipLoginPage = shouldSkipLoginPage
          )
          promise.resolve(null)
        } ?: promise.reject("")
      }

      "openWithCredentials" -> {

        (currentActivity as? Context)?.let {
          Flyreel.openFlyreel(
            context = it,
            zipCode = zipCode,
            accessCode = accessCode,
            shouldSkipLoginPage = shouldSkipLoginPage
          )
          promise.resolve(null)
        } ?: promise.reject("")
      }

      "enableLogs" -> {
        Flyreel.enableLogs()
        promise.resolve(null)
      }

      else -> promise.reject("")
    }
  }
  companion object {
    const val NAME = "FlyreelSdkReactNative"
  }
}
