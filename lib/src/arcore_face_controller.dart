import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'arcore_types.dart';

class ArCoreFaceController {
  ArCoreFaceController(
      {required int id, required this.enableAugmentedFaces, this.debug = false}) {
    _channel = MethodChannel('arcore_flutter_plugin_face_$id');
    _channel.setMethodCallHandler(_handleMethodCall);
    init();
  }

  final bool enableAugmentedFaces;
  final bool debug;
  late MethodChannel _channel;
  StringResultHandler? onError;

  void init() {
    _channel.invokeMethod<void>('init', {
      'enableAugmentedFaces': enableAugmentedFaces,
    });
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    if (debug) {
      print('_platformCallHandler call ${call.method} ${call.arguments}');
    }
    switch (call.method) {
      case 'onError':
        onError?.call(call.arguments);
        break;
      default:
        if (debug) {
          print('Unknown method ${call.method}');
        }
    }
    return Future.value();
  }

  void loadMesh(
      {required Uint8List textureBytes, String? skin3DModelFilename}) {
    _channel.invokeMethod('loadMesh', {
      'textureBytes': textureBytes,
      'skin3DModelFilename': skin3DModelFilename
    });
  }

  void dispose() {
    _channel.invokeMethod<void>('dispose');
  }
}

