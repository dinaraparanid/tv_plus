package com.paranid5.tv_plus

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** TvPlusPlugin */
class TvPlusPlugin :
    FlutterPlugin,
    MethodCallHandler {
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {}

    override fun onMethodCall(call: MethodCall, result: Result) {}

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {}
}
