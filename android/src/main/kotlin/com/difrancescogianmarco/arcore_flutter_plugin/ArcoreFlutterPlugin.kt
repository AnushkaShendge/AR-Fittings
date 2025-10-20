package com.difrancescogianmarco.arcore_flutter_plugin

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class ArcoreFlutterPlugin: FlutterPlugin, ActivityAware {
  private var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null
  private var activityPluginBinding: ActivityPluginBinding? = null

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    flutterPluginBinding = binding
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    flutterPluginBinding = null
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activityPluginBinding = binding
    flutterPluginBinding?.let { flutterBinding ->
      flutterBinding.platformViewRegistry.registerViewFactory(
        "arcore_flutter_plugin",
        ArCoreViewFactory(
          binding.activity,
          flutterBinding.binaryMessenger
        )
      )
    }
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    activityPluginBinding = null
  }
}