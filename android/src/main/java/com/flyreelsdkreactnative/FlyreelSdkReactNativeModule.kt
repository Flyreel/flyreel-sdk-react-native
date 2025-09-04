package com.flyreelsdkreactnative

import android.app.Application
import android.net.Uri
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.WritableArray
import com.facebook.react.bridge.WritableMap
import com.lexisnexis.risk.flyreel.Flyreel
import com.lexisnexis.risk.flyreel.FlyreelAnalyticEvent
import com.lexisnexis.risk.flyreel.FlyreelAnalyticUser
import com.lexisnexis.risk.flyreel.FlyreelConfiguration
import com.lexisnexis.risk.flyreel.FlyreelCoordination
import com.lexisnexis.risk.flyreel.FlyreelDeviceData
import com.lexisnexis.risk.flyreel.FlyreelEnvironment
import com.lexisnexis.risk.flyreel.FlyreelInternalApi
import com.lexisnexis.risk.flyreel.FlyreelMessageDetails


class FlyreelSdkReactNativeModule(private val reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return NAME
  }

  @ReactMethod
  fun initialize(
    organizationId: String,
    environment: String,
    promise: Promise
  ) {
    Flyreel.initialize(
      reactApplicationContext.applicationContext as Application,
      FlyreelConfiguration(
        organizationId = organizationId,
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

  @ReactMethod
  fun addAnalyticEventsListener() {
    Flyreel.observeAnalyticEvents { event ->
      sendEvent(reactContext, event.toMap())
    }
  }

  @ReactMethod
  fun registerOnClose(promise: Promise) {
    Flyreel.registerOnClose {
      reactContext.emitDeviceEvent("onClose", null)
    }
    promise.resolve(null)
  }

  @OptIn(FlyreelInternalApi::class)
  private fun mapEnvironment(environment: String) =
    when (environment) {
      "production" -> FlyreelEnvironment.Production
      "sandbox" -> FlyreelEnvironment.Sandbox
      "staging" -> FlyreelEnvironment.Staging
      else -> throw Exception("Wrong Flyreel environment")
    }

  private fun sendEvent(reactContext: ReactContext, params: WritableMap?) {
    reactContext.emitDeviceEvent("FlyreelAnalyticEvent", params)
  }

  companion object {
    const val NAME = "Flyreel"
  }
}

fun writableMapOf(vararg values: Pair<String, *>): WritableMap {
  val map = Arguments.createMap()
  for ((key, value) in values) {
    when (value) {
      null -> map.putNull(key)
      is Boolean -> map.putBoolean(key, value)
      is Double -> map.putDouble(key, value)
      is Int -> map.putInt(key, value)
      is Long -> map.putDouble(key, value.toDouble())
      is String -> map.putString(key, value)
      is WritableMap -> map.putMap(key, value)
      is WritableArray -> map.putArray(key, value)
      else -> throw IllegalArgumentException("Unsupported value type ${value::class.java.name} for key [$key]")
    }
  }
  return map
}

internal fun FlyreelAnalyticEvent.toMap(): WritableMap {
  return writableMapOf(
    "user" to user.toMap(),
    "name" to name,
    "timestamp" to timestamp,
    "activeTime" to activeTime,
    "coordination" to coordination?.toMap(),
    "deviceData" to deviceData?.toMap(),
    "messageDetails" to messageDetails?.toMap()
  )
}

internal fun FlyreelAnalyticUser.toMap(): WritableMap {
  return writableMapOf(
    "id" to id,
    "name" to name,
    "email" to email,
    "botId" to botId,
    "botName" to botName,
    "organizationId" to organizationId,
    "status" to status,
    "loginType" to loginType.value
  )
}

internal fun FlyreelDeviceData.toMap(): WritableMap {
  return writableMapOf(
    "phoneManufacturer" to phoneManufacturer,
    "phoneModel" to phoneModel,
    "appVersion" to appVersion,
    "appName" to appName
  )
}

internal fun FlyreelCoordination.toMap(): WritableMap {
  return writableMapOf(
    "lat" to lat,
    "lng" to lng
  )
}

internal fun FlyreelMessageDetails.toMap(): WritableMap {
  return writableMapOf(
    "message" to message,
    "messageType" to messageType,
    "moduleKey" to moduleKey,
    "messageKey" to messageKey
  )
}
