package com.flyreelsdkreactnative

import android.app.Application
import android.net.Uri
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise
import com.lexisnexis.risk.flyreel.Flyreel
import com.lexisnexis.risk.flyreel.FlyreelConfiguration
import com.lexisnexis.risk.flyreel.FlyreelEnvironment

class FlyreelSdkReactNativeModule(private val reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return NAME
  }

  @ReactMethod
  fun initialize(
    organizationId: String,
    settingsVersion: Int,
    environment: String = "production",
    promise: Promise
  ) {
    Flyreel.initialize(
      reactApplicationContext.applicationContext as Application,
      FlyreelConfiguration(
        organizationId = organizationId,
        settingsVersion = settingsVersion,
        environment = mapEnvironment(environment)
      )
    )
    promise.resolve(null)
  }

  @ReactMethod
  fun open(promise: Promise) {
    Flyreel.openFlyreel(
      context = reactContext.currentActivity!!
    )
    promise.resolve(null)
  }

  @ReactMethod
  fun openWithDeeplink(deeplinkUrl: String, shouldSkipLoginPage: Boolean, promise: Promise) {
    Flyreel.openFlyreel(
      context = reactContext.currentActivity!!,
      deeplinkUri = Uri.parse(deeplinkUrl),
      shouldSkipLoginPage = shouldSkipLoginPage
    )
    promise.resolve(null)
  }

  @ReactMethod
  fun openWithCredentials(zipCode: String, accessCode: String, shouldSkipLoginPage: Boolean, promise: Promise) {
    Flyreel.openFlyreel(
      context = reactContext.currentActivity!!,
      zipCode = zipCode,
      accessCode = accessCode,
      shouldSkipLoginPage = shouldSkipLoginPage
    )
    promise.resolve(null)
  }

  @ReactMethod
  fun enableLogs(promise: Promise) {
    Flyreel.enableLogs()
    promise.resolve(null)
  }

  private fun mapEnvironment(environment: String) =
    when (environment) {
      "production" -> FlyreelEnvironment.Production
      "sandbox" -> FlyreelEnvironment.Sandbox
      else -> throw Exception("Wrong Flyreel environment")
    }

  companion object {
    const val NAME = "Flyreel"
  }
}
