package com.flyreelsdkreactnative

import android.app.Application
import android.net.Uri
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.WritableMap
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
    promise: Promise
  ) {
    Flyreel.initialize(
      reactApplicationContext.applicationContext as Application,
      FlyreelConfiguration(
        organizationId = organizationId,
        settingsVersion = settingsVersion,
        environment = FlyreelEnvironment.Production
      )
    )
    promise.resolve(null)
  }

  @ReactMethod
  fun initializeWithSandbox(
    organizationId: String,
    settingsVersion: Int,
    promise: Promise
  ) {
    Flyreel.initialize(
      reactApplicationContext.applicationContext as Application,
      FlyreelConfiguration(
        organizationId = organizationId,
        settingsVersion = settingsVersion,
        environment = FlyreelEnvironment.Sandbox
      )
    )
    promise.resolve(null)
  }

  @ReactMethod
  fun initializeWithStaging(
    organizationId: String,
    settingsVersion: Int,
    promise: Promise
  ) {
    Flyreel.initialize(
      reactApplicationContext.applicationContext as Application,
      FlyreelConfiguration(
        organizationId = organizationId,
        settingsVersion = settingsVersion,
        environment = FlyreelEnvironment.Staging
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
  fun checkStatus(zipCode: String, accessCode: String, promise: Promise) {
    Flyreel.fetchFlyreelStatus(
      zipCode = zipCode,
      accessCode = accessCode,
      onSuccess = { status ->
        val map: WritableMap = Arguments.createMap()
        map.putString("status", status.status)
        map.putString("expiration", status.expiration)
        promise.resolve(map)
      },
      onError = { error ->
        promise.reject(error.code.toString(), error.message)
      }
    )
  }

  @ReactMethod
  fun enableLogs(promise: Promise) {
    Flyreel.enableLogs()
    promise.resolve(null)
  }

  companion object {
    const val NAME = "Flyreel"
  }
}
