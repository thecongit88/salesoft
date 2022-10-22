package com.vt.salesoft

import android.content.Context
import androidx.multidex.MultiDex
import io.flutter.app.FlutterApplication
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingService
import io.flutter.plugins.GeneratedPluginRegistrant

import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService





class Application: FlutterApplication(), PluginRegistrantCallback  {
    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }

    override fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this)
    }

    override fun registerWith(registry: PluginRegistry?) {
        GeneratedPluginRegistrant.registerWith(FlutterEngine(this))
    }
}


