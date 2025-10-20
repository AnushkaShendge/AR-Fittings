import 'dart:typed_data';

import 'package:arcore_flutter_plugin/src/arcore_augmented_image.dart';
import 'package:arcore_flutter_plugin/src/arcore_rotating_node.dart';
import 'package:arcore_flutter_plugin/src/utils/vector_utils.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'arcore_hit_test_result.dart';

import 'arcore_node.dart';
import 'arcore_plane.dart';
import 'arcore_types.dart';

typedef UnsupportedHandler = void Function(String text);
typedef ArCoreHitResultHandler = void Function(List<ArCoreHitTestResult> hits);
typedef ArCorePlaneHandler = void Function(ArCorePlane plane);
typedef ArCoreAugmentedImageTrackingHandler = void Function(
    ArCoreAugmentedImage image);

const UTILS_CHANNEL_NAME = 'arcore_flutter_plugin/utils';

class ArCoreController {
  ArCoreController({
    required int id,
    required this.enableTapRecognizer,
    required this.enablePlaneRenderer,
    required this.enableUpdateListener,
  }) {
    _channel = MethodChannel('arcore_flutter_plugin_$id');
    _channel.setMethodCallHandler(_handleMethodCall);
    init();
  }

  final bool enableUpdateListener;
  final bool enableTapRecognizer;
  final bool enablePlaneRenderer;
  late MethodChannel _channel;
  StringResultHandler? onError;
  StringResultHandler? onNodeTap;
  ArCoreHitResultHandler? onPlaneTap;
  ArCorePlaneHandler? onPlaneDetected;
  String trackingState = '';
  ArCoreAugmentedImageTrackingHandler? onTrackingImage;

  static const MethodChannel _utils_channel =
      MethodChannel(UTILS_CHANNEL_NAME);

  static Future<bool> checkArCoreAvailability() async {
    try {
      return await _utils_channel.invokeMethod('checkArCoreAvailability');
    } on PlatformException catch (e) {
      print(e.message);
      return false;
    }
  }

  static Future<bool> checkIsArCoreInstalled() async {
    try {
      return await _utils_channel.invokeMethod('checkIsArCoreInstalled');
    } on PlatformException catch (e) {
      print(e.message);
      return false;
    }
  }

  init() async {
    try {
      await _channel.invokeMethod<void>('init', {
        'enableTapRecognizer': enableTapRecognizer,
        'enablePlaneRenderer': enablePlaneRenderer,
        'enableUpdateListener': enableUpdateListener,
      });
    } on PlatformException catch (ex) {
      print(ex.message);
    }
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onError':
        if (onError != null) {
          onError!(call.arguments);
        }
        break;
      case 'onNodeTap':
        if (onNodeTap != null) {
          onNodeTap!(call.arguments);
        }
        break;
      case 'onPlaneTap':
        if (onPlaneTap != null) {
          final List<dynamic> hits = call.arguments;
          final result = hits
              .map((hit) => ArCoreHitTestResult.fromMap(hit))
              .toList();
          onPlaneTap!(result);
        }
        break;
      case 'onPlaneDetected':
        if (onPlaneDetected != null) {
          final plane = ArCorePlane.fromMap(call.arguments);
          onPlaneDetected!(plane);
        }
        break;
      case 'onTrackingImage':
        if (onTrackingImage != null) {
          final image = _getAugmentedImage(call.arguments);
          onTrackingImage!(image);
        }
        break;
      default:
        print('Unknowm method ${call.method} ');
    }
    return Future.value();
  }

  ArCoreAugmentedImage _getAugmentedImage(Map<dynamic, dynamic> augmentedImageMap) {
    final Map<String, dynamic> geometryMap =
        Map<String, dynamic>.from(augmentedImageMap);
    return ArCoreAugmentedImage.fromMap(geometryMap);
  }

  Future<void> addArCoreNode(ArCoreNode node, {String? parentNodeName}) {
    final params = _addParentNodeNameToParams(node.toMap(), parentNodeName);
    return _channel.invokeMethod('addArCoreNode', params);
  }

  Future<String> togglePlaneRenderer() async {
    return await _channel.invokeMethod<String?>('togglePlaneRenderer') ?? '';
  }

  Future<String?> getTrackingState() async {
    return await _channel.invokeMethod<String?>('getTrackingState');
  }

  addArCoreNodeToAugmentedImage(ArCoreNode node, int index,
      {String? parentNodeName}) {
    final params = _addParentNodeNameToParams(node.toMap(), parentNodeName);
    return _channel.invokeMethod(
        'attachObjectToAugmentedImage', {'index': index, 'node': params});
  }

  Future<void> addArCoreNodeWithAnchor(ArCoreNode node,
      {String? parentNodeName}) {
    final params = _addParentNodeNameToParams(node.toMap(), parentNodeName);
    return _channel.invokeMethod('addArCoreNodeWithAnchor', params);
  }

  Future<void> removeNode({required String nodeName}) {
    assert(nodeName != null);
    return _channel.invokeMethod('removeARCoreNode', {'nodeName': nodeName});
  }

  Map<String, dynamic> _addParentNodeNameToParams(
      Map<String, dynamic> params, String? parentNodeName) {
    if (parentNodeName != null && parentNodeName.isNotEmpty) {
      params['parentNodeName'] = parentNodeName;
    }
    return params;
  }

  // NOTE: The listener pattern is removed as it's not compatible with the new immutable node structure.
  // Dynamic updates should be handled by removing and re-adding nodes with updated properties.

  Future<void> loadSingleAugmentedImage({required Uint8List bytes}) {
    return _channel.invokeMethod('load_single_image_on_db', {
      'bytes': bytes,
    });
  }

  Future<void> loadMultipleAugmentedImage(
      {required Map<String, Uint8List> bytesMap}) {
    return _channel.invokeMethod('load_multiple_images_on_db', {
      'bytesMap': bytesMap,
    });
  }

  Future<void> loadAugmentedImagesDatabase({required Uint8List bytes}) {
    return _channel.invokeMethod('load_augmented_images_database', {
      'bytes': bytes,
    });
  }

  void dispose() {
    _channel.invokeMethod<void>('dispose');
  }

  void resume() {
    _channel.invokeMethod<void>('resume');
  }

  Future<void> removeNodeWithIndex(int index) async {
    try {
      return await _channel.invokeMethod('removeARCoreNodeWithIndex', {
        'index': index,
      });
    } catch (ex) {
      print(ex);
    }
  }
}

